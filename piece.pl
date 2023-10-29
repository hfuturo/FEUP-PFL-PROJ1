/*
    Atualzizar o tabuleiro de acordo com a movimentação
*/
move(Turn,XP,YP,XM,YM,Board,NewBoard) :-
    change_piece(0,Board,XP,YP,TempBoard),
    change_piece(Turn,TempBoard,XM,YM,NewBoard).

/*
    Alterar peça numa determinada posição do tabuleiro
*/
change_piece(Value,Board,X,Y,NewBoard) :-
    nth1(Y,Board,Row),
    nth1(X,Row,_,TempRow),
    nth1(X,NewRow,Value,TempRow),
    nth1(Y,Board,_,TempBoard),
    nth1(Y,NewBoard,NewRow,TempBoard).

/*
    Ver qual a peça que está numa determinada posição do tabuleiro
*/
get_position_piece(X,Y,Board,Piece) :-
    nth1(Y,Board,Row),
    nth1(X,Row,Piece).

/*
    verifica se está numa posição de continuous jump
*/
jump_possible(Distances,XP,YP,XM,YM,Width,Height,Board,Turn,VisitedPositions) :-
    \+no_line(Distances),
    \+no_jump(XP,YP,XM,YM),
    can_jump(Distances,XP,YP,XM,YM,Width,Height,Board,Turn,VisitedPositions).

can_jump(Distances,XP,YP,XM,YM,Width,Height,Board,Turn,VisitedPositions) :-
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
                nth1(UpdatedY,Board,Row),
                nth1(XM,Row,XVal),
                \+member([XM,UpdatedY],VisitedPositions),
                Turn =\= XVal,
                UpdatedY =\= YP
            );

            % down
            (
                Vertical > 1,
                Height >= YM + Vertical,
                UpdatedY is YM + Vertical,
                nth1(UpdatedY,Board,Row),
                nth1(XM,Row,XVal),
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
                nth1(YM,Board,Row),
                nth1(UpdatedX,Row,XVal),
                \+member([UpdatedX,YM],VisitedPositions),
                Turn =\= XVal,
                UpdatedX =\= XP
            );

            % left      
            (
                Horizontal > 1,
                1 =< XM - Horizontal,
                UpdatedX is XM - Horizontal,
                nth1(YM,Board,Row),
                nth1(UpdatedX,Row,XVal),
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
                nth1(UpdatedY,Board,Row),
                nth1(UpdatedX,Row,XVal),
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
                nth1(UpdatedY,Board,Row),
                nth1(UpdatedX,Row,XVal),
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
                nth1(UpdatedY,Board,Row),
                nth1(UpdatedX,Row,XVal),
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
                nth1(UpdatedY,Board,Row),
                nth1(UpdatedX,Row,XVal),
                \+member([UpdatedX,UpdatedY],VisitedPositions),
                Turn =\= XVal,
                (   % necessário verificar se novo jump não é a coord anterior
                    UpdatedY =\= YP ; UpdatedX =\= XP
                )
            )
        )                
    ).

/*
    verifica que não há linhas para fazer jump
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
    verifica que ultima movimentação foi do tipo adjacente
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
