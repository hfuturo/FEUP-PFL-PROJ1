/*
    Lê a coordenada Y
    read_row_piece(-Position,+Coordinate)
*/  
read_row_piece(Position,Coordinate) :-
    repeat,
    read_number(Position),
    Position>=1,
    Position=<Coordinate,
    !.

/*
    Lê a coordenada X
    read_column_piece(-Position,+Coordinate)
*/
read_column_piece(Position,Coordinate) :-
    repeat,
    read_char(Position),
    Position>=1,
    Position=<Coordinate,
    !.

/*
    Atualiza o tabuleiro de acordo com a movimentação
    move(+Turn,+XP,+YP,+XM,+YM,+Board,-NewBoard)
*/
move((Board,Turn,TotalMoves),(XP,YP,XM,YM),(NewBoard,Turn,NewTotalMoves)) :-
    change_piece(0,Board,XP,YP,TempBoard),
    change_piece(Turn,TempBoard,XM,YM,NewBoard),
    NewTotalMoves is TotalMoves+1.

/*
    Altera a peça numa determinada posição do tabuleiro
    change_piece(+Value,+Board,+X,+Y,-NewBoard)
*/
change_piece(Value,Board,X,Y,NewBoard) :-
    nth1(Y,Board,Row),
    nth1(X,Row,_,TempRow),
    nth1(X,NewRow,Value,TempRow),
    nth1(Y,Board,_,TempBoard),
    nth1(Y,NewBoard,NewRow,TempBoard).

/*
    Vê qual a peça que está numa determinada posição do tabuleiro
    get_position_piece(+X,+Y,+Board,-Piece) :-
*/
get_position_piece(X,Y,Board,Piece) :-
    nth1(Y,Board,Row),
    nth1(X,Row,Piece).

/*
    Vê se a peça é o do jogador
    get_position_player(+X,+Y,+Board,+Width,+Height,+Player)
*/
get_position_player(X,Y,BoardSize,(Board,Player,_)) :-
    check_inside_board(X,Y,BoardSize),
    get_position_piece(X,Y,Board,Piece),
    Piece is Player.

check_inside_board(X,Y,(Width,Height)) :-
    Y =< Height,
    Y >= 1,
    X =< Width,
    X >= 1.

/*
    Verifica se está numa posição onde é possivel fazer um continuous jump
    jump_possible(+Distances,+XP,+YP,+XM,+YM,+Width,+Height,+Board,+Turn,+VisitedPositions)
*/
jump_possible(Distances,XP,YP,XM,YM,BoardSize,GameState,VisitedPositions) :-
    \+no_line(Distances),
    \+no_jump(XP,YP,XM,YM),
    can_jump(Distances,XP,YP,XM,YM,BoardSize,GameState,VisitedPositions).

/*
    Verifica se existe um jump válido
    can_jump(+Distances,+XP,+YP,+XM,+YM,+Width,+Height,+Board,+Turn,+VisitedPositions)
*/
can_jump(Distances,XP,YP,XM,YM,(Width,Height),(Board,Turn,_),VisitedPositions) :-
    nth1(1,Distances,Vertical),
    nth1(2,Distances,Horizontal),
    nth1(3,Distances,DiagonalNE),
    nth1(4,Distances,DiagonalNW),   

    (
        % vertical
        (
            % up
            (
                Vertical > 1,
                1 =< YM - Vertical,
                UpdatedY is YM - Vertical,
                get_position_piece(XM,UpdatedY,Board,XVal),
                \+member([XM,UpdatedY],VisitedPositions),
                Turn =\= XVal,
                UpdatedY =\= YP
            );

            % down
            (
                Vertical > 1,
                Height >= YM + Vertical,
                UpdatedY is YM + Vertical,
                get_position_piece(XM,UpdatedY,Board,XVal),
                \+member([XM,UpdatedY],VisitedPositions),
                Turn =\= XVal,
                UpdatedY =\= YP
            )
        );

        % horizontal
        (
            % right
            (
                Horizontal > 1,
                Width >= XM + Horizontal,
                UpdatedX is XM + Horizontal,
                get_position_piece(UpdatedX,YM,Board,XVal),
                \+member([UpdatedX,YM],VisitedPositions),
                Turn =\= XVal,
                UpdatedX =\= XP
            );

            % left      
            (
                Horizontal > 1,
                1 =< XM - Horizontal,
                UpdatedX is XM - Horizontal,
                get_position_piece(UpdatedX,YM,Board,XVal),
                \+member([UpdatedX,YM],VisitedPositions),
                Turn =\= XVal,
                UpdatedX =\= XP
            )
        );

        % diagonal NE-SW
        (
            % NE
            (
                DiagonalNE > 1,
                1 =< YM - DiagonalNE,
                Width >= XM + DiagonalNE,
                UpdatedY is YM - DiagonalNE,
                UpdatedX is XM + DiagonalNE,
                get_position_piece(UpdatedX,UpdatedY,Board,XVal),
                \+member([UpdatedX,UpdatedY],VisitedPositions),
                Turn =\= XVal,
                (   % necessário verificar se novo jump não é a coord anterior
                    UpdatedY =\= YP ; UpdatedX =\= XP
                )
            );

            % SW
            (
                DiagonalNE > 1,
                Height >= YM + DiagonalNE,
                1 =< XM - DiagonalNE,
                UpdatedY is YM + DiagonalNE,
                UpdatedX is XM - DiagonalNE,
                get_position_piece(UpdatedX,UpdatedY,Board,XVal),
                \+member([UpdatedX,UpdatedY],VisitedPositions),
                Turn =\= XVal,
                (   % necessário verificar se novo jump não é a coord anterior
                    UpdatedY =\= YP ; UpdatedX =\= XP
                )
            )
        );

        % diagonal NW-SE
        (
            % NW
            (
                DiagonalNW > 1,
                1 =< YM - DiagonalNW,
                1 =< XM - DiagonalNW,
                UpdatedY is YM - DiagonalNW,
                UpdatedX is XM - DiagonalNW,
                get_position_piece(UpdatedX,UpdatedY,Board,XVal),
                \+member([UpdatedX,UpdatedY],VisitedPositions),
                Turn =\= XVal,
                (   % necessário verificar se novo jump não é a coord anterior
                    UpdatedY =\= YP ; UpdatedX =\= XP
                )
            );

            % SE
            (
                DiagonalNW > 1,
                Height >= YM + DiagonalNW,
                Width >= XM + DiagonalNW,
                UpdatedY is YM + DiagonalNW,
                UpdatedX is XM + DiagonalNW,
                get_position_piece(UpdatedX,UpdatedY,Board,XVal),
                \+member([UpdatedX,UpdatedY],VisitedPositions),
                Turn =\= XVal,
                (   % necessário verificar se novo jump não é a coord anterior
                    UpdatedY =\= YP ; UpdatedX =\= XP
                )
            )
        )                
    ).

/*
    Verifica que não há linhas para fazer jump
    no_line(+Distances)
*/
no_line(Distances) :-
    nth1(1,Distances,Elem1),
    nth1(2,Distances,Elem2),
    nth1(3,Distances,Elem3),
    nth1(4,Distances,Elem4),
    Elem1 is 1,
    Elem2 is 1,
    Elem3 is 1,
    Elem4 is 1.

/*
    Verifica que a ultima movimentação foi do tipo adjacente
    no_jump(+XP,+YP,+XM,+YM)
*/
no_jump(XP,YP,XM,YM) :-
    (
        (XP is XM+1, YP is YM);
        (XP is XM-1, YP is YM);
        (XP is XM, YP is YM+1);
        (XP is XM, YP is YM-1);

        (XP is XM+1, YP is YM+1);
        (XP is XM+1, YP is YM-1);
        (XP is XM-1, YP is YM+1);
        (XP is XM-1, YP is YM-1)
    ).
