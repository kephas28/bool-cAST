#ifndef AST_H
#define AST_H

#include<stdbool.h>

typedef enum {
    AST_BOOL,
    AST_NOT,
    AST_AND,
    AST_OR
} ASTNodeType;

typedef struct ASTNode {
    ASTNodeType type;

    union {
        bool bool_value;

        struct {
            struct ASTNode *child;
        } unary;

        struct {
            struct ASTNode *left;
            struct ASTNode *right;
        } binary;
    };
} ASTNode;

#endif