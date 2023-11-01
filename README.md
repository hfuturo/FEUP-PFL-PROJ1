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

Devido a esta possivel variação de tamanhos, é preciso defini-los no início do jogo, usando o seguinte predicado **initial_state(-Height,-Width,-Board)**. Este utiliza outros predicados como: **read_size_board(-Height,-Width)**, que lê a altura e largura definidas pelo jogador, e **make_initial_board(-Height,-Width,-Board)**, que cria o tabuleiro com as especificações obtidas.

Depois de passar esta primeira fase, e usando o predicado **display_game(+Turn,+Width,+Board,+TotalMoves)**, é possivel obter a seguinte representação do tabuleiro 5x5, caso forem essas as medidas definidas.

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

### Final do jogo

O predicado **game_over(+Board,+Width,+Height,+Turn,-Winner)** verifica se algum dos jogadores já ganhou, usando para isso o predicado **check_winner(+Board,+Width,+Height,+Y,+Player,-BoardWinner)** que percorre o tabuleiro todo e verifica se as peças do jogador defindido em player estão isoladas. O parâmetro BoardWinner é 1 caso todas as peças estejam isoladas, e 0 se não estiverem.

É importante notar que esta verificação é feita antes de um jogador jogar, e havendo a regra de que caso um jogador faça um movimento que faz com que ambos sejam vencedores, este acaba por ser o perdedor, e por isso **game_over/5** é definido da seguinte forma:

```sh
game_over(Board,Width,Height,Turn,Winner) :-
    change_player(Turn,NewTurn),
    Y is 1,
    check_winner(Board,Width,Height,Y,Turn,FirstWinner),
    FirstWinner is 0,
    !,
    check_winner(Board,Width,Height,Y,NewTurn,SecondWinner),
    SecondWinner is 1,
    Winner is NewTurn.

game_over(_,_,_,Turn,Turn).
```

### Avaliação do estado do jogo

### Jogada do computador

# Conclusões

# Bibliografia

Durante a execução do trabalho, foram consultados os seguintes sites para obter informação sobre o jogo:

- https://kanare-abstract.com/en/pages/apart
- https://cdn.shopify.com/s/files/1/0578/3502/8664/files/Apart_EN.pdf?v=1682248406
