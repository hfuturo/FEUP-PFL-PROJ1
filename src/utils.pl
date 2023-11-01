:- use_module(library(system), [now/1]).

/*
    Lê um número de input
    read_number(-Number)
*/
read_number(Number) :-
    read_number_aux(0,false,Number).

read_number_aux(Acc,_,Number) :-
    get_code(Input),
    Input >= 48,    % '0'
    Input =< 57,    % '9'
    !,
    Acc1 is 10*Acc + (Input-48),
    read_number_aux(Acc1, true, Number)
.
read_number_aux(Number,true,Number).

/*
    Lê um caracter de input
    read_char(-Letter)
*/
read_char(Letter) :-
    repeat,
    get_code(Input),
    get_code(_), % break line
    Letter is Input-96,
    Letter>= 1,
    Letter=< 15,
    !.

/*
    Lê dois números de input
    read_size_board(-Height,-Width)
*/
read_size_board(Height,Width) :-
    write('Write the Height of the board.\n'),
    read_size_board_side(Height), nl,
    write('Write the width of the board.\n'),
    read_size_board_side(Width).

/*
    Lê o número de input que define o tamanho de um dos lados do tabuleiro
    read_size_board_side(-Side) :-
*/
read_size_board_side(Side) :-
    repeat,
    write('It has to be between 5 and 15: '),
    read_number(Side),
    Side>=5,
    Side=<15,
    !.
   
    
init_random_state :-
    now(X),
    setrand(X).
