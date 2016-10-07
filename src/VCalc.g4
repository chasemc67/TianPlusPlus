grammar VCalc;

prog: statement+;

statement: (declaration|assignment|conditional|loop|print) ';';

declaration: TYPEINT assignment         #declAsn
           | TYPEINT ID                 #declNoAsn
           ;
assignment: ID '=' expr;
conditional: STARTIF '(' expr ')' statement+ ENDIF;
loop: STARTLOOP '(' expr ')' statement+ ENDLOOP;
print: PRINT '(' expr ')';

expr: ID                                #exprId
    | INTEGER                           #exprInt
    | '(' expr ')'                      #exprParens
    |  expr op=(MUL|DIV) expr           #exprMulDiv
    |  expr op=(ADD|SUB) expr           #exprAddSub
    |  expr op=(GREAT|LESS) expr        #exprGreatLess
    |  expr op=(EQUAL|NOTEQUAL) expr    #exprEqualNot
    ;



MUL: '*';
DIV: '/';
ADD: '+';
SUB: '-';

LESS: '<';
GREAT: '>';
EQUAL: '==';
NOTEQUAL: '!=';

STARTIF: 'if';
ENDIF: 'fi';
STARTLOOP: 'loop';
ENDLOOP: 'pool';
TYPEINT: 'int';
PRINT: 'print';

NEWLINE: '\r'? '\n' -> skip;
INTEGER: [0-9]+;
ID: CHAR [0-9a-zA-Z]*;
CHAR: [a-zA-Z]+;
WS: ' '+ -> skip;