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

*Nota*: É necessário ter instalado o SICStus Prolog 4.8 ou uma versão mais recente.

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
- A primeira jogada do jogo tem de ser um **single step**.
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

- ### Representação interna do estado do jogo

- ### Visualização do estado do jogo

- ### Validação de jogadas e execução

- ### Lista de jogadas válidas

- ### Final do jogo

- ### Avaliação do estado do jogo

- ### Jogada do computador

# Conclusões

# Bibliografia

Durante a execução do trabalho, foram consultados os seguintes sites para obter informação sobre o jogo:

- https://kanare-abstract.com/en/pages/apart
- https://cdn.shopify.com/s/files/1/0578/3502/8664/files/Apart_EN.pdf?v=1682248406
