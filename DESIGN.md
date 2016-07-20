# Game of Life Design Document

The goal is to create an implementation of the 
[game of life](http://en.wikipedia.org/wiki/Conway) from scratch using test
driven development methodologies.

The rules of the game of life are as follows:

1.  Any live cell with fewer than two live neighbours dies, as if caused by
    under-population.
2.  Any live cell with two or three live neighbours lives on to the next
    generation.
3.  Any live cell with more than three live neighbours dies, as if by
    overcrowding.
4.  Any dead cell with exactly three live neighbours becomes a live cell, as if
    by reproduction.

This variation is the original ruleset. It is also known as B3/S23\. or
"**B**orn" with 3 neighbors alive, "**S**tays alive" with 2 or 3 neighbors
alive, and dies otherwise.

## Backend

The backend will control the state of the game. It will represent the board and
each cell on the board. It will have logic for advancing to the next turn, and
reporting on the state of the whole board, down to individual cells.

The board class will be instantiated by a frontend. The frontend is expected to
be able to interact with the board class well enough to instantiate it, ensure
all the starting parameters are in order, display the state of the board (if
desired), and decide when to tell the board to execute the next turn.

The backend will consist of two main classes. The Board class, and the Cell
class.

### Board

The board class is responsible for tracking the positions of each cell. It must
be able to return a list of neighbors of any given cell (and handle cases where
the requesting cell is on the edge). It is responsible for tracking the turn
number for the current turn.

A complete game of life cycle should be completable by only interacting with
the board class directly. The board should also have a way to pass state
information for each cell to a frontend so the board can be displayed.

The board class will take the following parameters on object creation:

* board size
* edge type (dead edges, alive edges, or toroidal wraparound)
* starting layout.

The edge type may be changed before the first turn is executed. Similarly, the
cells may be flipped to alive or dead as needed before the first turn is
executed.

The starting layout must fit on the board size chosen. If it does not, throw an
error.

The board will need to handle a few methods:

* set\_cell\_state - set a cell's state to either alive or dead unless the game
  has advanced to the first turn. Throw an error if the cell coordinates given
  are out of range.
* set\_edge\_type - set the edge type (dead edge or toroidal wraparound) unless
  the game has advanced to the first turn
* advance - execute one turn of the game of life. This will essentially simply
  need to tell all the cells to calculate their next state, and then tell them
  all to change to that state.
* find\_neighbors - given either a position, or an actual instance of a cell,
  return all its neighbors. Must support dead edge **and** toroidal wraparound
  modes.
* show\_board - returns all necessary state information needed to display all
  info about the board and all the cells in it.

### Cell

The cell will know whether it is currently alive or dead. The logic for
determining its next state will be handled within this class, as the rules all
apply to individual cells.

To avoid incorrect execution of the logic, the cell's turn will be split into
two steps. The board will iterate over all cells, asking them to calculate
their next state without any of them changing their state right away. The next
pass will tell the cells that they should go ahead and advance to their next
calculated state.

The cell class will take the following parameters on object creation:

*   parent board (object)
*   initial state (alive or dead)

The cell class will need to support the following methods:

* calculate\_next\_state - based on the list of neighbors given by the parent
  board, and the state of those neigbors, calculate the next state (alive or
  dead) based on the rules of the game of life (given above), and save it as an
  instance variable. This method must be called on all cell objects before
  calling the advance method.
* advance - advance to the previously calculated next state. Throw an error if
  no such calculation has been done.

The cells will also make available their current state, and their calculated
next state (either by accessor methods or direct viewing of the backing
variables)

There will also be a need to have a subclass for an always dead cell. This will
be used by the board in the "edges are dead" mode. These instances will always
return dead for their current state. They will only ever be used by the board
class when returning neighbors to a real cell that is on the edge of a board in
dead edge mode. The real cell classes will only ever query the current state of
their neighbors. Because of this, the calculate\_next\_state and advance
methods should raise an error.

## Frontend

Because the backend will be implemented separately, there is the possibility to
implement multiple frontends. The initial front end will be a simple text
representation of the game. Additional frontends may be added later.

### Text Frontend

The simple text-based front end will only require a standard output and
standard input stream.

Command line options can be used for game parameter input.

Any options that were not specified on the command line will be obtained
interactively by asking the user for game options. Sane defaults will be
indicated and used should the user give no input.

The initial state of the board will be chosen from a list of presets, or by
inputting coordinates directly.

Once all game options have been input, they will be displayed for confirmation
by the user. The user will be able to change any options, or start the game.
This functionality may be disabled by a command line option.

Errors in input should be detected and handled properly. For example, choosing
a 2x2 board size, and giving a coordinate of 4,5 for one of the starting cells
should prompt the user to revise their input in a meaningful way.

Possible help text for the text-based frontend (some or all options may be
suitable for a gui or curses version as well):

    # gol --help
    gol [OPTIONS]
    OPTIONS:
    -h, --help - show this message
    -s WxH, --size WxH - size of game board, default is 40x15
    -e [d|w], --edge [d|w] - edge type: [d]ead or toroidal [w]rap.
                             w is default
    -i [gosper|glider|pulsar|[LIST]], --initial [gosper|glider|pulsar|[LIST]] -
       starting layout. can choose the gosper glider gun (default), the glider,
       a pulsar, or provide a LIST of coordinates in the format of
       
         x1,y1,x2,y2,x3,y3,...

    -n, --noconfirm - don't confirm any choices. start game immediately after
                      minimum options for a game have been gathered.
    -d, --default - use all defaults. implies -n.

Possible interaction to start the game of life from the command line:

    # gol
    Welcome to the game of life.
    What should the board size be? WxH [40x15\. 40x12
    What should the edge behavior be? [D]ead edges, or toroidal [W]raparound? [d]
    What should the initial layout be? gosper, glider, pulsar, or a list of coordinates in the format x1,y1,x2,y2,x3,y3,... [gosper]
    You have chosen a board size of 40x1\. with toroidal wraparound edges, with the following starting pattern:
    +----------------------------------------+
    |........................O...............|
    |......................O.O...............|
    |............OO......OO............OO....|
    |...........O...O....OO............OO....|
    |OO........O.....O...OO..................|
    |OO........O...O.OO....O.O...............|
    |..........O.....O.......O...............|
    |...........O...O........................|
    |............OO..........................|
    |........................................|
    |........................................|
    |........................................|
    +----------------------------------------+
    Change [S]ize, Change [E]dge type, Change [I]nitial pattern, [C]ontinue to the first turn? [C]
    Starting the game of life...
    Turn     1
    &lt;board representation after turn 1&gt;
    Press [space] to advance. Press [A] to start auto-advance every second. Press [Q] to quit the game of life. A
    Turn 2
    &lt;board representation after turn 2&gt;
    Autoadvancing in 1 second. Press [S] to stop auto-advance. Press [Q] to quit the game of life.

### Curses Frontend

The initial project is only the text frontend, but a curses frontend could be
implemented in the future.

The curses frontend should behave quite a lot like the text version, but should
also have a persistent view pane showing the board. The options for the board
should be displayed in a pane above the main board view. Before turn 1, the
options will be editable in place, and accessible by tabbing through them, or
clicking on them. When advancing to turn one, a confirmation dialog should be
shown, letting the user know that they can't change options later.

To load one of the presets available, the user presses a button to bring up a
list. Once the preset is selected, it is loaded in the pane showing the board.

The user can additionally choose which cells are alive or dead by clicking on
the boxes in the preview of the board.

Here is an example of what the basic layout might be, and what the board may
look like with an initial state for the cells.

Colors could also be introduced to draw attention to the border of the
gameboard, turn counter, and editable inputs.

    ┌────────────────────────────────────────────────────────────────────────────────┐
    │ Game of Life                                                                   │
    ├───────────────────────────────────────┬────────────────────────────────────────┤
    │                                       │                                        │
    │ Edge type : dead                      │ Turn: 0 (initial setup)                │
    │ Board Size: 40x15                     │ [L]oad a preset board                  │
    │                                       │                                        │
    ├───────────────────────────────────────┴────────────────────────────────────────┤
    │                                                                                │
    │  ┌────────────────────────────────────────┐                                    │
    │  │                        █               │                                    │
    │  │                      █ █               │                                    │
    │  │            ██      ██            ██    │                                    │
    │  │           █   █    ██            ██    │                                    │
    │  │██        █     █   ██                  │                                    │
    │  │██        █   █ ██    █ █               │                                    │
    │  │          █     █       █               │                                    │
    │  │           █   █                        │                                    │
    │  │            ██                          │                                    │
    │  │                                        │                                    │
    │  │                                        │                                    │
    │  │                                        │                                    │
    │  └────────────────────────────────────────┘                                    │
    │                                                                                │
    │                                                                                │
    │                                                                                │
    ├────────────────────────────────────────────────────────────────────────────────┤
    │ <space> to advance one turn. Start [A]uto-advance. [Q]uit the game of life.    │
    └────────────────────────────────────────────────────────────────────────────────┘

### GUI frontend

Another possible frontend implementation would be a GUI using some toolkit that
can run in a "native" window on the current platform. Such a frontend should at
least support OSX, Windows, and Linux.

Much of the design could be taken from the curses layout and options. Instead
of keypresses however, there should be controls appropriate for the toolkit
used to perform the same actions.

Some type of graphics library could be used to display the game board. Hovering
over a cell should give a tooltip that contains both its current and its next
state.

TODO: Mockup screenshot

### Web Frontend

This would be a two part front end. The front end as far as the game of life
would be concerned would be a json API that can perform all the actions needed
to instantiate a board with all the needed starting information, obtained via a
PUT request. The API would also be able to return the state of the board in
JSON. It would also accept POST requests to advance to the next turn.

With the API in place, a javascript client frontend would also be implemented
that could talk to the json API.
