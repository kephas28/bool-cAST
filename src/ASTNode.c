#include <ASTNode.h>
#include <stddef.h>
#include <stdlib.h>

void ast_free(ASTNode *node)
{
    if (node == NULL)
        return;

    switch (node->type) {
        case AST_BOOL:
            break;

        case AST_NOT:
            ast_free(node->unary.child);
            break;

        case AST_AND:
        case AST_OR:
        case AST_IMPLIES:
        case AST_EQUIVALENT:
        case AST_XOR:
            ast_free(node->binary.left);
            ast_free(node->binary.right);
            break;
    }

    free(node);
}

