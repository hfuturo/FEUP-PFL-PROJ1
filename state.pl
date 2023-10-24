:- consult(utils).
:- consult(board).

/*
    create board with specific size
*/
initial_state(Hight,Wide,Board) :-
    read_size_board(Hight,Wide),
    make_initial_board(Hight,Wide,Board),
    write('\n').

/*
    display board
*/
display_game(Turn,Wide,Board) :-
    print_board(Board,Wide),
    format('It is the turn of the player ~w.\n',Turn),
    !.   % remove output true ? do terminal quando acaba de correr
