/*
    vê o nivel de isolamento para cada jogada possivel
*/
check_isolation_piece(Turn,Height,Width,Board,X,Y,XM,YM,Min) :-
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

    check_isolation_move(XLeft,Y,Value1,Height,Width,Board,Turn),
    check_isolation_move(XRight,Y,Value2,Height,Width,Board,Turn),
    check_isolation_move(X,YUp,Value3,Height,Width,Board,Turn),
    check_isolation_move(X,YDown,Value4,Height,Width,Board,Turn),
    check_isolation_move(XNE,YNE,Value5,Height,Width,Board,Turn),
    check_isolation_move(XSW,YSW,Value6,Height,Width,Board,Turn),
    check_isolation_move(XNW,YNW,Value7,Height,Width,Board,Turn),
    check_isolation_move(XSE,YSE,Value8,Height,Width,Board,Turn),
    
    append([[XLeft,Y],[XRight,Y],[X,YUp],[X,YDown],[XNE,YNE],[XSW,YSW],[XNW,YNW],[XSE,YSE]],[],Moves),
    append([Value1,Value2,Value3,Value4,Value5,Value6,Value7,Value8],[],Values),

    min_member(Min,Values),
    nth1(Index,Values,Min),
    nth1(Index,Moves,Elem),
    nth1(1,Elem,XM),
    nth1(2,Elem,YM),

    !.

/*
    vê o nivel de isolamento de uma peça, mas se o valor dela for o Player, isolamento é 0
*/
check_isolation_move(X,Y,Value,Height,Width,_,_) :-
    (
        X<1;
        X>Width;
        Y<1;
        Y>Height
    ),
    Value is 8,
    !.


check_isolation_move(X,Y,Value,Height,Width,Board,Turn) :- 
    get_position_piece_check(X,Y,Height,Width,Board,Piece),
    Piece is Turn,
    Value is 8,
    !.

/*
    vê o nivel de isolamento de uma peça
*/
check_isolation_move(X,Y,Value,Height,Width,Board,Turn) :-
%write('entra    \n'),
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

    write(Isolation),nl,write(NewIsolation),nl,

    length(Isolation,Number),
    length(NewIsolation,NewNumber),
    Value is Number-NewNumber.

/*
    valor numa posição retornando 0 se for fora do board (util para calcular isolamento)
*/
get_position_piece_check(X,Y,Height,Width,Board,Piece) :-
    (
        (X>=1,X=<Width),
        (Y>=1,Y=<Height)
    ),
    nth1(Y,Board,Row),
    nth1(X,Row,Piece).

get_position_piece_check(_,_,_,_,_,0).
