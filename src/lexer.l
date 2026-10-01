%{
#include <parser.tab.h>
#include <ASTNode.h>
%}

%%

[ \t\r\n]+      ;

"true"          return TRUE;
"false"         return FALSE;

"!"             return NOT;
"&&"            return AND;
"||"            return OR;
"^"             return XOR;
"=>"            return IMPLIES;
"<=>"           return EQUIVALENT;

"("             return '(';
")"             return ')';

.               return yytext[0];

%%