:- use_module(library(lists)).

play :-
    write('write the size of the board: '),
    %read(BoardSize),
    read_number(BoardSize),
    %char_type(BoardSize, digit), % verifica se input é um digito
    make_board(BoardSize, Board),
    print_board(Board, BoardSize)
.

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

make_board(BoardSize, Board) :-
    length(Board, BoardSize),
    length(Row, BoardSize),
    maplist(=(0), Row),
    maplist(=(Row), Board)
.

print_board(Board, BoardSize) :-
    print_board_aux(Board, BoardSize).


print_board_aux([], BoardSize) :- 
    print_limiter(_,BoardSize),
    write('\n').
print_board_aux([H|T], BoardSize) :-
    print_limiter(_, BoardSize),
    print_line(H),
    print_board_aux(T, BoardSize).


print_line([]) :- 
    write('|\n').
print_line([H|T]) :-
  format('| ~w ',H),
  print_line(T).


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