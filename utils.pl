/*
    read input number
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
    read char input and convert to number
*/
read_char(Number) :-
    repeat,
    get_code(Input),
    get_code(_), % break line
    Number is Input-96,
    Number>= 1,
    Number=< 15,
    !.

/*
    read size board and check if it is valid
*/
read_size_board(Height,Width) :-
    write('Write the Height of the board (between 5 and 15)\n'),
    read_size_board_side(Height),
    write('\n'),
    write('Write the width of the board (between 5 and 15)\n'),
    read_size_board_side(Width).

/*
    read side of the board and check if it is valid
*/
read_size_board_side(Side) :-
    repeat,
    write('It has to be between 5 and 15: '),
    read_number(Side),
    Side>=5,
    Side=<15,
    !.

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
print_limiter(Width) :-
    print_limiter_aux(0,Width).

print_limiter_aux(Pos,Max) :-
    Pos<Max,
    write('----'),
    Pos1 is Pos+1,
    print_limiter_aux(Pos1,Max).
print_limiter_aux(Max,Max) :-
    write('-'),
    write('\n').