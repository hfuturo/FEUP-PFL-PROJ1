:- use_module(library(lists)).
:- consult(check_move).
:- consult(line_distance).
:- consult(piece).

/*
    vê o nivel de isolamento para cada jogada possivel
*/
select_greddy_move(Turn,Height,Width,Board,X,Y,XM,YM) :-
    calculate_distances(X,Y,Turn,Height,Width,Board,Distances),
    nth1(1,Distances,JumpRow),
    nth1(2,Distances,JumpColumn),
    nth1(3,Distances,JumpNESW),
    nth1(4,Distances,JumpNWSE),

    XM is X-1, XP is X+1, YM is Y-1, YP is Y+1,   
    XJRM is X-JumpRow, XJRP is X+JumpRow,
    YJCM is X-JumpColumn, YJCP is X+JumpColumn,
    XJDSW is X-JumpNESW, XJDNE is X+JumpNESW, YJDNE is Y-JumpNESW, YJDSW is Y+JumpNESW,
    XJDNW is X-JumpNWSE, XJDSE is X+JumpNWSE, YJDNW is Y-JumpNWSE, YJDSE is Y+JumpNWSE,

    /* row */
    check_isolation_piece(XM,Y,Value1,Height,Width,Board,Turn),
    check_isolation_piece(XP,Y,Value2,Height,Width,Board,Turn),

    /* column */
    check_isolation_piece(X,YM,Value3,Height,Width,Board,Turn),
    check_isolation_piece(X,YP,Value4,Height,Width,Board,Turn),

    /* diagonal */
    check_isolation_piece(XM,YM,Value5,Height,Width,Board,Turn),
    check_isolation_piece(XP,YP,Value6,Height,Width,Board,Turn),
    check_isolation_piece(XM,YP,Value7,Height,Width,Board,Turn),
    check_isolation_piece(XP,YM,Value8,Height,Width,Board,Turn),

    /* jump */

    check_isolation_piece(XJRM,Y,Value9,Height,Width,Board,Turn),
    check_isolation_piece(XJRP,Y,Value10,Height,Width,Board,Turn),

    check_isolation_piece(X,YJCM,Value11,Height,Width,Board,Turn),
    check_isolation_piece(X,YJCP,Value12,Height,Width,Board,Turn),

    check_isolation_piece(XJDNE,YJDNE,Value13,Height,Width,Board,Turn),
    check_isolation_piece(XJDSW,YJDSW,Value14,Height,Width,Board,Turn),
    check_isolation_piece(XJDNW,YJDNW,Value15,Height,Width,Board,Turn),
    check_isolation_piece(XJDSE,YJDSE,Value16,Height,Width,Board,Turn).

/*
    vê o nivel de isolamento de uma peça, mas se o valor dela for o Player, isolamento é 0
*/
check_isolation_piece(X,Y,Value,Height,Width,Board,Turn) :- 
    get_position_piece_check(X,Y,Height,Width,Board,Piece),
    Piece is Turn,
    Value is 0,
    !.
/*
    vê o nivel de isolamento de uma peça
*/
check_isolation_piece(X,Y,Value,Height,Width,Board,Turn) :-
    (
        (X>=1,X=<Width),
        (Y>=1,Y=<Height)
    ),
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

check_isolation_piece(_,_,_,_,_,_,_,0).

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
