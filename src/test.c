#include <assert.h>
#include <stdbool.h>

#include <parser.h>
#include <interpreter.h>
#include <ASTNode.h>
#include <stddef.h>

static bool eval(const char *input) {
    ASTNode *ast = parser(input);

    assert(ast != NULL);

    bool result = interpreter(ast);
    ast_free(ast);

    return result;
}

int main(void) {
    assert(eval("true") == true);
    assert(eval("false") == false);

    assert(eval("!true") == false);
    assert(eval("!false") == true);
    assert(eval("!!true") == true);
    assert(eval("!!false") == false);

    assert(eval("true && false") == false);
    assert(eval("true && true") == true);
    assert(eval("false && false") == false);

    assert(eval("true || false") == true);
    assert(eval("false || false") == false);
    assert(eval("false || true") == true);

    assert(eval("true ^ false") == true);
    assert(eval("false ^ true") == true);
    assert(eval("true ^ true") == false);
    assert(eval("false ^ false") == false);

    assert(eval("true => false") == false);
    assert(eval("false => true") == true);
    assert(eval("true => true") == true);
    assert(eval("false => false") == true);

    assert(eval("true <=> false") == false);
    assert(eval("false <=> true") == false);
    assert(eval("true <=> true") == true);
    assert(eval("false <=> false") == true);

    assert(eval("(true)") == true);
    assert(eval("(false)") == false);
    assert(eval("((true))") == true);
    assert(eval("(((false)))") == false);

    assert(eval("(true && false)") == false);
    assert(eval("(true || false)") == true);
    assert(eval("!(true)") == false);
    assert(eval("!(false)") == true);

    assert(eval("(true && true) && false") == false);
    assert(eval("true && (true && true)") == true);

    assert(eval("(true || false) || false") == true);
    assert(eval("false || (false || true)") == true);

    assert(eval("(true && false) || true") == true);
    assert(eval("true && (false || true)") == true);
    assert(eval("(true || false) && false") == false);
    assert(eval("false || (true && false)") == false);

    assert(eval("!(true && false)") == true);
    assert(eval("!(true || false)") == false);

    assert(eval("!(true ^ false)") == false);
    assert(eval("!(true ^ true)") == true);

    assert(eval("!(true => false)") == true);
    assert(eval("!(false => true)") == false);

    assert(eval("!(true <=> false)") == true);
    assert(eval("!(true <=> true)") == false);

    assert(eval("(true && false) || (true && true)") == true);
    assert(eval("(true && false) || (false && true)") == false);

    assert(eval("(true || false) && (true || false)") == true);
    assert(eval("(true || false) && (false || false)") == false);

    assert(eval("(true ^ false) && (true || false)") == true);
    assert(eval("(true ^ true) || (false && true)") == false);

    assert(eval("(true => false) || (false => true)") == true);
    assert(eval("(true => false) && (false => false)") == false);

    assert(eval("(true <=> true) && (false <=> false)") == true);
    assert(eval("(true <=> false) || (true ^ false)") == true);

    assert(eval("!((true && false) || true)") == false);
    assert(eval("!((true || false) && true)") == false);
    assert(eval("!((true && true) && false)") == true);

    assert(eval("((true && true) || false) && true") == true);
    assert(eval("((true && false) || true) && false") == false);

    assert(eval("((true || false) && (true && true))") == true);
    assert(eval("((true || false) && (false && true))") == false);

    assert(eval("((true ^ false) && (true => true))") == true);
    assert(eval("((true ^ true) || (false => false))") == true);

    assert(eval("((true <=> true) && (false <=> false))") == true);
    assert(eval("((true <=> false) || (false ^ false))") == false);

    assert(eval("!((true && false) || (false && true))") == true);
    assert(eval("!((true || false) && (false || false))") == true);

    assert(eval(
        "((true && false) || (true ^ false)) && true"
    ) == true);

    assert(eval(
        "((true && true) && (false || true)) || false"
    ) == true);

    assert(eval(
        "!((true && false) || (true && true))"
    ) == false);

    assert(eval(
        "!((true || false) && (true ^ false))"
    ) == false);

    assert(eval(
        "((true => false) || (false => true)) && true"
    ) == true);

    assert(eval(
        "((true <=> false) || (true ^ false)) && true"
    ) == true);

    assert(eval(
        "!((true => false) && (false <=> false))"
    ) == true);

    assert(eval(
        "(((true && true) || false) && (true ^ false))"
    ) == true);

    assert(eval(
        "(((true && false) || true) && (false ^ false))"
    ) == false);

    assert(eval(
        "!(((true && false) || true) && false)"
    ) == true);

    assert(eval(
        "((((true))))"
    ) == true);

    assert(eval(
        "!(!(!(!true)))"
    ) == true);

    assert(eval(
        "((((true && true))))"
    ) == true);

    assert(eval(
        "(((((true || false)))))"
    ) == true);

    assert(eval(
        "(!((!((true)))))"
    ) == true);

    return 0;
}
