/*
    Verifica se há algum continuous jump que se pode fazer, e se sim diz preenche XM e YM com as coordenadas da nova posição
    check_isolation_jump(+Turn,+Height,+Width,+Board,+X,+Y,-XM,-YM,-Min,+VisitedPositions)
*/
check_isolation_jump(Turn,Height,Width,Board,X,Y,XM,YM,Min,VisitedPositions) :-
    calculate_distances(X,Y,Turn,Height,Width,Board,Distances),
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

    check_isolation_move(XLeft,Y,Value1,Height,Width,Board,Turn,1),
    check_isolation_move(XRight,Y,Value2,Height,Width,Board,Turn,1),
    check_isolation_move(X,YUp,Value3,Height,Width,Board,Turn,1),
    check_isolation_move(X,YDown,Value4,Height,Width,Board,Turn,1),
    check_isolation_move(XNE,YNE,Value5,Height,Width,Board,Turn,1),
    check_isolation_move(XSW,YSW,Value6,Height,Width,Board,Turn,1),
    check_isolation_move(XNW,YNW,Value7,Height,Width,Board,Turn,1),
    check_isolation_move(XSE,YSE,Value8,Height,Width,Board,Turn,1),

    append([[Value1,XLeft,Y,JumpColumn],[Value2,XRight,Y,JumpColumn],[Value3,X,YUp,JumpRow],[Value4,X,YDown,JumpRow],[Value5,XNE,YNE,JumpNESW],[Value6,XSW,YSW,JumpNESW],[Value7,XNW,YNW,JumpNWSE],[Value8,XSE,YSE,JumpNWSE]],[],Moves),
    findall(
        [Value, XT, YT], 
        (
            member([Value, XT, YT, LineDistance], Moves), 
            \+ member([XT, YT], VisitedPositions),
            X>=1,
            X=<Width,
            Y>=1,
            Y=<Height,
            LineDistance>1 % single step
        ),
        PossibleMoves
    ),
    length(PossibleMoves,Number),
    Number =\= 0,
    !,
    sort(PossibleMoves,SortedPossibleMoves),
    nth1(1,SortedPossibleMoves,Elem),
    nth1(1,Elem,Min),nth1(2,Elem,XM),nth1(3,Elem,YM).

check_isolation_jump(_,_,_,_,_,_,XM,YM,Min,_) :- XM is 0, YM is 0, Min is 8.

/*
    Calcula o nivel de isolamento que se pode atingir com cada movimento possivel a partir de uma peça, preenchendo XM e YM com as coordenadas da mulher opção
    check_isolation_piece(+Turn,+Height,+Width,+Board,+X,+Y,-XM,-YM) :-
*/
check_isolation_piece(Turn,Height,Width,Board,X,Y,XM,YM) :-
    calculate_distances(X,Y,Turn,Height,Width,Board,Distances),
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

    check_isolation_move(XLeft,Y,Value1,Height,Width,Board,Turn,1),
    check_isolation_move(XRight,Y,Value2,Height,Width,Board,Turn,1),
    check_isolation_move(X,YUp,Value3,Height,Width,Board,Turn,1),
    check_isolation_move(X,YDown,Value4,Height,Width,Board,Turn,1),
    check_isolation_move(XNE,YNE,Value5,Height,Width,Board,Turn,1),
    check_isolation_move(XSW,YSW,Value6,Height,Width,Board,Turn,1),
    check_isolation_move(XNW,YNW,Value7,Height,Width,Board,Turn,1),
    check_isolation_move(XSE,YSE,Value8,Height,Width,Board,Turn,1),
    
    append([[XLeft,Y],[XRight,Y],[X,YUp],[X,YDown],[XNE,YNE],[XSW,YSW],[XNW,YNW],[XSE,YSE]],[],Moves),
    append([Value1,Value2,Value3,Value4,Value5,Value6,Value7,Value8],[],Values),

    min_member(Min,Values),
    nth1(Index,Values,Min),
    nth1(Index,Moves,Elem),
    nth1(1,Elem,XM),
    nth1(2,Elem,YM),

    !.

/*
    Verifica o nivel de isolamento de uma peça
    Se o Bool for 1, verifica-se se o valor que está nessas coordenadas é igual ao player 
        -> util para quando se usa este predicado para calcular o nivel de isolamento de um movimento, que caso seja para uma "casa" ocupada por uma peça do mesmo jogador, torna-se impossivel e por isso define-se como isolamento minimo;
    Se o Bool for 0, não se verifica isto
        -> util para descobrir qual a peça menos ou mais isolada.
    check_isolation_move(+X,+Y,-Value,+Height,+Width,+Board,+Turn,+Bool) 
*/
check_isolation_move(X,Y,Value,Height,Width,_,_,_) :-
    (
        X<1;
        X>Width;
        Y<1;
        Y>Height
    ),
    Value is 8,
    !.

check_isolation_move(X,Y,Value,Height,Width,Board,Turn,1) :- 
    get_position_piece_check(X,Y,Height,Width,Board,Piece),
    Piece is Turn,
    Value is 8,
    !.

check_isolation_move(X,Y,Value,Height,Width,Board,Turn,_) :-
    XM is X-1,
    XP is X+1,
    YM is Y-1,
    YP is Y+1,

    /* row */
    get_position_piece_check(XM,Y,Height,Width,Board,Piece1),
    get_position_piece_check(XP,Y,Height,Width,Board,Piece2),

    /* column */
    get_position_piece_check(X,YM,Height,Width,Board,Piece3),
    get_position_piece_check(X,YP,Height,Width,Board,Piece4),

    /* diagonal */
    get_position_piece_check(XM,YM,Height,Width,Board,Piece5),
    get_position_piece_check(XP,YP,Height,Width,Board,Piece6),
    get_position_piece_check(XM,YP,Height,Width,Board,Piece7),
    get_position_piece_check(XP,YM,Height,Width,Board,Piece8),

    append([Piece1,Piece2,Piece3,Piece4,Piece5,Piece6,Piece7,Piece8],[],Isolation),
    delete(Isolation,Turn,NewIsolation),

    length(Isolation,Number),
    length(NewIsolation,NewNumber),
    Value is Number-NewNumber.

/*
    Indica o valor da peça que se encontra nas coordenadas X e Y, sendo 0 caso a peça esteja fora do tabuleiro
    get_position_piece_check(+X,+Y,+Height,+Width,+Board,-Piece)
*/
get_position_piece_check(X,Y,Height,Width,Board,Piece) :-
    (
        (X>=1,X=<Width),
        (Y>=1,Y=<Height)
    ),
    get_position_piece(X,Y,Board,Piece).

get_position_piece_check(_,_,_,_,_,0).
