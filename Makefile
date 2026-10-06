CC = gcc
CFLAGS = -Wall -Wextra -Wpedantic -std=c17

SRC_DIR = src
OBJ_DIR = build
INC_DIR = include

NAME = $(OBJ_DIR)/bool-cAST.out
TEST_NAME = $(OBJ_DIR)/tests.out

PARSER_SRC = $(SRC_DIR)/parser.y
PARSER_C = $(OBJ_DIR)/parser.tab.c
PARSER_H = $(OBJ_DIR)/parser.tab.h

LEXER_SRC = $(SRC_DIR)/lexer.l
LEXER_C = $(OBJ_DIR)/lex.yy.c

# Sources du programme, sans test.c
SRC = $(filter-out $(SRC_DIR)/test.c,$(wildcard $(SRC_DIR)/*.c))
OBJ = $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# Source des tests
TEST_OBJ = $(OBJ_DIR)/test.o

GENERATED_OBJ = \
	$(OBJ_DIR)/parser.tab.o \
	$(OBJ_DIR)/lex.yy.o


# =========================
# Default
# =========================

all: $(NAME)


# =========================
# Programme
# =========================

$(NAME): $(OBJ) $(GENERATED_OBJ)
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) $^ -o $@ -lfl


# =========================
# Tests
# =========================

test: $(TEST_NAME)
	./$(TEST_NAME)

$(TEST_NAME): $(filter-out $(OBJ_DIR)/main.o,$(OBJ)) $(TEST_OBJ) $(GENERATED_OBJ)
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) $^ -o $@ -lfl


# =========================
# Bison
# =========================

$(PARSER_C) $(PARSER_H): $(PARSER_SRC)
	mkdir -p $(OBJ_DIR)
	bison -d -o $(PARSER_C) $(PARSER_SRC)


# =========================
# Flex
# =========================

$(LEXER_C): $(LEXER_SRC) $(PARSER_H)
	mkdir -p $(OBJ_DIR)
	flex -o $(LEXER_C) $(LEXER_SRC)


# =========================
# Compilation C
# =========================

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -I$(INC_DIR) -I$(OBJ_DIR) -c $< -o $@


# =========================
# Compilation Bison
# =========================

$(OBJ_DIR)/parser.tab.o: $(PARSER_C) $(PARSER_H)
	$(CC) $(CFLAGS) -I$(INC_DIR) -I$(OBJ_DIR) -c $< -o $@


# =========================
# Compilation Flex
# =========================

$(OBJ_DIR)/lex.yy.o: $(LEXER_C) $(PARSER_H)
	$(CC) $(CFLAGS) -I$(INC_DIR) -I$(OBJ_DIR) -c $< -o $@


# =========================
# Run
# =========================

run: $(NAME)
	./$(NAME) "$(filter-out $@,$(MAKECMDGOALS))"


# =========================
# Cleaning
# =========================

clean:
	rm -rf $(OBJ_DIR)

fclean: clean

re: fclean all


# Permet :
# make run "True && False"
%:
	@:


.PHONY: all test run clean fclean re