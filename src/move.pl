/*
    Escolhe a peça para mover
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
    !.

/*
    Escolhe a nova posição para a peça
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
    !.

valid_moves(GameState,_,ListOfMoves) :-
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
            check_move_possible(XP,YP,XM,YM,GameState)
        ), 
        ListOfMoves
    ).

choose_move( GameState, VisitedPositions, 1, (XP,YP,XM,YM)) :-
    length(VisitedPositions,Size),
    Size is 0,
    valid_moves(GameState,_,ListOfMoves),
    repeat,
    select_piece(XP,YP,GameState),
    select_move(XM,YM,GameState),
    member([XP,YP,XM,YM],ListOfMoves),
    !.

choose_move( GameState, VisitedPositions, 1, (XP,YP,XM,YM)) :-
    length(VisitedPositions,Size),
    Size > 0,

    nth1(Size,VisitedPositions,LastPiece),
    nth1(1,LastPiece,XP),
    nth1(2,LastPiece,YP),

    valid_moves(GameState,_,ListOfMoves),
    repeat,
    select_move(XM,YM,GameState),
    member([XP,YP,XM,YM],ListOfMoves),
    \+member([XM,YM],VisitedPositions),
    \+no_jump(XP,YP,XM,YM),
    !.

choose_move( GameState, VisitedPositions, 2, (XP,YP,XM,YM)) :-
    valid_moves(GameState,_,ListOfMoves),
    length(ListOfMoves,MaxIndex),
    MaxIndexRandom is MaxIndex+1,
    random(1,MaxIndexRandom,Index),
    nth1(Index,ListOfMoves,Move),

    nth1(1,Move,XP),
    nth1(2,Move,YP),
    nth1(3,Move,XM),
    nth1(4,Move,YM),
    !.

choose_move( GameState, VisitedPositions, 3, (XP,YP,XM,YM)) :-
    board_size(Height,Width,GameState),
    findall(
        [Value,X,Y], 
        (
            between(1, Width, X), 
            between(1, Height, Y), 
            get_position_player(X,Y,GameState),
            check_isolation_move(X,Y,Value,GameState,0)
        ), 
        Pieces
    ),
    sort(Pieces, SortedPieces),
    length(SortedPieces,MaxIndex),
    nth1(MaxIndex,SortedPieces,Elem),
    nth1(1,Elem,MaxValue),
    findall(
        [Value,X,Y],
        (
            member([Value,X,Y],Pieces),
            Value is MaxValue
        ),
        PossibleMoves
    ),
    sort(PossibleMoves,PossibleMovesNoRepeated),
    append(PossibleMovesNoRepeated,[],ListOfMoves),
    length(ListOfMoves,PossibleMovesLength),
    UpdatedPossibleMovesLength is PossibleMovesLength + 1,
    random(1,UpdatedPossibleMovesLength,RandomMove),

    nth1(RandomMove,ListOfMoves,SelectedMove),
    nth1(2,SelectedMove,XP),
    nth1(3,SelectedMove,YP),
    check_isolation_piece(GameState,XP,YP,XM,YM).


/*
    Verifica se é possivel fazer um continuous jump, e sim chama os predicados necessários
    check_continuous_jump_cycle(+XP,+YP,+XM,+YM,+Turn,+Height,+Width,+TotalMoves,-NewTotalMoves,+Board,-NewBoard,+VisitedPositions,+Type)
*/
check_continuous_jump_cycle((XP,YP,XM,YM),(Board,Turn,TotalMoves),NewGameState,VisitedPositions,Type) :-
    change_player(Turn,NewTurn),
    (
        \+check_winner(Board,1,Turn),
        \+check_winner(Board,1,NewTurn)
    ),
    append(VisitedPositions,[[XM,YM]],NewVisitedPositions),
    valid_moves((Board,Turn,TotalMoves),_,ListOfMoves),
    board_size(Height,Width,(Board,Turn,TotalMoves)),
    findall(
        [NXM,NYM],
        (
            between(1, Width, NXM), 
            between(1, Height, NYM), 
            member([XM,YM,NXM,NYM],ListOfMoves),
            \+member([NXM,NYM],NewVisitedPositions),
            \+no_jump(XM,YM,NXM,NYM)
        ),
        Result
    ),
    length(Result,Size),
    Size>0,
    !,
    do_continuous_jump_cycle(XM,YM,(Board,Turn,TotalMoves),NewGameState,NewVisitedPositions,Type).

check_continuous_jump_cycle(_,(Board,Turn,TotalMoves),(Board,Turn,TotalMoves),_,_).

/*
    Faz um continuous jump se for a vontade do jogador
    do_continuous_jump_cycle(+XM,+YM,+Turn,+Height,+Width,+TotalMoves,-NewTotalMoves,+Board,-NewBoard,+VisitedPositions,+Type)
*/
/* modo pessoa */
do_continuous_jump_cycle(XM,YM,GameState,NewGameState,VisitedPositions,1) :-
    display_game(GameState),
    menu_jump_cycle(Option,1),
    Option is 1,
    !,
    nl,

    choose_move( GameState, VisitedPositions, 1, Move),

    move(GameState,Move,TempGameState),
    check_continuous_jump_cycle(Move,TempGameState,NewGameState,VisitedPositions,1).

/* modo easy ai */
do_continuous_jump_cycle(XM,YM,(Board,Turn,TotalMoves),NewGameState,VisitedPositions,2) :-
    menu_jump_cycle(Option,2),
    Option is 1,
    !,
    display_game((Board,Turn,TotalMoves)),
    nl,

    choose_move( (Board,Turn,TotalMoves), VisitedPositions, 2, (XM,YM,NXM,NYM)),

    move((Board,Turn,TotalMoves),(XM,YM,NXM,NYM),(TempBoard,Turn,TempTotalMoves)),
    check_continuous_jump_cycle((XM,YM,NXM,NYM),(TempBoard,Turn,TempTotalMoves),NewGameState,VisitedPositions,2).

/* modo difficult ai */
do_continuous_jump_cycle(XM,YM,(Board,Turn,TotalMoves),NewGameState,VisitedPositions,3) :-
    check_isolation_move(XM,YM,Isolation,(Board,Turn,TotalMoves),0),
    check_isolation_jump((Board,Turn,TotalMoves),XM,YM,NXM,NYM,Min,VisitedPositions),
    (
        NXM =\= 0,
        NYM =\=0,
        Isolation>Min
    ),
    !,
    display_game((Board,Turn,TotalMoves)),
    move((Board,Turn,TotalMoves),(XM,YM,NXM,NYM),(TempBoard,Turn,TempTotalMoves)),
    check_continuous_jump_cycle((XM,YM,NXM,NYM),(TempBoard,Turn,TempTotalMoves),NewGameState,VisitedPositions,3).

do_continuous_jump_cycle(_,_,(Board,Turn,TotalMoves),(Board,Turn,TotalMoves),_,_).