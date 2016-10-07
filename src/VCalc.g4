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
print: PRINT '(' expr ')'
     ;

expr: intExpr
    | vecExpr
    ;

intExpr: ID                                   #exprId
    | INTEGER                                 #exprInt
    | '(' intExpr ')'                            #exprParens
    |  intExpr op=(MUL|DIV) intExpr           #exprMulDiv
    |  intExpr op=(ADD|SUB) intExpr           #exprAddSub
    |  intExpr op=(GREAT|LESS) intExpr        #exprGreatLess
    |  intExpr op=(EQUAL|NOTEQUAL) intExpr    #exprEqualNot
    ;

vecExpr: ID                                #vecExprId
       | '[' (INTEGER)* ']'                #vecExprVec
       | '(' vecExpr ')'                      #vecExprParens
       |  (vecExpr|intExpr) op=(MUL|DIV) (vecExpr|intExpr)           #vecExprMulDiv
       |  (vecExpr|intExpr) op=(ADD|SUB) (vecExpr|intExpr)           #vecExprAddSub
       |  (vecExpr|intExpr) op=(GREAT|LESS) (vecExpr|intExpr)        #vecExprGreatLess
       |  (vecExpr|intExpr) op=(EQUAL|NOTEQUAL) (vecExpr|intExpr)    #vecExprEqualNot
       |  range                            #vecRange
       |  generator                        #vecGenerator
       ;

vecIndex: ID'['expr']';

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