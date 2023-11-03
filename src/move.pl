/*
    Escolhe a peça para mover
    select_piece(-X,-Y,+GameState)
*/
/* modo pessoa */
select_piece(X,Y,GameState) :-
    board_size(Height,Width,GameState),
    repeat,
    write('-----------------------------------------------------'),
    write('\n| Select the coordinates where the piece is.        |'),
    write('\n-----------------------------------------------------\n'),
    write('Column: '),
    read_column_piece(X,Width),
    write('Row: '),
    read_row_piece(Y,Height),
    get_position_player(X,Y,GameState),
    !.

/*
    Escolhe a nova posição para a peça
    select_move(-XM,-YM,+GameState)
*/
/* modo pessoa */
select_move(XM,YM,GameState) :-
    board_size(Height,Width,GameState),
    repeat,
    write('\n-----------------------------------------------------'),
    write('\n| Select the coordinates to where you want to move. |'),
    write('\n-----------------------------------------------------\n'),
    write('Column: '),
    read_column_piece(XM,Width),
    write('Row: '),
    read_row_piece(YM,Height),
    \+get_position_player(XM,YM,GameState),
    !.

/*
    Retorna todas as jogadas possiveis
    valid_moves(+GameState,+VisitedPositions,-ListOfMoves)
*/
valid_moves(GameState,VisitedPositions,ListOfMoves) :-
    board_size(Height,Width,GameState),
    findall(
        [XP,YP],
        (
            between(1, Width, XP), between(1, Height, YP), 
            get_position_player(XP,YP,GameState)
        ),
        PlayerPiece
    ),
    findall(
        [XP,YP,XM,YM], 
        (
            between(1, Width, XM), between(1, Height, YM), 
            member([XP,YP],PlayerPiece),
            \+get_position_player(XM,YM,GameState),
            check_move_possible(XP,YP,XM,YM,GameState),
            \+member([XM,YM],VisitedPositions)
        ), 
        ListOfMoves
    ).

/*
    Escolhe uma move de todas as jogadas possiveis
    choose_move(+GameState,+VisitedPositions,+Type,-Move)
*/

% modo person, sem continuous jump
choose_move(GameState,VisitedPositions,1,(XP,YP,XM,YM)) :-
    length(VisitedPositions,Size),
    Size is 0,
    valid_moves(GameState,VisitedPositions,ListOfMoves),
    repeat,
    select_piece(XP,YP,GameState),
    select_move(XM,YM,GameState),
    member([XP,YP,XM,YM],ListOfMoves),
    !.

% modo person, com continuous jump
choose_move(GameState,VisitedPositions,1,(XP,YP,XM,YM)) :-
    length(VisitedPositions,Size),
    Size > 0,

    nth1(Size,VisitedPositions,LastPiece),
    nth1(1,LastPiece,XP),
    nth1(2,LastPiece,YP),

    valid_moves(GameState,VisitedPositions,ListOfMoves),
    repeat,
    select_move(XM,YM,GameState),
    member([XP,YP,XM,YM],ListOfMoves),
    \+no_jump(XP,YP,XM,YM),
    !.

% modo Easy AI, sem continuous jump
choose_move(GameState,VisitedPositions,2,(XP,YP,XM,YM)) :-
    length(VisitedPositions,Size),
    Size is 0,

    valid_moves(GameState,VisitedPositions,ListOfMoves),
    length(ListOfMoves,MaxIndex),
    MaxIndexRandom is MaxIndex+1,
    random(1,MaxIndexRandom,Index),
    nth1(Index,ListOfMoves,Move),

    nth1(1,Move,XP),
    nth1(2,Move,YP),
    nth1(3,Move,XM),
    nth1(4,Move,YM),
    !.

% modo Easy AI, com continuous jump
choose_move(GameState,VisitedPositions,2,(XP,YP,XM,YM)) :-
    length(VisitedPositions,Size),
    Size > 0,

    nth1(Size,VisitedPositions,LastPiece),
    nth1(1,LastPiece,XP),
    nth1(2,LastPiece,YP),

    valid_moves(GameState,VisitedPositions,ListOfMoves),
    board_size(Height,Width,GameState),

    findall(
        [XM,YM],
        (
            between(1, Width, XM), 
            between(1, Height, YM), 
            member([XP,YP,XM,YM],ListOfMoves),
            \+no_jump(XP,YP,XM,YM)
        ),
        Result
    ),

    length(Result,MaxIndex),
    MaxIndexRandom is MaxIndex+1,
    random(1,MaxIndexRandom,Index),
    nth1(Index,Result,Move),

    nth1(1,Move,XM),
    nth1(2,Move,YM),
    !.

% modo Difficult AI, sem continuous jump
choose_move(GameState,VisitedPositions,3,(XP,YP,XM,YM)) :-
    length(VisitedPositions,Size),
    Size is 0,

    valid_moves(GameState,VisitedPositions,ListOfMoves),
    board_size(Height,Width,GameState),
    findall(
        [Value,XPT,YPT,XMT,YMT],
        (
            between(1, Width, XPT), between(1, Height, YPT), 
            between(1, Width, XMT), between(1, Height, YMT), 
            member([XPT,YPT,XMT,YMT],ListOfMoves),
            get_piece_isolation(XPT,YPT,Value,GameState,0),
            best_piece_move(GameState,XPT,YPT,XMT,YMT)
        ),
        Result
    ),

    sort(Result, SortedResult),
    length(SortedResult,MaxIndex),

    nth1(MaxIndex,SortedResult,Elem),
    nth1(1,Elem,MaxValue),

    findall(
        [BoardValue,Value,XPT,YPT,XMT,YMT],
        (
            member([Value,XPT,YPT,XMT,YMT],Result),
            Value is MaxValue,
            value(GameState,BoardValue)
        ),
        BestMoves
    ),
    sort(BestMoves,ValueBestMoves),
    length(ValueBestMoves,NumberMoves),

    nth1(NumberMoves,ValueBestMoves,ValueElem),
    nth1(1,ValueElem,BestPlayValue),

    findall(
        [BoardValue,Value,XPT,YPT,XMT,YMT],
        (
            member([BoardValue,Value,XPT,YPT,XMT,YMT],BestMoves),
            BoardValue is BestPlayValue
        ),
        FinalMoves
    ),

    length(FinalMoves,Index),
    UpdatedIndex is Index+1,
    random(1,UpdatedIndex,Final),

    nth1(Final,FinalMoves,SelectedMove),
    nth1(3,SelectedMove,XP),
    nth1(4,SelectedMove,YP),
    nth1(5,SelectedMove,XM),
    nth1(6,SelectedMove,YM).

% modo Difficult AI, com continuous jump
choose_move(GameState,VisitedPositions,3,(XP,YP,XM,YM)) :-
    length(VisitedPositions,Size),
    Size > 0,

    nth1(Size,VisitedPositions,LastPiece),
    nth1(1,LastPiece,XP),
    nth1(2,LastPiece,YP),
    get_piece_isolation(XP,YP,Atual,GameState,0),

    valid_moves(GameState,VisitedPositions,ListOfMoves),
    board_size(Height,Width,GameState),
    findall(
        [Value,XMT,YMT],
        (
            between(1, Width, XMT), between(1, Height, YMT), 
            member([XP,YP,XMT,YMT],ListOfMoves),
            get_piece_isolation(XMT,YMT,Value,GameState,0)
        ),
        Result
    ),
    sort(Result,SortedResult),
    nth1(1,SortedResult,Elem),
    nth1(1,Elem,Min),
    Atual>Min,
    !,
    nth1(2,Elem,XM),
    nth1(3,Elem,YM).

/*
    Verifica se é possivel fazer um continuous jump, e sim chama os predicados necessários
    check_continuous_jump_cycle(+Move,+GameState,-NewGameState,+VisitedPositions,+Type)
*/
check_continuous_jump_cycle((XP,YP,XM,YM),(Board,Turn,TotalMoves),NewGameState,VisitedPositions,Type) :-
    \+no_jump(XP,YP,XM,YM),
    change_player(Turn,NewTurn),
    (
        \+check_winner(Board,1,Turn),
        \+check_winner(Board,1,NewTurn)
    ),
    append(VisitedPositions,[[XM,YM]],NewVisitedPositions),
    valid_moves((Board,Turn,TotalMoves),VisitedPositions,ListOfMoves),
    board_size(Height,Width,(Board,Turn,TotalMoves)),
    findall(
        [NXM,NYM],
        (
            between(1, Width, NXM), 
            between(1, Height, NYM), 
            member([XM,YM,NXM,NYM],ListOfMoves),
            \+no_jump(XM,YM,NXM,NYM)
        ),
        Result
    ),
    length(Result,Size),
    Size>0,
    !,
    do_continuous_jump_cycle((Board,Turn,TotalMoves),NewGameState,NewVisitedPositions,Type).

check_continuous_jump_cycle(_,GameState,GameState,_,_).

/*
    Faz um continuous jump se for a vontade do jogador
    do_continuous_jump_cycle(+GameState,-NewGameState,+VisitedPositions,+Type)
*/
/* modo pessoa */
do_continuous_jump_cycle(GameState,NewGameState,VisitedPositions,1) :-
    display_game(GameState),
    menu_jump_cycle(Option,1),
    Option is 1,
    !,
    nl,
    choose_move(GameState,VisitedPositions,1,Move),
    move(GameState,Move,TempGameState),
    check_continuous_jump_cycle(Move,TempGameState,NewGameState,VisitedPositions,1).

/* modo easy ai */
do_continuous_jump_cycle(GameState,NewGameState,VisitedPositions,2) :-
    menu_jump_cycle(Option,2),
    Option is 1,
    !,
    display_game(GameState),
    nl,
    choose_move(GameState,VisitedPositions,2,Move),
    move(GameState,Move,TempGameState),
    check_continuous_jump_cycle(Move,TempGameState,NewGameState,VisitedPositions,2).

/* modo difficult ai */
do_continuous_jump_cycle(GameState,NewGameState,VisitedPositions,3) :-
    choose_move(GameState,VisitedPositions,3,Move),
    !,
    display_game(GameState),
    move(GameState,Move,TempGameState),
    check_continuous_jump_cycle(Move,TempGameState,NewGameState,VisitedPositions,3).

do_continuous_jump_cycle(GameState,GameState,_,_).

/*
    Avalia o estado do jogo
    value(+GameState, +Player, -Value)
*/

value((Board,Turn,_),Value) :-
    change_player(Turn,NewTurn),
    check_winner(Board,1,NewTurn),
    !,
    Value is 0.

value((Board,Turn,_),Value) :-
    check_winner(Board,1,Turn),
    !,
    Value is 10.

value(_,Value) :- Value is 5.