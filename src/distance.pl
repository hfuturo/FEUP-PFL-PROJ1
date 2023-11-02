/*
    Calcula o tamanho das linhas em cada direção onde a peça está
    calculate_distances(+X,+Y,+Turn,+Height,+Width,+Board,-Distances)
*/
calculate_distances(X,Y,GameState,Distances) :-
    row_distance(X,Y,GameState,RowDistance),
    column_distance(X,Y,GameState,ColumnDistance),
    diagonal_distance_NESW(X,Y,GameState,NESWDiagonalDistance), % ↙↗
    diagonal_distance_NWSE(X,Y,GameState,NWSEDiagonalDistance), % ↖↘
    append([ColumnDistance],[RowDistance],DistancesAux),
    append([NESWDiagonalDistance],[NWSEDiagonalDistance],DistancesAux2),
    append(DistancesAux,DistancesAux2,Distances).

/*
    Calcula o tamanho da linha NWSE de onde a peça está
    diagonal_distance_NWSE(+X,+Y,+Board,+Width,+Height,+Turn,-DiagonalDistance)
*/
diagonal_distance_NWSE(X,Y,(Board,Turn,_),DiagonalDistance) :-
    board_size(Height,Width,(Board,_,_)),
    nth1(Y,Board,Row),
    nth1(X,Row,XValue),
    Times is 0,
    diagonal_distance_NW(X,Y,XValue,Board,Turn,Times,NWDiagonalDistance),  % ↖
    diagonal_distance_SE(X,Y,XValue,Board,Width,Height,Turn,Times,SEDiagonalDistance), % ↘
    DiagonalDistance is NWDiagonalDistance + SEDiagonalDistance - 1.

/*
    Calcula o tamanho da linha NW de onde a peça está
    diagonal_distance_NW(+X,+Y,+XValue,+Board,+Turn,+Times,-Distance)
*/
diagonal_distance_NW(1,_,_,_,_,0,1) :- !.    % peça encontra-se encostada a board no lado esquerdo
diagonal_distance_NW(_,1,_,_,_,0,1) :- !.    % peça encontra-se encostada a board em cima
diagonal_distance_NW(1,_,1,_,1,_,1) :- !.    % jogador 1 encontra 1 no fim da board do lado esquerdo
diagonal_distance_NW(_,1,1,_,1,_,1) :- !.    % jogador 1 encontra 1 no fim da board em cima
diagonal_distance_NW(1,_,2,_,2,_,1) :- !.    % jogador 2 encontra 2 no fim da board em cima
diagonal_distance_NW(_,1,2,_,2,_,1) :- !.    % jogador 2 encontra 2 no fim da board em cima
diagonal_distance_NW(1,_,_,_,_,_,0).         % jogador 1/2 encontra 0,2/0,1 no fim da board no lado esquerdo
diagonal_distance_NW(_,1,_,_,_,_,0).         % jogador 1/2 encontra 0,2/0,1 no fim da board em cima
diagonal_distance_NW(_,_,0,_,1,_,0).         % jogador 1 encontra 0
diagonal_distance_NW(_,_,2,_,1,_,0).         % jogador 1 encontra 2
diagonal_distance_NW(_,_,0,_,2,_,0).         % jogador 2 encontra 0
diagonal_distance_NW(_,_,1,_,2,_,0).         % jogador 2 encontra 1
diagonal_distance_NW(X,Y,XValue,Board,Turn,Times,Distance) :-
    X >= 1,
    Y >= 1,
    XValue is Turn,
    UpdatedX is X - 1,
    UpdatedY is Y - 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedY,Board,Row),
    nth1(UpdatedX,Row,UpdatedXVal),
    diagonal_distance_NW(UpdatedX,UpdatedY,UpdatedXVal,Board,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    Calcula o tamanho da linha SE de onde a peça está
    diagonal_distance_SE(+X,+Y,+XValue,+Board,+Turn,+Times,-Distance)
*/
diagonal_distance_SE(Width,_,_,_,Width,_,_,0,1)   :- !.  % peça encontra-se encostada a board no lado direito
diagonal_distance_SE(_,Height,_,_,_,Height,_,0,1) :- !.  % peça encontra-se encostada a board em baixo
diagonal_distance_SE(Width,_,1,_,Width,_,1,_,1)   :- !.  % jogador 1 encontra 1 no fim da board do lado direito
diagonal_distance_SE(_,Height,1,_,_,Height,1,_,1) :- !.  % jogador 1 encontra 1 no fim da board em baixo
diagonal_distance_SE(Width,_,2,_,Width,_,2,_,1)   :- !.  % jogador 2 encontra 2 no fim da board do lado direito
diagonal_distance_SE(_,Height,2,_,_,Height,2,_,1) :- !.  % jogador 2 encontra 2 no fim da board em baixo
diagonal_distance_SE(Width,_,_,_,Width,_,_,_,0).         % jogador 1/2 encontra 0,2/0,1 no fim da board do lado direito
diagonal_distance_SE(_,Height,1,_,_,Height,1,_,0).       % jogador 1/2 encontra 0,2/0,1 no fim da board em baixo
diagonal_distance_SE(_,_,0,_,_,_,1,_,0) :- !.            % jogador 1 encontra 0
diagonal_distance_SE(_,_,2,_,_,_,1,_,0) :- !.            % jogador 1 encontra 2
diagonal_distance_SE(_,_,0,_,_,_,2,_,0) :- !.            % jogador 2 encontra 0
diagonal_distance_SE(_,_,1,_,_,_,2,_,0) :- !.            % jogador 2 encontra 1
diagonal_distance_SE(X,Y,XValue,Board,Width,Height,Turn,Times,Distance) :-
    X =< Width,
    Y =< Height,
    XValue is Turn,
    UpdatedX is X + 1,
    UpdatedY is Y + 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedY,Board,Row),
    nth1(UpdatedX,Row,UpdatedXVal),
    diagonal_distance_SE(UpdatedX,UpdatedY,UpdatedXVal,Board,Width,Height,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    Calcula o tamanho da linha NESW de onde a peça está
    diagonal_distance_NESW(+X,+Y,+Board,+Width,+Height,+Turn,-DiagonalDistance) :-
*/
diagonal_distance_NESW(X,Y,(Board,Turn,_),DiagonalDistance) :-
    board_size(Height,Width,(Board,_,_)),
    nth1(Y,Board,Row),
    nth1(X,Row,XValue),
    Times is 0,
    diagonal_distance_NE(X,Y,XValue,Board,Width,Turn,Times,NEDiagonalDistance),  % ↗
    diagonal_distance_SW(X,Y,XValue,Board,Height,Turn,Times,SWDiagonalDistance), % ↙
    DiagonalDistance is NEDiagonalDistance + SWDiagonalDistance - 1.

/*
    Calcula o tamanho da linha NE de onde a peça está
    diagonal_distance_NE(+X,+Y,+XValue,+Board,+Width,+Turn,+Times,-Distance)
*/
diagonal_distance_NE(Width,_,_,_,Width,_,0,1) :- !. % peça encontra-se encostada a board na parte do lado direito
diagonal_distance_NE(_,1,_,_,_,_,0,1)         :- !. % peça encontra-se encostada a board em cima
diagonal_distance_NE(Width,_,1,_,Width,1,_,1) :- !. % jogador 1 encontra 1 no fim da board do lado direito
diagonal_distance_NE(_,1,1,_,_,1,_,1)         :- !. % jogador 1 encontra 1 no fim da board em cima
diagonal_distance_NE(Width,_,2,_,Width,2,_,1) :- !. % jogador 2 encontra 2 no fim da board do lado direito
diagonal_distance_NE(_,1,2,_,_,2,_,1)         :- !. % jogador 2 encontra 2 no fim da board em cima
diagonal_distance_NE(Width,_,_,_,Width,_,_,0).      % jogador 1/2 encontra 0,2/0,1 no fim da board do lado direito
diagonal_distance_NE(_,1,_,_,_,_,_,0).              % jogador 1/2 encontra 0,2/0,1 no fim da board em cima
diagonal_distance_NE(_,_,0,_,_,1,_,0).              % jogador 1 encontra 0
diagonal_distance_NE(_,_,2,_,_,1,_,0).              % jogador 1 encontra 2
diagonal_distance_NE(_,_,0,_,_,2,_,0).              % jogador 2 encontra 0
diagonal_distance_NE(_,_,1,_,_,2,_,0).              % jogador 2 encontra 1
diagonal_distance_NE(X,Y,XValue,Board,Width,Turn,Times,Distance) :-
    X =< Width,
    Y >= 1,
    XValue is Turn,
    UpdatedX is X + 1,
    UpdatedY is Y - 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedY,Board,Row),
    nth1(UpdatedX,Row,UpdatedXVal),
    diagonal_distance_NE(UpdatedX,UpdatedY,UpdatedXVal,Board,Width,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    Calcula o tamanho da linha SW de onde a peça está
    diagonal_distance_SW(+X,+Y,+XValue,+Board,+Width,+Turn,+Times,-Distance)
*/
diagonal_distance_SW(1,_,_,_,_,_,0,1)           :- !.   % peça encontra-se encostada a board na parte do lado esquerdo
diagonal_distance_SW(_,Height,_,_,Height,_,0,1) :- !.   % peça encontra-se encostada a board em baixo
diagonal_distance_SW(1,_,1,_,_,1,_,1)           :- !.   % jogador 1 encontra 1 no fim da board do lado esquerdo
diagonal_distance_SW(_,Height,1,_,Height,1,_,1) :- !.   % jogador 1 encontra 1 no fim da board em baixo
diagonal_distance_SW(1,_,2,_,_,2,_,1)           :- !.   % jogador 2 encontra 2 no fim da board do lado esquerdo
diagonal_distance_SW(_,Height,2,_,Height,2,_,1) :- !.   % jogador 2 encontra 2 no fim da board em baixo
diagonal_distance_SW(1,_,_,_,_,_,_,0).                  % jogador 1/2 encontra 0,2/0,1 no fim da board do lado esquerdo
diagonal_distance_SW(_,Height,_,_,Height,_,_,0).        % jogador 1/2 encontra 0,2/0,1 no fim da board em baixo
diagonal_distance_SW(_,_,0,_,_,1,_,0).                  % jogador 1 encontra 0
diagonal_distance_SW(_,_,2,_,_,1,_,0).                  % jogador 1 encontra 2
diagonal_distance_SW(_,_,0,_,_,2,_,0).                  % jogador 2 encontra 0
diagonal_distance_SW(_,_,1,_,_,2,_,0).                  % jogador 2 encontra 1
diagonal_distance_SW(X,Y,XValue,Board,Height,Turn,Times,Distance) :-
    X >= 1,
    Y =< Height,
    XValue is Turn,
    UpdatedX is X - 1,
    UpdatedY is Y + 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedY,Board,Row),
    nth1(UpdatedX,Row,UpdatedXVal),
    diagonal_distance_SW(UpdatedX,UpdatedY,UpdatedXVal,Board,Height,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    Calcula o tamanho da linha vertical de onde a peça está
    column_distance(+X,+Y,+Board,+Height,+Turn,-Distance)
*/
column_distance(X,Y,(Board,Turn,_),Distance) :-
    board_size(Height,Width,(Board,_,_)),
    nth1(Y,Board,Row),
    nth1(X,Row,XValue),
    Times is 0,
    column_distance_up(X,Y,XValue,Board,Turn,Times,ColumnUp),
    column_distance_down(X,Y,XValue,Height,Board,Turn,Times,ColumnDown),
    Distance is ColumnUp + ColumnDown - 1.

/*
    Calcula o tamanho da linha para cima de onde a peça está
    column_distance_up(+X,+Y,+XValue,+Board,+Turn,+Times,-Distance)
*/
column_distance_up(_,1,_,_,_,0,1) :- !.  % peça encontra-se encostada a board
column_distance_up(_,1,1,_,1,_,1) :- !.  % jogador 1 encontra 1 no fim da board
column_distance_up(_,1,2,_,2,_,1) :- !.  % jogador 2 encontra 2 no fim da board
column_distance_up(_,1,_,_,_,_,0).       % jogador 1/2 encontra 0,2/0,1 no fim da board
column_distance_up(_,_,0,_,1,_,0).       % jogador 1 encontra 0
column_distance_up(_,_,2,_,1,_,0).       % jogador 1 encontra 2
column_distance_up(_,_,0,_,2,_,0).       % jogador 2 encontra 0
column_distance_up(_,_,1,_,2,_,0).       % jogador 2 encontra 1
column_distance_up(X,Y,XValue,Board,Turn,Times,Distance) :-
    Y >= 1,
    XValue is Turn,
    UpdatedY is Y - 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedY,Board,Row),
    nth1(X,Row,UpdatedXVal),
    column_distance_up(X,UpdatedY,UpdatedXVal,Board,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    Calcula o tamanho da linha para baixo de onde a peça está
    column_distance_down(+X,+Y,+XValue,+Board,+Turn,+Times,-Distance)
*/
column_distance_down(_,Height,_,Height,_,_,0,1) :- !.   % peça encontra-se encostada a board.
column_distance_down(_,Height,1,Height,_,1,_,1) :- !.   % jogador 1 encontra 1 no fim da board.
column_distance_down(_,Height,2,Height,_,2,_,1) :- !.   % jogador 2 encontra 2 no fim da board.
column_distance_down(_,Height,_,Height,_,_,_,0).        % jogador 1/2 encontra 0,2/0,1 no fim da board
column_distance_down(_,_,0,_,_,1,_,0).                  % jogador 1 encontra 0
column_distance_down(_,_,2,_,_,1,_,0).                  % jogador 1 encontra 2
column_distance_down(_,_,0,_,_,2,_,0).                  % jogador 2 encontra 0
column_distance_down(_,_,1,_,_,2,_,0).                  % jogador 2 encontra 1
column_distance_down(X,Y,XValue,Height,Board,Turn,Times,Distance) :-
    Y =< Height,
    XValue is Turn,
    UpdatedY is Y + 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedY,Board,Row),
    nth1(X,Row,UpdatedXVal),
    column_distance_down(X,UpdatedY,UpdatedXVal,Height,Board,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    Calcula o tamanho da linha horizontal de onde a peça está
    row_distance(+X,+Y,+Board,+Width,+Turn,-Distance)
*/
row_distance(X,Y,(Board,Turn,_),Distance) :-
    board_size(Height,Width,(Board,_,_)),
    nth1(Y,Board,Row),
    nth1(X,Row,XValue),
    Times is 0,
    row_distance_right(X,Row,XValue,Width,Turn,Times,DistanceRight),
    row_distance_left(X,Row,XValue,Turn,Times,DistanceLeft),
    Distance is DistanceRight + DistanceLeft - 1.

/*
    Calcula o tamanho da linha para a direita de onde a peça está
    row_distance_right(+X,+Row,+XValue,+Width,+Turn,+Times,-Distance)
*/
row_distance_right(Width,_,_,Width,_,0,1) :- !.   % peça encontra-se encostada a board
row_distance_right(Width,_,1,Width,1,_,1) :- !.   % jogador 1 encontra 1 no fim da board
row_distance_right(Width,_,2,Width,2,_,1) :- !.   % jogador 2 encontra 2 no fim da board
row_distance_right(Width,_,_,Width,_,_,0).        % jogador 1/2 encontra 0,2/0,1 no fim da board
row_distance_right(_,_,0,_,1,_,0).                % jogador 1 encontra 0
row_distance_right(_,_,0,_,2,_,0).                % jogador 2 encontra 0
row_distance_right(_,_,1,_,2,_,0).                % jogador 2 encontra 1
row_distance_right(_,_,2,_,1,_,0).                % jogador 1 encontra 2
row_distance_right(X,Row,XValue,Width,Turn,Times,Distance) :-
    X =< Width,
    XValue is Turn,
    UpdatedX is X + 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedX,Row,UpdatedXVal),
    row_distance_right(UpdatedX,Row,UpdatedXVal,Width,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.

/*
    Calcula o tamanho da linha para a esquerda de onde a peça está
    row_distance_left(+X,+Row,+XValue,+Width,+Turn,+Times,-Distance)
*/
row_distance_left(1,_,_,_,0,1) :- !.     % peça encontra-se encostada a board
row_distance_left(1,_,1,1,_,1) :- !.     % jogador 1 encontra 1 no fim da board
row_distance_left(1,_,2,2,_,1) :- !.     % jogador 2 encontra 2 no fim da board
row_distance_left(1,_,_,_,_,0).          % jogador 1/2 encontra 0,2/0,1 no fim da board
row_distance_left(_,_,0,1,_,0).          % jogador 1 encontra 0
row_distance_left(_,_,0,2,_,0).          % jogador 2 encontra 0
row_distance_left(_,_,1,2,_,0).          % jogador 2 encontra 1
row_distance_left(_,_,2,1,_,0).          % jogador 1 encontra 2
row_distance_left(X,Row,XValue,Turn,Times,Distance) :-
    X >= 1,
    XValue is Turn,
    UpdatedX is X - 1,
    UpdatedTimes is Times + 1,
    nth1(UpdatedX,Row,UpdatedXVal),
    row_distance_left(UpdatedX,Row,UpdatedXVal,Turn,UpdatedTimes,UpdatedDistance),
    Distance is UpdatedDistance + 1.
