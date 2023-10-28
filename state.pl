:- consult(utils).
:- consult(board).
:- consult(piece).
:- consult(jump).

change_player(1,2).
change_player(2,1).

/*
    create board with specific size
*/
initial_state(Height,Width,Board) :-
    read_size_board(Height,Width),
    make_initial_board(Height,Width,Board),
    write('\n').

/*
    display board
*/
display_game(Turn,Width,Board,TotalMoves) :-
    print_board(Board,Width,Turn,TotalMoves),
    !.   % remove output true ? do terminal quando acaba de correr

/*
    cycle of the game
*/
game_cycle(Turn,Height,Width,Board,TotalMoves):-
    format('It is the turn of the player ~w.\n',Turn),
    write('Write the position of the piece you want to move.\n'),
    choose_move(Turn,Height,Width,Board,XP,YP,XM,YM),
    move(Turn,XP,YP,XM,YM,Board,TempBoard),
    check_continuous_jump_cycle(XP,YP,XM,YM,Turn,Height,Width,TempBoard,NewBoard),
    change_player(Turn,NewTurn),
    UpdatedTotalMoves is TotalMoves + 1,
    display_game(NewTurn,Width,NewBoard,UpdatedTotalMoves),

    !,
    game_cycle(NewTurn,Height,Width,NewBoard,UpdatedTotalMoves).


/*
codigo slides stor

game_cycle(Turn,Height,Width,Board,_):- 
    game_over(Board,Width,Height,Turn,Winner), 
    !, 
    congratulate(Winner).

game_over(Board,Width,Height,Turn,Winner) :-
    WinnerCandidate is mod(Turn,2) + 1,     % necessário verificar se o oponente ganha primeiro devido as regras do jogo
    X is 1,
    Y is 1,
    check_winner(Board,Width,Height,X,Y,WinnerCandidate,Winner).

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

    


