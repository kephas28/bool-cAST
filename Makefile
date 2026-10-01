CC = gcc
CFLAGS = -Wall -Wextra -Wpedantic -std=c17
NAME = build/bool-cAST.out

SRC_DIR = src
OBJ_DIR = build
INC_DIR = include

SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

all: init $(NAME)

init:
	mkdir -p $(SRC_DIR) $(INC_DIR) $(OBJ_DIR)

$(NAME): $(OBJ)
	$(CC) $(CFLAGS) $^ -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all init clean fclean re

test:
	./build/bool-cAST.out
