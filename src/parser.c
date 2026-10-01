#include <parser.h>
#include <stddef.h>


typedef struct yy_buffer_state *YY_BUFFER_STATE;

extern YY_BUFFER_STATE yy_scan_string(const char *str);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

extern int yyparse(void);
extern ASTNode *ast_root;

ASTNode *parser(const char *input) {
    YY_BUFFER_STATE buffer;
    ASTNode *result;

    ast_root = NULL;

    buffer = yy_scan_string(input);

    if (buffer == NULL)
        return NULL;

    if (yyparse() != 0) {
        yy_delete_buffer(buffer);
        return NULL;
    }

    result = ast_root;

    yy_delete_buffer(buffer);

    return result;
}