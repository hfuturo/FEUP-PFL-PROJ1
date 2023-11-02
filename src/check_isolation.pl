/*
    Calcula o nivel de isolamento que se pode atingir com cada movimento possivel a partir de uma peça, preenchendo XM e YM com as coordenadas da mulher opção
    best_piece_move(+GameState,+X,+Y,-XM,-YM) :-
*/
best_piece_move(GameState,X,Y,XM,YM) :-
    calculate_distances(X,Y,GameState,Distances),
    nth1(1,Distances,JumpColumn),
    nth1(2,Distances,JumpRow),
    nth1(3,Distances,JumpNESW),
    nth1(4,Distances,JumpNWSE),

    XLeft is X-JumpRow, 
    XRight is X+JumpRow,
    YUp is Y-JumpColumn, 
    YDown is Y+JumpColumn,

    XSW is X-JumpNESW, 
    XNE is X+JumpNESW, 
    YNE is Y-JumpNESW, 
    YSW is Y+JumpNESW,
    XNW is X-JumpNWSE, 
    XSE is X+JumpNWSE, 
    YNW is Y-JumpNWSE, 
    YSE is Y+JumpNWSE,

    get_piece_isolation(XLeft,Y,Value1,GameState,1),
    get_piece_isolation(XRight,Y,Value2,GameState,1),
    get_piece_isolation(X,YUp,Value3,GameState,1),
    get_piece_isolation(X,YDown,Value4,GameState,1),
    get_piece_isolation(XNE,YNE,Value5,GameState,1),
    get_piece_isolation(XSW,YSW,Value6,GameState,1),
    get_piece_isolation(XNW,YNW,Value7,GameState,1),
    get_piece_isolation(XSE,YSE,Value8,GameState,1),
    
    append([[XLeft,Y],[XRight,Y],[X,YUp],[X,YDown],[XNE,YNE],[XSW,YSW],[XNW,YNW],[XSE,YSE]],[],Moves),
    append([Value1,Value2,Value3,Value4,Value5,Value6,Value7,Value8],[],Values),

    min_member(Min,Values),
    
    findall(
        [BestMoveIndex],
        nth1(BestMoveIndex,Values,Min),
        BestMovesIndexes
    ),

    length(BestMovesIndexes,BestMovesLen),
    UpdatedBestMovesLen is BestMovesLen + 1,
    random(1,UpdatedBestMovesLen,SelectedBestMove),
    nth1(SelectedBestMove,BestMovesIndexes,MoveTemp),
    nth1(1,MoveTemp,MoveIndex),
    nth1(MoveIndex,Moves,SelectedMove),
    nth1(1,SelectedMove,XM),
    nth1(2,SelectedMove,YM),

    !.

/*
    Verifica o nivel de isolamento de uma peça
    Se o Bool for 1, verifica-se se o valor que está nessas coordenadas é igual ao player 
        -> util para quando se usa este predicado para calcular o nivel de isolamento de um movimento, que caso seja para uma "casa" ocupada por uma peça do mesmo jogador, torna-se impossivel e por isso define-se como isolamento minimo;
    Se o Bool for 0, não se verifica isto
        -> util para descobrir qual a peça menos ou mais isolada.
    get_piece_isolation(+X,+Y,-Value,+GameState,+Bool) 
*/
get_piece_isolation(X,Y,Value,GameState,_) :-
    \+check_inside_board(X,Y,GameState),
    Value is 8,
    !.

get_piece_isolation(X,Y,Value,(Board,Turn,_),1) :- 
    get_piece_value(X,Y,(Board,Turn,_),Piece),
    Piece is Turn,
    Value is 8,
    !.

get_piece_isolation(X,Y,Value,(Board,Turn,_),_) :-
    XM is X-1,
    XP is X+1,
    YM is Y-1,
    YP is Y+1,

    /* row */
    get_piece_value(XM,Y,Board,Piece1),
    get_piece_value(XP,Y,Board,Piece2),

    /* column */
    get_piece_value(X,YM,Board,Piece3),
    get_piece_value(X,YP,Board,Piece4),

    /* diagonal */
    get_piece_value(XM,YM,Board,Piece5),
    get_piece_value(XP,YP,Board,Piece6),
    get_piece_value(XM,YP,Board,Piece7),
    get_piece_value(XP,YM,Board,Piece8),

    append([Piece1,Piece2,Piece3,Piece4,Piece5,Piece6,Piece7,Piece8],[],Isolation),
    delete(Isolation,Turn,NewIsolation),
    length(Isolation,Number),
    length(NewIsolation,NewNumber),
    Value is Number-NewNumber,
    !.

/*
    Indica o valor da peça que se encontra nas coordenadas X e Y, sendo 0 caso a peça esteja fora do tabuleiro
    get_piece_value(+X,+Y,+Board,-Piece)
*/
get_piece_value(X,Y,Board,Piece) :-
    check_inside_board(X,Y,(Board,_,_)),
    get_position_piece(X,Y,Board,Piece).

get_piece_value(_,_,_,0).
