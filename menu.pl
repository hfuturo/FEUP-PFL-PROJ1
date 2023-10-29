menu_game_mode(Option) :-
    repeat,
    write('\n---------------------------------------------'),
    write('\n|            MENU GAME MODE JUMP            |'),
    write('\n| Select the mode in which you want to play |'),
    write('\n| 1: Person vs Person                       |'),
    write('\n| 2: Person vs Easy AI                      |'),
    write('\n| 3: Person vs Difficult AI                 |'),
    write('\n| 4: Easy AI vs Easy AI                     |'),
    write('\n| 5: Difficult AI vs Difficult AI           |'),
    write('\n---------------------------------------------'), nl,
    write('Select the number of the option: '),
    read_number(Number),
    Number >= 1,
    Number =< 5,
    !,
    Option is Number.

/*
    menu para decidir entre fazer jump outra vez ou não
*/
menu_jump_cycle(Option) :-
    repeat,
    write('\n------------------------------------'),
    write('\n|       MENU CONTINUOUS JUMP       |'),
    write('\n| Do you want to continue jumping? |'),
    write('\n| 1: Yes                           |'),
    write('\n| 2: No                            |'),
    write('\n------------------------------------'), nl,
    write('Select the number of the option: '),
    read_number(Number),
    Number > 0,
    Number =< 2,
    !,
    Option is Number.

