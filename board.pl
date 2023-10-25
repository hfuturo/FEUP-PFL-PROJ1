:- use_module(library(lists)).

:- consult(utils).

/*
    create initial board
*/
make_initial_board(Hight,Wide, Board) :-
    make_board_filler_initial(BoardFiller,Hight,Wide),
    make_board_player_initial(1,PlayerOneBoard,Wide),
    make_board_player_initial(2,PlayerTwoBoard,Wide),
    append(PlayerOneBoard,BoardFiller,TempBoard),
    append(TempBoard,PlayerTwoBoard,Board).

make_board_filler_initial(BoardFiller,Hight,Wide):-
    HightFiller is Hight-4,
    length(LineFiller,Wide),
    maplist(=(0), LineFiller),
    length(BoardFiller,HightFiller),
    maplist(=(LineFiller), BoardFiller).

make_board_player_initial(Player,PlayerBoard,Wide) :-
    RowWide is Wide-2,
    length(InitialRow, RowWide),
    maplist(=(Player), InitialRow),
    append([0],InitialRow,MidleRow),
    append(MidleRow,[0],EndingRow),
    append([EndingRow],[EndingRow],PlayerBoard).


/*
    print board in the console
*/
print_board(Board,Wide,Turn,TotalMoves) :-
    print_board_top_coordinates(Wide),
    write('\n'),
    print_board_content(Board,Wide,1),
    print_turn(Turn),
    print_total_moves(TotalMoves).

/*
    print current player turn
*/
print_turn(Turn) :-
    format('Player turn: ~w          ', [Turn]).

/*
    print the total number of moves made in this game.
*/
print_total_moves(TotalMoves) :-
    format('Moves: ~w~n~n', [TotalMoves]).

/*
    print top coordinates of the board
*/
print_board_top_coordinates(Wide) :-
    print_board_top_coordinates_aux(Wide, 1).

print_board_top_coordinates_aux(0,_).
print_board_top_coordinates_aux(Wide, CurrentCoordinate) :-
    Wide > 0,
    CoordinateAscii is CurrentCoordinate + 96,  % 'a' ASCII é 97 e coordenada começa em 1
    atom_codes(Coordinate, [CoordinateAscii]),  % convert codigo ASCII para string
    format('  ~s ', Coordinate),
    Wide1 is Wide - 1,
    CurrentCoordinate1 is CurrentCoordinate + 1,
    print_board_top_coordinates_aux(Wide1, CurrentCoordinate1). 

/*
    print content of the board
*/
print_board_content([],Wide,_) :- 
    print_limiter(Wide).
print_board_content([H|T],Wide,Line) :-
    print_limiter(Wide),
    print_line(H,Line),
    Line1 is Line+1,
    print_board_content(T,Wide,Line1).
