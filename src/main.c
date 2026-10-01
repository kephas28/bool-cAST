#include <stdio.h>
#include <ASTNode.h>
#include <interpreter.h>
#include <parser.h>

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s \"expression\"\n", argv[0]);
        return 1;
    }

    const char *input = argv[1];
    ASTNode *ast = parser(input);

    if (ast == NULL) {
        fprintf(stderr, "Invalid expression\n");
        return 1;
    }

    bool result = interpreter(ast);
    printf("%s\n", result ? "true" : "false");
    ast_free(ast);

    return 0;
}