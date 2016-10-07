grammar VCalc;

prog: statement+;

statement: (declaration|assignment|conditional|loop|print|generator|filter) ';';

type:TYPEVECTOR    #vecType
    |TYPEINT       #intType
    ;

declaration: type assignment    #declAsn
           | type ID            #declNoAsn
           ;

assignment: ID '=' expr;

range: intExpr '..' intExpr;

conditional: STARTIF '(' expr ')' statement+ ENDIF;
loop: STARTLOOP '(' expr ')' statement+ ENDLOOP;
print: PRINT '(' expr ')';

expr: ID
   | INTEGER
   | '[' (INTEGER)* ']'
   | '(' expr ')'
   |  expr op=(MUL|DIV) expr
   |  expr op=(ADD|SUB) expr
   |  expr op=(GREAT|LESS) expr
   |  expr op=(EQUAL|NOTEQUAL) expr
   |  range
   |  generator
   ;

intExpr: ID
   | INTEGER
   | '(' intExpr ')'
   |  intExpr op=(MUL|DIV) intExpr
   |  intExpr op=(ADD|SUB) intExpr
   |  intExpr op=(GREAT|LESS) intExpr
   |  intExpr op=(EQUAL|NOTEQUAL) intExpr
   ;

vecIndex: ID'['expr']';

generator: '[' ID 'in' expr '|' expr ']';
filter: '[' ID 'in' expr '&' expr ']';

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
PRINT: 'print';

TYPEINT: 'int';
TYPEVECTOR: 'vector';

NEWLINE: '\r'? '\n' -> skip;
INTEGER: [0-9]+;
ID: CHAR [0-9a-zA-Z]*;
CHAR: [a-zA-Z]+;
WS: ' '+ -> skip;