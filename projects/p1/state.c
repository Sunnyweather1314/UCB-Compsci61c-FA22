#include "state.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_state_t* state, unsigned int row, unsigned int col, char ch);
static bool is_tail(char c);
static bool is_head(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static char head_to_body(char c);
static unsigned int get_next_row(unsigned int cur_row, char c);
static unsigned int get_next_col(unsigned int cur_col, char c);
static void find_head(game_state_t* state, unsigned int snum);
static char next_square(game_state_t* state, unsigned int snum);
static void update_tail(game_state_t* state, unsigned int snum);
static void update_head(game_state_t* state, unsigned int snum);

/* Task 1 */
game_state_t* create_default_state() {
  // TODO: Implement this function.

  // Make default Board.
  game_state_t* game_state_d;
  game_state_d = malloc (sizeof(game_state_t));
  game_state_d->num_rows = 18;

  char** board;
  board = malloc (19 * sizeof(char*));
  for (unsigned int r = 0; r < 18; r++) {
    char* row;   
    row = malloc (21 * sizeof(char));
    for (unsigned int c = 0; c < 20; c++) {
      if (r == 0 || r == 17 || c == 0 || c == 19) {
        row[c] = '#';
      } else {
        row[c] = ' ';
      }
      if (r == 2) {
        row[4] = 'D';
        row[3] = '>';
        row[2] = 'd';
        row[9] = '*';
      }
    }
    row[20] = '\0';
    board[r] = row;
  }
  board[18] = '\0';
  game_state_d->board = board;

  // Make the Snake.
  snake_t* snake_d;
  snake_d = malloc (sizeof(snake_t));
  snake_d->tail_row = 2;
  snake_d->head_row = 2;
  snake_d->tail_col = 2;
  snake_d->head_col = 4;
  snake_d->live = true;

  game_state_d->num_snakes = 1;
  game_state_d->snakes = snake_d;

  return game_state_d;
}

/* Task 2 */
void free_state(game_state_t* state) {
  // TODO: Implement this function.
  for (unsigned int r = 0; r < state->num_rows; r++) {
    free(state->board[r]);
  }
  free(state->board);
  free(state->snakes);
  free(state);
  return;
}

/* Task 3 */
void print_board(game_state_t* state, FILE* fp) {
  // TODO: Implement this function.
  for (unsigned int r = 0; r < state->num_rows; r++) {
    fprintf(fp, "%s\n", state->board[r]);
  }
}

/*
  Saves the current state into filename. Does not modify the state object.
  (already implemented for you).
*/
void save_board(game_state_t* state, char* filename) {
  FILE* f = fopen(filename, "w");
  print_board(state, f);
  fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_state_t* state, unsigned int row, unsigned int col) {
  return state->board[row][col];
}

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_state_t* state, unsigned int row, unsigned int col, char ch) {
  state->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c) {
  // TODO: Implement this function.
  char tail_char[] = "wasd";
  return strchr(tail_char, c);
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c) {
  // TODO: Implement this function.
  char tail_char[] = "WASDx";
  return strchr(tail_char, c);
}

/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c) {
  // TODO: Implement this function.
  char tail_char[] = "wasd^<v>WASDx";
  return strchr(tail_char, c);
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c) {
  // TODO: Implement this function.
  if (c == '^') {
    return 'w';
  } else if (c == '<') {
    return 'a';
  } else if (c == '>') {
    return 'd';
  } else if (c == 'v') {
    return 's';
  } else {
    return ' ';
  }
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c) {
  // TODO: Implement this function.
  if (c == 'W') {
    return '^';
  } else if (c == 'A') {
    return '<';
  } else if (c == 'D') {
    return '>';
  } else if (c == 'S') {
    return 'v';
  } else {
    return ' ';
  }
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c) {
  // TODO: Implement this function.
  if (strchr("vsS", c)) {
    return cur_row + 1;
  } else if (strchr("^wW", c)) {
    return cur_row - 1;
  }
  return cur_row;
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c) {
  // TODO: Implement this function.
    if (strchr(">dD", c)) {
    return cur_col + 1;
  } else if (strchr("<aA", c)) {
    return cur_col - 1;
  }
  return cur_col;
}

/*
  Task 4.2

  Helper function for update_state. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  // Snake o_0?
  if (state->num_snakes <= snum) {
    return '?';
  }
  // Declare vars.
  unsigned int next_row, next_col;
  char curr_head, next_pos;
  // Get current situation.
  curr_head = get_board_at(state,
              state->snakes[snum].head_row,
              state->snakes[snum].head_col);
  // Get next situation.
  next_row = get_next_row(state->snakes[snum].head_row, curr_head);
  next_col = get_next_col(state->snakes[snum].head_col, curr_head);
  next_pos = get_board_at(state, next_row, next_col);
  return next_pos;
}

/*
  Task 4.3

  Helper function for update_state. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  // Snake o_0?
  if (state->num_snakes <= snum) {
    return;
  }
  // Declare vars.
  unsigned int next_row, next_col;
  char curr_head;
  // Get current situation.
  curr_head = get_board_at(state,
              state->snakes[snum].head_row,
              state->snakes[snum].head_col);
  // Get next situation.
  next_row = get_next_row(state->snakes[snum].head_row, curr_head);
  next_col = get_next_col(state->snakes[snum].head_col, curr_head);
  // Convert current head.
  set_board_at(state, state->snakes[snum].head_row, state->snakes[snum].head_col, head_to_body(curr_head));
  // Update new head.
  state->snakes[snum].head_row = next_row;
  state->snakes[snum].head_col = next_col;
  set_board_at(state, next_row, next_col, curr_head);
  return;
}

/*
  Task 4.4

  Helper function for update_state. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  // Snake o_0?
  if (state->num_snakes <= snum) {
    return;
  }
  // Declare vars.
  unsigned int next_row, next_col;
  char curr_tail, next_pos;
  // Get current situation.
  curr_tail = get_board_at(state,
              state->snakes[snum].tail_row,
              state->snakes[snum].tail_col);
  // Get next situation.
  next_row = get_next_row(state->snakes[snum].tail_row, curr_tail);
  next_col = get_next_col(state->snakes[snum].tail_col, curr_tail);
  // Delete current tail.
  set_board_at(state,
              state->snakes[snum].tail_row,
              state->snakes[snum].tail_col, ' ');
  // Update new tail.
  state->snakes[snum].tail_row = next_row;
  state->snakes[snum].tail_col = next_col;
  next_pos = get_board_at(state, next_row, next_col);
  set_board_at(state, next_row, next_col, body_to_tail(next_pos));
  return;
}

/* Task 4.5 */
void update_state(game_state_t* state, int (*add_food)(game_state_t* state)) {
  // TODO: Implement this function.
  for (unsigned int s = 0; s < state->num_snakes; s++) {
    unsigned int head_row = state->snakes[s].head_row;
    unsigned int head_col = state->snakes[s].head_col;
    if (next_square(state, s) == '#' || is_snake(next_square(state, s))) {
      set_board_at(state, head_row, head_col, 'x');
      state->snakes[s].live = false;
    } else if (next_square(state, s) == '*') {
      update_head(state, s);
      add_food(state);
    } else {
      update_head(state, s);
      update_tail(state, s);
    }
  }
  return;
}

void replace(char* c) {
  unsigned int i = 0;
  while (c[i] != '\n') {
    i++;
  }
  c[i] = '\0';
}

/* Task 5 */
game_state_t* load_board(char* filename) {
  // TODO: Implement this function.
  FILE *file_contentL;
  char c;
  char **board;
  unsigned int row_count, total;
  size_t column_count;
  file_contentL = fopen(filename, "r");

  row_count = 0;
  total = 0;
  c = (char) fgetc(file_contentL);
  column_count = 0;

  while (c != EOF) {
    total += 1;
    if (c == '\n') {
      row_count += 1;
    }
    c = (char) fgetc(file_contentL);
  }
  fclose(file_contentL);
  board = malloc((row_count + 1) * sizeof(char*));

  int size[row_count]; 
  file_contentL = fopen(filename, "r");

  for (int i = 0; i < row_count + 1; i++) {
    column_count = 0;
    c = (char) fgetc(file_contentL);
    while (c != EOF) {
      column_count += 1;
      if (c == '\n') {
          break;
      }
      c = (char) fgetc(file_contentL);
    }
    board[i] = malloc(column_count * sizeof(char));
    size[i] = (int) column_count;
  }
  fclose(file_contentL);

  file_contentL = fopen(filename, "r");

  for (int r = 0; r < row_count + 1; r++) {
    for (int col = 0; col < size[r]; col++) {
      c = (char) fgetc(file_contentL);
      if (c == '\n') {
        board[r][col] = '\0';
      } else {
        board[r][col] = c;
      }
    }
  }
  board[row_count] = '\0';
  fclose(file_contentL);

  game_state_t* game_state;
  game_state = malloc (sizeof(game_state_t));
  game_state->num_rows = row_count;
  game_state->board = board;

  return game_state;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  unsigned int curr_row, curr_col;
  char curr_pos;
  curr_row = state->snakes[snum].tail_row;
  curr_col = state->snakes[snum].tail_col;
  curr_pos = get_board_at(state, curr_row, curr_col);
  while (!strchr("WASDx", curr_pos)) {
    if (strchr("w^", curr_pos)) {
      curr_row--;
    } else if (strchr("a<", curr_pos)) {
      curr_col--;
    } else if (strchr("sv", curr_pos)) {
      curr_row++;
    } else if (strchr("d>", curr_pos)) {
      curr_col++;
    }
    curr_pos = get_board_at(state, curr_row, curr_col);
  }
  state->snakes[snum].head_row = curr_row;
  state->snakes[snum].head_col = curr_col;
  return;
}

/* Task 6.2 */
game_state_t* initialize_snakes(game_state_t* state) {
  // TODO: Implement this function.
  unsigned int num_snakes, *tail_row, *tail_col;
  num_snakes = 0;
  tail_row = malloc (sizeof(unsigned int));
  tail_col = malloc (sizeof(unsigned int));
  for (unsigned int r = 0; r < state->num_rows; r++) {
    for (unsigned int c = 0; c < strlen(state->board[r]); c++) {
      if (is_tail(get_board_at(state, r, c))) {
        tail_row = realloc (tail_row, (num_snakes + 1) * sizeof(unsigned int));
        tail_col = realloc (tail_col, (num_snakes + 1) * sizeof(unsigned int));
        tail_row[num_snakes] = r;
        tail_col[num_snakes] = c;
        num_snakes++;
      }
    }
  }
  state->num_snakes = num_snakes;
  snake_t* snake;
  snake = malloc (num_snakes * sizeof(snake_t));
  for (unsigned int i = 0; i < num_snakes; i++) {
    snake[i].tail_row = tail_row[i];
    snake[i].tail_col = tail_col[i];
    snake[i].live = true;
  }
  state->snakes = snake;
  for (unsigned int i = 0; i < num_snakes; i++) {
    find_head(state, i);
  }
  free(tail_row);
  free(tail_col);
  return state;
}