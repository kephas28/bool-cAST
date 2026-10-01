#include <stdio.h>
#include <ASTNode.h>
#include <interpreter.h>
#include <parser.h>

int main (int argc, char *argv[]) {
    ASTNode true_node = {
        .type = AST_BOOL,
        .bool_value = true
    };

    ASTNode false_node = {
        .type = AST_BOOL,
        .bool_value = false
    };

    ASTNode xor_node = {
        .type = AST_XOR,
        .binary.left = &true_node,
        .binary.right = &true_node
    };
    
    bool result = interpreter(&xor_node);
    
    printf("Résultat : %s\n", result ? "True" : "False");
}