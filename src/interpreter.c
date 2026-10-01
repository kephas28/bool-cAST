#include<ASTNode.h>
#include <stdbool.h>

bool interpreter(const ASTNode *node) {
    switch (node->type) {

        case AST_BOOL:
            return node->bool_value;

        case AST_AND:
            return interpreter(node->binary.left) && interpreter(node->binary.right);

        case AST_OR:
            return interpreter(node->binary.left) || interpreter(node->binary.right);

        case AST_NOT:
            return !interpreter(node->unary.child);

        case AST_IMPLIES:
            return !interpreter(node->binary.left) || interpreter(node->binary.right);

        case AST_EQU:
            return interpreter(node->binary.left) == interpreter(node->binary.right);

        case AST_XOR:
            return interpreter(node->binary.left) != interpreter(node->binary.right);
        
        default:
            return false;
    }
}
