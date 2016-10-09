grammar VCalc;

prog: statement+;

statement: (declaration|assignment|conditional|loop|print) ';';

type:TYPEVECTOR    #vecType
    |TYPEINT       #intType
    ;

declaration: type assignment    #declAsn
           | type ID            #declNoAsn
           ;

assignment: ID '=' expr;


conditional: STARTIF '(' expr ')' statement+ ENDIF;
loop: STARTLOOP '(' expr ')' statement+ ENDLOOP;
print: PRINT '(' expr ')';


expr: generator                          #exprGenerator
    | filter                             #exprFilter
    | expr '[' expr ']'                  #exprIndex
    | expr '..' expr                     #exprRange
    | '[' (INTEGER)* ']'                 #exprLiteral
    | expr op=(MUL|DIV) expr             #exprMulDiv
    | expr op=(ADD|SUB) expr             #exprAddSub
    | expr op=(GREAT|LESS) expr          #exprGreatLess
    | expr op=(EQUAL|NOTEQUAL) expr      #exprEqual
    | ID                                 #exprId
    | INTEGER                            #exprInt
    | '(' expr ')'                       #exprBrac
    ;

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