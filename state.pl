:- consult(utils).
:- consult(board).
:- consult(piece).

change_player(1,2).
change_player(2,1).

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

/*
    cycle of the game
*/
game_cycle(Turn,Hight,Wide,Board):-
    write('Write the position of the piece you want to move.\n'),
    choose_move(Turn,Hight,Wide,Board,TempBoard),
    move(Turn,Hight,Wide,TempBoard,NewBoard),
    change_player(Turn,NewTurn),
    display_game(NewTurn,Wide,NewBoard),
    !,
    game_cycle(NewTurn,Hight,Wide,Board).


/*
codigo slides stor

game_cycle(Turn,Hight,Wide,Board):- 
    game_over(Hight,Wide,Board,Winner), 
    !, 
    congratulate(Winner).
*/
