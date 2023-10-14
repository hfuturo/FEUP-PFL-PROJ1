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