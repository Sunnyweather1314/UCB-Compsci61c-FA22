#include <stdio.h>
#include <string.h>

#include "snake_utils.h"
#include "state.h"

int main(int argc, char* argv[]) {
  char* in_filename = NULL;
  char* out_filename = NULL;
  game_state_t* state = NULL;

  // Parse arguments
  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "-i") == 0 && i < argc - 1) {
      in_filename = argv[i + 1];
      i++;
      continue;
    }
    if (strcmp(argv[i], "-o") == 0 && i < argc - 1) {
      out_filename = argv[i + 1];
      i++;
      continue;
    }
    fprintf(stderr, "Usage: %s [-i filename] [-o filename]\n", argv[0]);
    return 1;
  }

  // Do not modify anything above this line.

  /* Task 7 */

  // Read board from file, or create default board
game_state_t* game;
  if (in_filename != NULL) {
    // TODO: Load the board from in_filename
    // TODO: If the file doesn't exist, return -1
    // TODO: Then call initialize_snakes on the state you made
    FILE* check;
    if (check = fopen(in_filename, "r")) 
      {
        fclose(check);
        game = load_board(in_filename);
        game = initialize_snakes(game);
      }
      else
      {
        return -1;
      }

  } else {
    // TODO: Create default state
    game = create_default_state();
  }

  // TODO: Update state. Use the deterministic_food function
  // (already implemented in snake_utils.h) to add food.
  update_state(game, &deterministic_food);
  // Write updated board to file or stdout
  if (out_filename != NULL) {
    // TODO: Save the board to out_filename
    save_board(game, out_filename);
  } else {
    // TODO: Print the board to stdout
    for (int r = 0; r < game->num_rows; r++) {
      printf("%s\n", state->board[r]);
    }

  }

  // TODO: Free the state
  // free(game->board);
  // free(game->snakes);
  free_state(game);

  return 0;
}