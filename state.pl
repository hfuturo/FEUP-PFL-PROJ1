:- consult(utils).
:- consult(board).
:- consult(piece).
:- consult(jump).

change_player(1,2).
change_player(2,1).

/*
    criar um tabuleiro com um tamanho especifico
*/
initial_state(Height,Width,Board) :-
    read_size_board(Height,Width),
    make_initial_board(Height,Width,Board),
    write('\n').

/*
    print do tabuleiro
*/
display_game(Turn,Width,Board,TotalMoves) :-
    print_board(Board,Width,Turn,TotalMoves),
    !.   % remove output true ? do terminal quando acaba de correr

/*
    verificar se o jogo acabou e congratular o vencedor
*/
game_cycle(Turn,Height,Width,Board,_):- 
    game_over(Board,Width,Height,Turn,Winner), 
    !, 
    congratulate(Winner).

/*
    ciclo do jogo
*/
game_cycle(Turn,Height,Width,Board,TotalMoves):-
    format('It is the turn of the player ~w.\n',Turn),
    write('Write the position of the piece you want to move.\n'),
    choose_move(Turn,Height,Width,Board,XP,YP,XM,YM,TotalMoves),
    move(Turn,XP,YP,XM,YM,Board,TempBoard),
    UpdatedTotalMoves is TotalMoves + 1,
    check_continuous_jump_cycle(XP,YP,XM,YM,Turn,Height,Width,UpdatedTotalMoves,TempBoard,NewBoard),
    change_player(Turn,NewTurn),
    UpdatedTotalMoves is TotalMoves + 1,
    display_game(NewTurn,Width,NewBoard,UpdatedTotalMoves),
    !,
    game_cycle(NewTurn,Height,Width,NewBoard,UpdatedTotalMoves).

/*
    verificar se o jogo acabou, e se sim ver quem ganhou
*/
game_over(Board,Width,Height,Turn,Winner) :-
    change_player(Turn,NewTurn),
    Y is 1,
    check_winner(Board,Width,Height,Y,Turn,FirstWinner),
    FirstWinner is 0,
    !,
    check_winner(Board,Width,Height,Y,NewTurn,SecondWinner),
    SecondWinner is 1,
    Winner is NewTurn.

game_over(_,_,_,Turn,Turn).

/*
    verificar se jogador venceu
*/
check_winner(Board,Width,Height,Y,Player,BoardWinner) :-
    Y =< Height,
    X is 1,
    check_winner_row(Board,Width,Height,Y,X,Player,Winner),
    Winner is 1,
    NY is Y+1,
    check_winner(Board,Width,Height,NY,Player,BoardWinner),
    !.

check_winner(_,_,Height,Y,_,1) :- Y > Height.
check_winner(_,_,_,_,_,BoardWinner) :- BoardWinner is 0.

check_winner_row(Board,Width,Height,Y,X,Player,RowWinner) :-
    X =< Width,
    check_winner_piece(Board,Width,Height,Y,X,Player,Winner),
    Winner is 1,
    NX is X+1,
    check_winner_row(Board,Width,Height,Y,NX,Player,RowWinner),
    !.

check_winner_row(_,Width,_,_,X,_,1) :- X > Width.
check_winner_row(_,_,_,_,_,_,RowWinner) :- RowWinner is 0.

check_winner_piece(Board,Width,Height,Y,X,Player,PieceWinner) :-
    nth1(Y,Board,Row),
    nth1(X,Row,Value),
    Value is Player,
    XUP is X+1,
    XDOWN is X-1,
    YUP is Y+1,
    YDOWN is Y-1,

    /* SAME ROW */
    check_adjacent_pieces(Board,Width,Height,Y,XUP,Player,Winner1),
    check_adjacent_pieces(Board,Width,Height,Y,XDOWN,Player,Winner2),
    /* SAME COLUMN */
    check_adjacent_pieces(Board,Width,Height,YUP,X,Player,Winner3),
    check_adjacent_pieces(Board,Width,Height,YDOWN,X,Player,Winner4),
    /* SAME DIAGONAL CRESCENTE */
    check_adjacent_pieces(Board,Width,Height,YUP,XUP,Player,Winner5),
    check_adjacent_pieces(Board,Width,Height,YDOWN,XDOWN,Player,Winner6),
    /* SAME DIAGONAL DECRESCENTE */
    check_adjacent_pieces(Board,Width,Height,YUP,XDOWN,Player,Winner7),
    check_adjacent_pieces(Board,Width,Height,YDOWN,XUP,Player,Winner8),

    (
        Winner1 is 0;
        Winner2 is 0;
        Winner3 is 0;
        Winner4 is 0;
        Winner5 is 0;
        Winner6 is 0;
        Winner7 is 0;
        Winner8 is 0
    ),
    PieceWinner is 0,
    !.

check_winner_piece(_,_,_,_,_,_,1).

check_adjacent_pieces(Board,Width,Height,Y,X,Player,Winner) :-
    Y =< Height,
    Y >= 1,
    X =< Width,
    X >= 1,
    nth1(Y,Board,Row),
    nth1(X,Row,Value),
    Value is Player,
    Winner is 0,
    !.

check_adjacent_pieces(_,_,_,_,_,_,1) .


/*
check_winner(Board,Width,Height,Width,Y,Player,Winner) :-
    Y =< Height,
    nth1(Y,Board,Row),
    nth1(X,Row,XVal),
    check_adjacent_pieces(Width,Height,X,Y,XVal,Player),
    UpdatedX is 1,
    UpdatedY is Y + 1,
    check_winner(Board,Width,Height,UpdatedX,UpdatedY,Player,Winner).

check_winner(Board,Width,Height,X,Y,Player,Winner) :-
    X =< Width,
    Y =< Height,
    nth1(Y,Board,Row),
    nth1(X,Row,XVal),
    check_adjacent_pieces(Width,Height,X,Y,XVal,Player),
    UpdatedX is X + 1,
    check_winner(Board,Width,Height,UpdatedX,Y,Player,Winner).

% canto superior esquerdo
check_adjacent_pieces(_,_,1,1,XVal,Player) :-
    XVal is Player,
    Below is 2, % 1 + 1
    Right is 2, % 1 + 1
    get_piece_from_position(Board,Right,1,PieceRight),
    XVal =\= PieceRight,
    get_piece_from_position(Board,Right,Below,PieceBottomRight),
    XVal =\= PieceBottomRight,
    get_piece_from_position(Board,1,Below,PieceBelow),
    XVal =\= PieceBelow,
    !.

% canto superior direito
check_adjacent_pieces(_,_,Width,1,XVal,Player) :-
    XVal is Player,
    Below is 2,     % 1 + 1
    Left is Width - 1,
    get_piece_from_position(Board,Width,Below,PieceBelow),
    XVal =\= PieceBelow,
    get_piece_from_position(Board,Left,Below,PieceBottomLeft),
    XVal =\= PieceBottomLeft,
    get_piece_from_position(Board,Left,1,PieceLeft),
    XVal =\= PieceLeft,
    !.

% canto inferior esquerdo
check_adjacent_pieces(_,_,1,Height,XVal,Player) :-
    XVal is Player,
    Above is Height - 1,
    Right is 2,     % 1 + 1
    get_piece_from_position(Board,1,Above,PieceAbove),
    XVal =\= PieceAbove,
    get_piece_from_position(Board,Right,Above,PieceTopRight),
    XVal =\= PieceTopRight,
    get_piece_from_position(Board,Right,Height,PieceRight),
    XVal =\= PieceRight,
    !.

% canto inferior direito
check_adjacent_pieces(_,_,Width,Height,XVal,Player) :-
    XVal is Player,
    Above is Height - 1,
    Left is Width - 1,
    get_piece_from_position(Board,Left,Height,PieceLeft),
    XVal =\= PieceLeft,
    get_piece_from_position(Board,Left,Above,PieceTopLeft),
    XVal =\= PieceTopLeft,
    get_piece_from_position(Board,Width,Above,PieceAbove),
    XVal =\= PieceAbove,
    !.

% encostado a board do lado esquerdo
check_adjacent_pieces(_,_,1,Y,XVal,Player) :-
    XVal is Player,
    Above is Y - 1,
    Below is Y + 1,
    Right is 2,     % 1 + 1
    get_piece_from_position(Board,1,Above,PieceAbove),
    XVal =\= PieceAbove,
    get_piece_from_position(Board,Right,Above,PieceTopRight),
    XVal =\= PieceTopRight,
    get_piece_from_position(Board,Right,Y,PieceRight),
    XVal =\= PieceRight,
    get_piece_from_position(Board,Right,Below,PieceBottomRight),
    XVal =\= PieceBottomRight,
    get_piece_from_position(Board,1,Below,PieceBelow),
    XVal =\= PieceBelow,
    !.

% encostado a board do lado direito
check_adjacent_pieces(_,_,Width,Y,XVal,Player) :-
    XVal is Player,
    Above is Y - 1,
    Below is Y + 1,
    Left is Width - 1,
    get_piece_from_position(Board,Width,Above,PieceAbove),
    XVal =\= PieceAbove,
    get_piece_from_position(Board,Width,Below,PieceBelow),
    XVal =\= PieceBelow,
    get_piece_from_position(Board,Left,Below,PieceBottomLeft),
    XVal =\= PieceBottomLeft,
    get_piece_from_position(Board,Left,Y,PieceLeft),
    XVal =\= PieceLeft,
    get_piece_from_position(Board,Left,Above,PieceTopLeft),
    XVal =\= PieceTopLeft,
    !.

% encostado a board em cima
check_adjacent_pieces(_,_,X,1,XVal,Player) :-
    XVal is Player,
    Below is 2,     % 1 + 1
    Left is X - 1,
    Right is X + 1,
    get_piece_from_position(Board,Right,1,PieceRight),
    XVal =\= PieceRight,
    get_piece_from_position(Board,Right,Below,PieceBottomRight),
    XVal =\= PieceBottomRight,
    get_piece_from_position(Board,X,Below,PieceBelow),
    XVal =\= PieceBelow,
    get_piece_from_position(Board,Left,Below,PieceBottomLeft),
    XVal =\= PieceBottomLeft,
    get_piece_from_position(Board,Left,1,PieceLeft),
    XVal =\= PieceLeft,
    !.

% encostado a board em baixo
check_adjacent_pieces(_,_,X,Height,XVal,Player) :-
    XVal is Player,
    Above is Height - 1,
    Left is X - 1,
    Right is X + 1,
    get_piece_from_position(Board,X,Above,PieceAbove),
    XVal =\= PieceAbove,
    get_piece_from_position(Board,Right,Above,PieceTopRight),
    XVal =\= PieceTopRight,
    get_piece_from_position(Board,Right,Height,PieceRight),
    XVal =\= PieceRight,
    get_piece_from_position(Board,Left,Height,PieceLeft),
    XVal =\= PieceLeft,
    get_piece_from_position(Board,Left,Above,PieceTopLeft),
    XVal =\= PieceTopLeft,
    !.

check_adjacent_pieces(_,_,X,Y,XVal,Player) :-
    XVal is Player,
    Above is Y - 1,
    Below is Y + 1,
    Left is X - 1,
    Right is X + 1,
    get_piece_from_position(Board,X,Above,PieceAbove),
    XVal =\= PieceAbove,
    get_piece_from_position(Board,Right,Above,PieceTopRight),
    XVal =\= PieceTopRight,
    get_piece_from_position(Board,Right,Y,PieceRight),
    XVal =\= PieceRight,
    get_piece_from_position(Board,Right,Below,PieceBottomRight),
    XVal =\= PieceBottomRight,
    get_piece_from_position(Board,X,Below,PieceBelow),
    XVal =\= PieceBelow,
    get_piece_from_position(Board,Left,Below,PieceBottomLeft),
    XVal =\= PieceBottomLeft,
    get_piece_from_position(Board,Left,Y,PieceLeft),
    XVal =\= PieceLeft,
    get_piece_from_position(Board,Left,Above,PieceTopLeft),
    XVal =\= PieceTopLeft.

get_piece_from_position(Board,X,Y,Piece) :-
    nth1(Y,Board,Row),
    nth1(X,Row,Piece).


*/

congratulate(Winner) :-
    format('Player ~w won!',Winner).
