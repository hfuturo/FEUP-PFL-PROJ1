:- use_module(library(lists)).

:- consult(utils).

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
