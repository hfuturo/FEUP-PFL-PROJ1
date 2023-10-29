:- consult(utils).
:- consult(board).
:- consult(piece).
:- consult(continuous_jump).
:- consult(check_win).

change_player(1,2).
change_player(2,1).

/*
    criar um tabuleiro com um tamanho especifico
*/
initial_state(Height,Width,Board) :-
    read_size_board(Height,Width),
    make_initial_board(Height,Width,Board), nl.
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

congratulate(Winner) :-
    format('Player ~w won!',Winner).
