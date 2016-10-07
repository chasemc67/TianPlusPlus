/**
 * Created by chase on 2016-09-23.
 */
import java.util.HashMap;
import java.util.Map;

public class InterpreterVisitor extends VCalcBaseVisitor<Integer> {

    Map<String, Integer> memory = new HashMap<String, Integer>();

    @Override
    public Integer visitDeclAsn(VCalcParser.DeclAsnContext ctx) {
        Integer value = visit(ctx.assignment().expr());
        String id = ctx.assignment().ID().getText();

        if (memory.containsKey(id)) {
            System.out.println("Var already defined");
            // throw error;
        }
        memory.put(id, value);

        return value;
    }

    @Override
    public Integer visitDeclNoAsn(VCalcParser.DeclNoAsnContext ctx) {
        Integer value = 0;
        String id = ctx.ID().getText();

        if (memory.containsKey(id)) {
            System.out.println("Var already defined");
            // throw error;
        }
        memory.put(id, value);

        return value;
    }

    @Override
    public Integer visitAssignment(VCalcParser.AssignmentContext ctx) {
        Integer value = visit(ctx.expr());
        String id = ctx.ID().getText();

        if (memory.containsKey(id)) {
            memory.put(id, value);
            return value;
        }

        System.out.println("That variable hasn't been defined yet");
        return 0;
    }

    @Override
    public Integer visitConditional(VCalcParser.ConditionalContext ctx) {
        Integer value = visit(ctx.expr());
        if (value != 0) {
            // For each statement, visit statement
            for (VCalcParser.StatementContext statement : ctx.statement()) {
                visit(statement);
            }
            return 1;
        } else {
            return 0;
        }
    }

    // * To do
    @Override
    public Integer visitLoop(VCalcParser.LoopContext ctx) {
        Integer value = visit(ctx.expr());
        while (value != 0) {
            for (VCalcParser.StatementContext statement : ctx.statement()) {
                visit(statement);
            }
            value = visit(ctx.expr());
        }
        return 1;
    }

    @Override
    public Integer visitPrint(VCalcParser.PrintContext ctx) {
        Integer value = visit(ctx.expr());
        System.out.println(value);
        return 0;
    }

    // Expressions
    @Override
    public Integer visitExprInt(VCalcParser.ExprIntContext ctx) {
        Integer value = Integer.valueOf(ctx.INTEGER().getText());
        return value;
    }

    @Override
    public Integer visitExprEqual(VCalcParser.ExprEqualContext ctx) {
        Integer left = visit(ctx.expr(0));
        Integer right = visit(ctx.expr(1));
        if (ctx.op.getType() == VCalcParser.EQUAL) {
            if(left == right) {return 1;} else {return 0;}
        } else {
            if(left != right) {return 1;} else {return 0;}
        }
    }

    @Override
    public Integer visitExprAddSub(VCalcParser.ExprAddSubContext ctx) {
        Integer left = visit(ctx.expr(0));
        Integer right = visit(ctx.expr(1));
        if (ctx.op.getType() == VCalcParser.ADD) {
            return left + right;
        } else {
            return left - right;
        }
    }

    @Override
    public Integer visitExprId(VCalcParser.ExprIdContext ctx) {
        String id = ctx.ID().getText();
        if (memory.containsKey(id)) return memory.get(id);
        System.out.println("Error, var hasn't been initialized");
        return 0;
    }

    @Override
    public Integer visitExprBrac(VCalcParser.ExprBracContext ctx) {
        Integer value = visit(ctx.expr());
        return value;
    }

    @Override
    public Integer visitExprMulDiv(VCalcParser.ExprMulDivContext ctx) {
        Integer left = visit(ctx.expr(0));
        Integer right = visit(ctx.expr(1));
        if (ctx.op.getType() == VCalcParser.MUL) {
            return left*right;
        } else {
            return left/right;
        }
    }

    @Override
    public Integer visitExprGreatLess(VCalcParser.ExprGreatLessContext ctx) {
        Integer left = visit(ctx.expr(0));
        Integer right = visit(ctx.expr(1));
        if (ctx.op.getType() == VCalcParser.LESS) {
            if(left < right) {return 1;} else {return 0;}
        } else {
            if(left > right) {return 1;} else {return 0;}
        }
    }
}
