:- consult(utils).
:- consult(board).

/*
    create board with specific size
*/
initial_state(BoardSize,Board) :-
    write('Write the size of the board (between 5 and 15)\n'),
    read_size_board(BoardSize),
    make_initial_board(BoardSize, Board),
    write('\n').

/*
    display board
*/
display_game(Turn,BoardSize,Board) :-
    print_board(Board, BoardSize),
    format('It is the turn of the player ~w.\n',Turn),
    !.   % remove output true ? do terminal quando acaba de correr
