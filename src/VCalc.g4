grammar VCalc;

prog: statement+;

statement: (declaration|assignment|conditional|loop|print|generator) ';';

declaration: type assignment         #declAsn
           | type ID                 #declNoAsn
           ;

assignment: intAssignment               #assignInt
          | vecAssignment               #assignVec
          ;

intAssignment: ID '=' expr;
vecAssignment: ID '=' range;

range: expr '..' expr;

conditional: STARTIF '(' expr ')' statement+ ENDIF;
loop: STARTLOOP '(' expr ')' statement+ ENDLOOP;
print: PRINT '(' expr ')'
     ;

expr: intExpr           #intExpr
    | vecExpr           #vecExpr


intExpr: ID                             #exprId
    | INTEGER                           #exprInt
    | '(' expr ')'                      #exprParens
    |  expr op=(MUL|DIV) expr           #exprMulDiv
    |  expr op=(ADD|SUB) expr           #exprAddSub
    |  expr op=(GREAT|LESS) expr        #exprGreatLess
    |  expr op=(EQUAL|NOTEQUAL) expr    #exprEqualNot
    ;

vecExpr: ID                                #vecExprId
       | '[' (INTEGER)* ']'                #vecExprVec
       | '(' expr ')'                      #vecExprParens
       |  expr op=(MUL|DIV) expr           #vecExprMulDiv
       |  expr op=(ADD|SUB) expr           #vecExprAddSub
       |  expr op=(GREAT|LESS) expr        #vecExprGreatLess
       |  expr op=(EQUAL|NOTEQUAL) expr    #vecExprEqualNot
       |  range                            #vecRange
       |  generator                        #vecGenerator
       ;


vecIndex: ID'['expr']';

type: TYPEINT       #intType
    | TYPEVECTOR    #vecType
    ;

generator:'[' ID 'in' vecExpr '|' expr ']';
filter: '[' ID 'in' vecExpr '&' expr ']';

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