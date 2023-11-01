:- use_module(library(lists)).

/*
    create initial board
*/
make_initial_board(Height,Width, Board) :-
    make_board_filler_initial(BoardFiller,Height,Width),
    make_board_player_initial(1,PlayerOneBoard,Width),
    make_board_player_initial(2,PlayerTwoBoard,Width),
    append(PlayerOneBoard,BoardFiller,TempBoard),
    append(TempBoard,PlayerTwoBoard,Board).

make_board_filler_initial(BoardFiller,Height,Width):-
    HeightFiller is Height-4,
    length(LineFiller,Width),
    maplist(=(0), LineFiller),
    length(BoardFiller,HeightFiller),
    maplist(=(LineFiller), BoardFiller).

make_board_player_initial(Player,PlayerBoard,Width) :-
    RowWidth is Width-2,
    length(InitialRow, RowWidth),
    maplist(=(Player), InitialRow),
    append([0],InitialRow,MidleRow),
    append(MidleRow,[0],EndingRow),
    append([EndingRow],[EndingRow],PlayerBoard).

/*
    print board in the console
*/
print_board(Board,Width,Turn,TotalMoves) :-
    print_board_top_coordinates(Width), nl,
    print_board_content(Board,Width,1),
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
print_board_top_coordinates(Width) :-
    print_board_top_coordinates_aux(Width, 1).

print_board_top_coordinates_aux(0,_).
print_board_top_coordinates_aux(Width, CurrentCoordinate) :-
    Width > 0,
    CoordinateAscii is CurrentCoordinate + 96,  % 'a' ASCII é 97 e coordenada começa em 1
    atom_codes(Coordinate, [CoordinateAscii]),  % convert codigo ASCII para string
    format('  ~s ', Coordinate),
    Width1 is Width - 1,
    CurrentCoordinate1 is CurrentCoordinate + 1,
    print_board_top_coordinates_aux(Width1, CurrentCoordinate1). 

/*
    print content of the board
*/
print_board_content([],Width,_) :- 
    print_limiter(Width).
print_board_content([H|T],Width,Line) :-
    print_limiter(Width),
    print_line(H,Line),
    Line1 is Line+1,
    print_board_content(T,Width,Line1).

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
    H is 0, 
    !,  
    write('|   '), 
    print_line_content(T).

print_line_content([H|T]) :-
    format('| ~w ',H),
    print_line_content(T).

/*
    create squares to separate the content of the board
*/
print_limiter(Width) :-
    print_limiter_aux(0,Width).

print_limiter_aux(Pos,Max) :-
    Pos<Max,
    write('----'),
    Pos1 is Pos+1,
    print_limiter_aux(Pos1,Max).
print_limiter_aux(Max,Max) :-
    write('-'), nl.