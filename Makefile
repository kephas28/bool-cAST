CC = gcc
CFLAGS = -Wall -Wextra -Wpedantic -std=c17

$(PARSER_C) $(PARSER_H): $(PARSER_SRC)
	mkdir -p $(OBJ_DIR)
	bison -d -o $(PARSER_C) $(PARSER_SRC)

NAME = build/bool-cAST.out

SRC_DIR = src
OBJ_DIR = build
INC_DIR = include

PARSER_SRC = $(SRC_DIR)/parser.y
PARSER_C = $(OBJ_DIR)/parser.tab.c
PARSER_H = $(OBJ_DIR)/parser.tab.h

LEXER_SRC = $(SRC_DIR)/lexer.l
LEXER_C = $(OBJ_DIR)/lex.yy.c

SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

GENERATED_OBJ = \
	$(OBJ_DIR)/parser.tab.o \
	$(OBJ_DIR)/lex.yy.o


all: $(NAME)


# =========================
# Link
# =========================

$(NAME): $(OBJ) $(GENERATED_OBJ)
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
# C sources
# =========================

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -I$(INC_DIR) -I$(OBJ_DIR) -c $< -o $@


# =========================
# Bison object
# =========================

$(OBJ_DIR)/parser.tab.o: $(PARSER_C) $(PARSER_H)
	$(CC) $(CFLAGS) -I$(INC_DIR) -I$(OBJ_DIR) -c $(PARSER_C) -o $@


# =========================
# Flex object
# =========================

$(OBJ_DIR)/lex.yy.o: $(LEXER_C) $(PARSER_H)
	$(CC) $(CFLAGS) -I$(INC_DIR) -I$(OBJ_DIR) -c $(LEXER_C) -o $@


# =========================
# Cleaning
# =========================

clean:
	rm -rf $(OBJ_DIR)

fclean: clean

re: fclean all


# =========================
# Test
# =========================

test: $(NAME)
	./$(NAME) "$(filter-out $@,$(MAKECMDGOALS))"

%:
	@:


.PHONY: all clean fclean re test