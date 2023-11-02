# Apart

### Turma 01 - Grupo Apart_4

Henrique Gonçalves Graveto Futuro da Silva - up202105647@up.pt <br>
Contribuição: **%**

Rita Isabel Guedes Correia Leite - up202105309@up.pt <br>
Contribuição: **%**

# Instalação e Execução

Para instalar este jogo, o utilizador necessita de instalar a pasta zip chamada `PFL_TP1_T01_Apart_4.zip`, descomprimir os ficheiros e entrar na pasta `src`. Aqui dentro, é necessário consultar o ficheiro `main.pl`. Para fazer isto, o utilizador pode utlizar a UI fornecida pelo SICSTUS ou escrever o seguinte da linha de comandos:

```sh
$ sicstus
?-  consult('main.pl').
```

_Nota_: É necessário ter instalado o SICStus Prolog 4.8 ou uma versão mais recente.

Para executar o jogo basta chamar o predicado `play/0` da seguinte forma

```sh
?-  play.
```

# Descrição do jogo

Apart é um jogo de tabuleiro para dois jogadores. É jogado num tabuleiro quadrado de 8x8 e cada jogador tem ao seu dispor 12 peças. Para distinguir as peças de ambos os jogadores, estas encontram-se com cores diferentes.

No início do jogo, as peças têm uma posição pré-determinada, formando um grupo de 6x2. O objetivo deste jogo é distribuir as peças pelo tabuleiro. Para isso, o jogador pode mover as peças pelo tabuleiro.

Definições:

- Uma linha (vertical, horizontal ou diagonal) de peças da mesma cor é chamada **line**.
- Uma linha com uma peça é considerada uma **line** de tamanho 1.
- Mover uma peça para um lugar adjacente é designado por **single step**, e mover para um lugar afastado por dois ou mais quadrados é designado por **jump**.
- Realizar um **jump** mais do que uma vez numa jogada é designado por **continuous jump**.

Regras:

- O jogo começa com o jogador que tiver as peças brancas.
- Uma peça só pode ser movida por jogada.
- A primeira jogada do jogo não pode conter um **continuous jump**.
- Uma peça pode ser movida ao longo de uma linha a que pertença, desde que a distância percorrida pela peça seja igual ao tamanho dessa linha.
- A peça pode saltar por peças que se encontram a meio do caminho e, se tiver uma peça inimiga onde 'aterrar', a peça inimiga é capturada e removida do jogo.
- Peças não podem ser movidas para um lugar onde já esteja uma peça da mesma cor.
- Se a peça conseguir realizar um **jump** no lugar onde aterrou, pode continuar a mover-se na mesma jogada, embora não seja obrigatório (**continuous jump**).
- Não há um limite de **jumps** que uma peça possa realizar num **continuous jump**.
- Um quadrado só pode ser utilizado uma vez por jogada.
- Um **single step** não pode ser incluído num **continuous jump**.

O jogo acaba quando todas as peças de um jogador não tiverem uma peça da mesma cor adjacentes (verticalmente, horizontalemente e diagonalmente) à mesma.
Se ambos os jogadores chegarem a este estado ao mesmo tempo, o jogador que fez a última jogada perde.

As regras e o funcionamento do jogo foram consultados nos seguintes sites:

- https://kanare-abstract.com/en/pages/apart
- https://cdn.shopify.com/s/files/1/0578/3502/8664/files/Apart_EN.pdf?v=1682248406

# Lógica do jogo

O código do jogo está organizado em diferentes ficheiros, de acordo com o seu propósito. Estes podem ser encontrados na pasta `src`.

Abaixo apresentamos o propósito de cada um:

| Nome do Ficheiro  | Descrição                                                                                    |
| :---------------: | -------------------------------------------------------------------------------------------- |
|      `board`      | Contém os predicados que criam e imprimem o tabuleiro                                        |
| `check_isolation` | Contém os predicados que verificam os niveis de isolamento de uma peça                       |
|   `check_move`    | Contém os predicados que verificam se o movimento é possivel de acordo com as regras do jogo |
|    `check_win`    | Contém os predicados que verificam se um jogador ganhou ou não                               |
|    `distance`     | Contém os predicados que calculam os tamanhos das linhas onde uma peça está inserida         |
|      `menu`       | Contém os menus do jogo                                                                      |
|      `move`       | Contém os predicados relacionados com a movimentação das peças                               |
|      `piece`      | Contém os predicados relacionados com uma peça                                               |
|      `state`      | Contém os estados do jogo                                                                    |
|      `utils`      | Contém predicados de utilidade                                                               |
|      `main`       | Contém o predicado play                                                                      |

### Representação interna do estado do jogo

O estado interno do jogo é guardado numa variável chamada GameState. Esta variável é composta pelo tabuleiro, jogador atual, número total de movimentações realizadas, posições visitadas pela peça da jogada atual, um booleano que representa se estamos a realizar um continuous jump e pelas coordenadas da peça da jogada atual.

- **Tabuleiro**

O tabuleiro é representado como uma matriz, isto é, uma lista com sublistas. Cada sublista representa uma linha do tabuleiro e cada elemento dentro de cada sublista representa um quadrado do tabuleiro.

Neste quadrado, podemos ter três valores possíveis, `0`, `1` ou `2`.

- `0` representa um quadrado vazio.
- `1` representa uma peça do jogador 1.
- `2` representa uma peça do jogador 2.

Estado inicial de um tabuleiro 8x8:

![img](docs/initial_state.png)

Estado intermédio de um tabuleiro 8x8:

![img](docs/intermediate_state.png)

Estado final de um tabuleiro 8x8:

![img](docs/final_state.png)

- **Jogador atual**

O jogador atual é representado através da variável `Turn`.

No final de cada ronda, o jogador atual é trocado utilizando o seguinte predicado `change_player(?Player1,?Player2)`.

```prolog
change_player(1,2).
change_player(2,1).
```

- **Número total de movimentações realizados**

O número total de movimentações realizados é representado pela variável `TotalMoves` e é meramente uma informação adicional representada quando se dá display do board.

### Visualização do estado do jogo

- ### Menu do Modo de Jogo

O predicado usado para criar o menu que define o modo de jogo chama-se **menu_game_mode(-Option)**.

Abaixo é possivel ver a representação deste menu na consola.

```sh
---------------------------------------------
|            MENU GAME MODE JUMP            |
| Select the mode in which you want to play |
| 1: Person vs Person                       |
| 2: Person vs Easy AI                      |
| 3: Easy AI vs Person                      |
| 4: Easy AI vs Easy AI                     |
| 5: Person vs Difficult AI                 |
| 6: Difficult AI vs Person                 |
| 7: Easy AI vs Difficult AI                |
| 8: Difficult AI vs Easy AI                |
| 9: Difficult AI vs Difficult AI           |
---------------------------------------------
Select the number of the option:
```

- ### Tabuleiro

O tabuleiro do jogo é imprimido sempre antes de haver uma movimentação de peças, podendo este ser qualquer tamanho de altura ou largura, desde que esteja compreendido entre 5 e 15.

Devido a esta possivel variação de tamanhos, é preciso defini-los no início do jogo, usando o seguinte predicado **initial_state(-GameState)**. Este utiliza outros predicados como: **read_size_board(-Height,-Width)**, que lê a altura e largura definidas pelo jogador, e **make_initial_board(+Height,+Width,-Board)**, que cria o tabuleiro com as especificações obtidas.

Depois de passar esta primeira fase, e usando o predicado **display_game(+GameState)**, é possivel obter a seguinte representação do tabuleiro 5x5, caso forem essas as medidas definidas.

```sh
  a   b   c   d   e
---------------------
|   | 1 | 1 | 1 |   | 1
---------------------
|   | 1 | 1 | 1 |   | 2
---------------------
|   |   |   |   |   | 3
---------------------
|   | 2 | 2 | 2 |   | 4
---------------------
|   | 2 | 2 | 2 |   | 5
---------------------
```

É importante referir ainda que a variavel `Board`, definida em **initial_state/3**, é uma matriz composto por 0,1 e 2. Os números 1 e 2 representam as peças dos jogadores, e podem ser visualizadas durante o jogo, e o 0 representa uma "casa" vazia, e por isso é representado no tabuleiro como `' '`.

- ### Menu de Continuous Jump

Caso o jogador tinha feito um jump, e se na nova posição onde se encontra a peça é possivel fazer outro, então o sistema tem de lhe perguntar se este deseja ou não fazê-lo.

Para isto, é usado um menu que aparece depois de o sistema verificar que esta ação é possivel, estando abaixo a sua representação.

O predicado usado chama-se **menu_jump_cycle(-Option,+Type)**, sendo o `Type` o modo do jogador, que pode ser "pessoa" (simbolizado com 1), "easy ai" (simbolizado com 2) ou "difficult ai" (simbolizado com 3). Este parâmetro é importante uma vez que este menu só é representado no modo 1.

```sh
------------------------------------
|       MENU CONTINUOUS JUMP       |
| Do you want to continue jumping? |
| 1: Yes                           |
| 2: No                            |
------------------------------------
Select the number of the option:
```

### Validação de jogadas e execução

### Lista de jogadas válidas

Para se obter uma lista com as jogadas válidas podemos utilizar o predicado `valid_moves(+GameState,+Player,-ListOfMoves)` que utiliza o predicado `findall/3`. Este predicado obtém todas as peças da equipa do jogador e faz todas as jogadas possíveis

```prolog
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
```

### Final do jogo

O predicado **game_over(+GameState,-Winner)** verifica se algum dos jogadores já ganhou, usando para isso o predicado **check_winner(+Board,+Y,+Player)** que percorre o tabuleiro todo e verifica se as peças do jogador defindido em player estão isoladas.

É importante notar que esta verificação é feita antes de um jogador jogar, e havendo a regra de que caso um jogador faça um movimento que faz com que ambos sejam vencedores, este acaba por ser o perdedor, e por isso **game_over/2** é definido da seguinte forma:

```prolog
game_over((Board,Turn,_),Winner) :-
    change_player(Turn,NewTurn),
    Y is 1,
    \+check_winner(Board,Y,Turn),
    !,
    check_winner(Board,Y,NewTurn),
    Winner is NewTurn.

game_over((_,Turn,_),Turn).
```

### Avaliação do estado do jogo

### Jogada do computador

<<<<<<< HEAD
No menu que permite escolher o modo de jogo podemos verificar que existem dois tipos de _AI_ que o utilizador pode escolher, a `Easy AI` e o `Difficult AI`.
=======
Este jogo possui dois tipos de jogadas por computador. O primeiro tipo é baseado em aleatoriedade, onde o computador seleciona a peça que vai mover, bem como a jogada a fazer, de forma totalmente aleatória. Caso haja a hipótese de realizar um continuous jump, o computador vai gerar um número aleatório entre `1` e `2` e, caso o número gerado seja 1, o computador realiza o continuous jump.
>>>>>>> 31d596029c695edb3e2f3e18e12b3d298a7c267e

O segundo tipo utiliza um algorítmo greedy. Este algorítmo vai selecionar a peça menos isolada da equipa do jogador e vai escolher a jogada que isole melhor esta peça. Para selecionar a peça menos isolada, é calculado o isolamento de cada peça individualmente utilizando o predicado ``. Este predicado calcula quantas peças da própria equipa uma peça tem à sua volta. Caso haja mais do que uma peça com o menor nível de isolamente, o algorítmo seleciona uma de forma aleatória.

Agora que o computador tem uma peça selecionada, o algorítmo vai calcular o nível de isolamento para cada jogada possível que aquela peça pode realizar e vai selecionar a jogada que isole mais a peça. Se houver mais do que uma jogada com o melhor nível de isolamento, o algorítmo seleciona uma de forma aleatória.

Para decidir se o algorítmo faz um continuous jump, este verifica se o nível de isolamente após o continuous jump é melhor ou pior do que o nível de isolamento atual. Se for pior, o continuous jump não é realizado.

# Conclusões

# Bibliografia

Durante a execução do trabalho, foram consultados os seguintes sites para obter informação sobre o jogo:

- https://kanare-abstract.com/en/pages/apart
- https://cdn.shopify.com/s/files/1/0578/3502/8664/files/Apart_EN.pdf?v=1682248406
