:- use_module(library(lists)).

/*
    begining teacher code
*/
read_number(BoardSize) :-
    read_number_aux(0,false,BoardSize).

read_number_aux(Acc,_,BoardSize) :-
    get_code(Input),
    Input >= 48,    % '0'
    Input =< 57,    % '9'
    !,
    Acc1 is 10*Acc + (Input-48),
    read_number_aux(Acc1, true, BoardSize)
.
read_number_aux(BoardSize,true,BoardSize).
/*
    ending teacher code
*/

program :-
    Turn is 1,
    initial_state(BoardSize,Board),
    display_game(Turn,BoardSize,Board).

/*
    create board with specific size
*/
initial_state(BoardSize,Board) :-
    write('Write the size of the board (between 5 and 15)\n'),
    read_size_board(BoardSize),
    make_initial_board(BoardSize, Board),
    write('\n').

/*
    read size board and check if it is valid
*/
read_size_board(BoardSize) :-
    repeat,
    write('It has to be between 5 and 15: '),
    read_number(BoardSize),
    BoardSize>=5,
    BoardSize=<15,
    !.
/*
    display board
*/
display_game(Turn,BoardSize,Board) :-
    print_board(Board, BoardSize),
    format('It is the turn of the player ~w.\n',Turn),
    !.   % remove output true ? do terminal quando acaba de correr

/*
    create initial board
*/
make_initial_board(BoardSize, Board) :-
    make_board_filler_initial(BoardFiller,BoardSize),
    make_board_player_initial(1,PlayerOneBoard,BoardSize),
    make_board_player_initial(2,PlayerTwoBoard,BoardSize),
    append(PlayerOneBoard,BoardFiller,TempBoard),
    append(TempBoard,PlayerTwoBoard,Board).

make_board_filler_initial(BoardFiller,BoardSize):-
    BoardSizeFiller is BoardSize-4,
    length(LineFiller,BoardSize),
    maplist(=(0), LineFiller),
    length(BoardFiller,BoardSizeFiller),
    maplist(=(LineFiller), BoardFiller).

make_board_player_initial(Player,PlayerBoard,BoardSize) :-
    RowSizeRow is BoardSize-2,
    length(InitialRow, RowSizeRow),
    maplist(=(Player), InitialRow),
    append([0],InitialRow,MidleRow),
    append(MidleRow,[0],EndingRow),
    append([EndingRow],[EndingRow],PlayerBoard).


/*
    print board in the console
*/
print_board(Board, BoardSize) :-
    print_board_top_coordinates(BoardSize),
    write('\n'),
    print_board_content(Board, BoardSize, 1).

/*
    print top coordinates of the board
*/
print_board_top_coordinates(BoardSize) :-
    print_board_top_coordinates_aux(BoardSize, 1).

print_board_top_coordinates_aux(0,_).
print_board_top_coordinates_aux(BoardSize, CurrentCoordinate) :-
    BoardSize > 0,
    CoordinateAscii is CurrentCoordinate + 96,  % 'a' ASCII é 97 e coordenada começa em 1
    atom_codes(Coordinate, [CoordinateAscii]),  % convert codigo ASCII para string
    format('  ~s ', Coordinate),
    BoardSize1 is BoardSize - 1,
    CurrentCoordinate1 is CurrentCoordinate + 1,
    print_board_top_coordinates_aux(BoardSize1, CurrentCoordinate1). 

/*
    print content of the board
*/
print_board_content([], BoardSize,_) :- 
    print_limiter(_,BoardSize),
    write('\n').
print_board_content([H|T], BoardSize,Line) :-
    print_limiter(_, BoardSize),
    print_line(H,Line),
    Line1 is Line+1,
    print_board_content(T, BoardSize,Line1).


/*
    print line of the board
*/
print_line(Content,Line) :-
    print_line_content(Content),
    format('| ~w\n',Line).

/*
    print content of the line of the board
*/
print_line_content([]).
print_line_content([H|T]) :-
    format('| ~w ',H),
    print_line_content(T).

/*
    create squares to separate the content of the board
*/
print_limiter(_, BoardSize) :-
    print_limiter_aux(0, BoardSize).

print_limiter_aux(Pos,Max) :-
    Pos<Max,
    write('----'),
    Pos1 is Pos+1,
    print_limiter_aux(Pos1,Max).
print_limiter_aux(Max,Max) :-
    write('-'),
    write('\n').