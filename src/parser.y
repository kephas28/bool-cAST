%code requires {
#include <ASTNode.h>
}

%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#include <ASTNode.h>

int yylex(void);
void yyerror(const char *message);

ASTNode *ast_root;
%}

%define api.value.type {ASTNode *}

%token TRUE
%token FALSE

%token NOT
%token AND
%token OR
%token IMPLIES
%token EQUIVALENT
%token XOR

/*
 * Du plus faible au plus fort :
 *
 * IMPLIES
 * EQUIVALENT
 * OR
 * XOR
 * AND
 * NOT
 */

%right IMPLIES
%left EQUIVALENT
%left OR
%left XOR
%left AND
%right NOT

%%

input:
    expression
    {
        ast_root = $1;
    }
    ;

expression:

      TRUE
    {
        ASTNode *node = malloc(sizeof(*node));

        if (node == NULL)
            YYABORT;

        node->type = AST_BOOL;
        node->bool_value = true;

        $$ = node;
    }

    | FALSE
    {
        ASTNode *node = malloc(sizeof(*node));

        if (node == NULL)
            YYABORT;

        node->type = AST_BOOL;
        node->bool_value = false;

        $$ = node;
    }

    | NOT expression
    {
        ASTNode *node = malloc(sizeof(*node));

        if (node == NULL)
            YYABORT;

        node->type = AST_NOT;
        node->unary.child = $2;

        $$ = node;
    }

    | expression AND expression
    {
        ASTNode *node = malloc(sizeof(*node));

        if (node == NULL)
            YYABORT;

        node->type = AST_AND;
        node->binary.left = $1;
        node->binary.right = $3;

        $$ = node;
    }

    | expression OR expression
    {
        ASTNode *node = malloc(sizeof(*node));

        if (node == NULL)
            YYABORT;

        node->type = AST_OR;
        node->binary.left = $1;
        node->binary.right = $3;

        $$ = node;
    }

    | expression XOR expression
    {
        ASTNode *node = malloc(sizeof(*node));

        if (node == NULL)
            YYABORT;

        node->type = AST_XOR;
        node->binary.left = $1;
        node->binary.right = $3;

        $$ = node;
    }

    | expression EQUIVALENT expression
    {
        ASTNode *node = malloc(sizeof(*node));

        if (node == NULL)
            YYABORT;

        node->type = AST_EQUIVALENT;
        node->binary.left = $1;
        node->binary.right = $3;

        $$ = node;
    }

    | expression IMPLIES expression
    {
        ASTNode *node = malloc(sizeof(*node));

        if (node == NULL)
            YYABORT;

        node->type = AST_IMPLIES;
        node->binary.left = $1;
        node->binary.right = $3;

        $$ = node;
    }

    | '(' expression ')'
    {
        $$ = $2;
    }

    ;

%%

void yyerror(const char *message)
{
    fprintf(stderr, "Erreur de parsing : %s\n", message);
}