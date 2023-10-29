menu_game_mode(Option) :-
    repeat,
    write('\n--------------------------------------------|'),
    write('\n|            MENU GAME MODE JUMP            |'),
    write('\n| Select the mode in which you want to play |'),
    write('\n| 1: Person vs Person                       |'),
    write('\n| 2: Person vs Easy AI                      |'),
    write('\n| 3: Person vs Difficult AI                 |'),
    write('\n| 4: Easy AI vs Easy AI                     |'),
    write('\n| 5: Difficult AI vs Difficult AI           |'),
    write('\n--------------------------------------------|'), nl,
    write('Select the number of the option: '),
    read_number(Number),
    Number >= 1,
    Number =< 5,
    !,
    Option is Number.

