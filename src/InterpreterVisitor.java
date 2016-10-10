/**
 * Created by chase on 2016-09-23.
 */
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;

import org.antlr.v4.runtime.misc.Pair;
import org.antlr.v4.runtime.tree.TerminalNode;

public class InterpreterVisitor extends VCalcBaseVisitor<Stuff> {

    Map<String, Stuff> data = new HashMap<String, Stuff>();
    Map<String, String> type = new HashMap<String, String>();
    Scope scope = new Scope();


    @Override 
    public Stuff visitVecType(VCalcParser.VecTypeContext ctx) { return visitChildren(ctx); }

    @Override 
    public Stuff visitIntType(VCalcParser.IntTypeContext ctx) { return visitChildren(ctx); }

    // Need to add type checking and store types properly and stuff
    @Override
    public Stuff visitDeclAsn(VCalcParser.DeclAsnContext ctx) {
        String type = ctx.type().getText();
        Stuff value = visit(ctx.assignment().expr());
        String id = ctx.assignment().ID().getText();

        if (!type.equals(value.type)) {
            System.out.println("Error: Type mismatch");
        }

//        if (scope.inCurrentScope(id)) {
//            System.out.println("Var already defined");
//        }

        scope.addToScope(id, value);

        return value;
    }

    @Override
    public Stuff visitDeclNoAsn(VCalcParser.DeclNoAsnContext ctx) {
        String type = ctx.type().getText();
        ArrayList<Integer> tempList = new ArrayList<Integer>();
        Stuff value;

        if (type.equals("int")) {
            value = new Stuff(0);
        } else {
            tempList.add(0);
            value = new Stuff(tempList);
        }

        String id = ctx.ID().getText();

//        if (scope.inCurrentScope(id)) {
//            System.out.println("Var already defined");
//            // throw error;
//        }
        scope.addToScope(id, value);

        return value;
    }

    @Override
    public Stuff visitAssignment(VCalcParser.AssignmentContext ctx) {
        Stuff value = visit(ctx.expr());
        String id = ctx.ID().getText();

        if (scope.resolve(id) != null) {
            scope.assign(id, value);
        } else {
            System.out.println("That variable hasn't been defined yet");
        }
        return null;
    }

    @Override
    public Stuff visitConditional(VCalcParser.ConditionalContext ctx) {

        scope = new Scope(scope);
        Stuff value = visit(ctx.expr());
        scope = scope.getParent();

        Stuff returnValue;

        if (value.intValue != 0) {
            scope = new Scope(scope);
            // For each statement, visit statement
            for (VCalcParser.StatementContext statement : ctx.statement()) {
                visit(statement);
            }
            scope = scope.getParent();

            returnValue = new Stuff(1);
            return returnValue;
        } else {
            returnValue = new Stuff(0);
            return returnValue;
        }
    }

    // * To do
    @Override
    public Stuff visitLoop(VCalcParser.LoopContext ctx) {

        scope = new Scope(scope);
        Stuff value = visit(ctx.expr());
        scope = scope.getParent();

        Stuff returnValue;
        while (value.intValue != 0) {
            scope = new Scope(scope);
            for (VCalcParser.StatementContext statement : ctx.statement()) {
                visit(statement);
            }
            value = visit(ctx.expr());
            scope = scope.getParent();

        }
        returnValue = new Stuff(1);
        return returnValue;
    }

    @Override
    public Stuff visitPrint(VCalcParser.PrintContext ctx) {
        Stuff value = visit(ctx.expr());
        value.print();
        System.out.println("");
        return null;
    }

    // Expressions
    @Override
    public Stuff visitExprId(VCalcParser.ExprIdContext ctx) {
        String id = ctx.ID().getText();
        Stuff s = scope.resolve(id);
        if(s == null) {
            System.out.println("Error, var hasn't been initialized");
        }
        return s;
    }

    @Override
    public Stuff visitExprInt(VCalcParser.ExprIntContext ctx) {
        Integer intValue = Integer.valueOf(ctx.INTEGER().getText());
        Stuff value = new Stuff(intValue);
        return value;
    }

    @Override
    public Stuff visitExprVec(VCalcParser.ExprVecContext ctx) {
        ArrayList<Integer> valueList = new ArrayList<Integer>();
        Stuff value;
        for (TerminalNode integer : ctx.INTEGER()) {
            valueList.add(Integer.valueOf(integer.getText()));
        }

        value = new Stuff(valueList);

        return value;
    }

    @Override
    public Stuff visitExprBrac(VCalcParser.ExprBracContext ctx) {
        Stuff value = visit(ctx.expr());
        return value;
    }

    @Override
    public Stuff visitExprMulDiv(VCalcParser.ExprMulDivContext ctx) {
        Stuff left = visit(ctx.expr(0));
        Stuff right = visit(ctx.expr(1));
        Stuff value = null;

        if (!left.type.equals(right.type)) {
            if (left.type.equals("int")) {
                left = promoteInteger(left, right);
            } else {
                right = promoteInteger(left, right);
            }
        }

        ArrayList<Integer> outputList;

        if (left.type.equals("int") && right.type.equals("int")){
            if (ctx.op.getType() == VCalcParser.MUL) {
                value = new Stuff(left.intValue * right.intValue);
            } else {
                value = new Stuff(left.intValue / right.intValue);
            }
        } else if (left.type.equals("vector") && right.type.equals("vector")) {
            outputList = new ArrayList<Integer>();

            for (int i = 0; i < Math.min(left.vectorValues.size(), right.vectorValues.size()); i++) {
                if (ctx.op.getType() == VCalcParser.MUL) {
                    outputList.add(left.vectorValues.get(i) * right.vectorValues.get(i));
                } else {
                    outputList.add(left.vectorValues.get(i) / right.vectorValues.get(i));
                }
            }

            // put the rest of the vals in the list, incase vectors aren't same size
            if (left.vectorValues.size() > right.vectorValues.size()) {
                for (int i = right.vectorValues.size(); i < left.vectorValues.size(); i++) {
                    outputList.add(left.vectorValues.get(i));
                }
            } else if (left.vectorValues.size() < right.vectorValues.size()) {
                for (int i = left.vectorValues.size(); i < right.vectorValues.size(); i++) {
                    outputList.add(right.vectorValues.get(i));
                }
            }
            value = new Stuff(outputList);

            
        } else {
            // To Do
            System.out.println("I can't handle this yet");
        }

        return value;
    }

    @Override
    public Stuff visitExprAddSub(VCalcParser.ExprAddSubContext ctx) {
        Stuff left = visit(ctx.expr(0));
        Stuff right = visit(ctx.expr(1));
        Stuff value = null;

        if (!left.type.equals(right.type)) {
            if (left.type.equals("int")) {
                left = promoteInteger(left, right);
            } else {
                right = promoteInteger(left, right);
            }
        }

        ArrayList<Integer> outputList;

        if (left.type.equals("int") && right.type.equals("int")){
            if (ctx.op.getType() == VCalcParser.ADD) {
                value = new Stuff(left.intValue + right.intValue);
            } else {
                value = new Stuff(left.intValue - right.intValue);
            }
        } else if (left.type.equals("vector") && right.type.equals("vector")) {
            outputList = new ArrayList<Integer>();

            for (int i = 0; i < Math.min(left.vectorValues.size(), right.vectorValues.size()); i++) {
                if (ctx.op.getType() == VCalcParser.ADD) {
                    outputList.add(left.vectorValues.get(i) + right.vectorValues.get(i));
                } else {
                    outputList.add(left.vectorValues.get(i) - right.vectorValues.get(i));
                }
            }

            // put the rest of the vals in the list, incase vectors aren't same size
            if (left.vectorValues.size() > right.vectorValues.size()) {
                for (int i = right.vectorValues.size(); i < left.vectorValues.size(); i++) {
                    outputList.add(left.vectorValues.get(i));
                }
            } else if (left.vectorValues.size() < right.vectorValues.size()) {
                for (int i = left.vectorValues.size(); i < right.vectorValues.size(); i++) {
                    outputList.add(right.vectorValues.get(i));
                }
            }
            value = new Stuff(outputList);

            
        } else {
            // To Do
            System.out.println("I can't handle this yet");
        }

        return value;
    }

    @Override
    public Stuff visitExprGreatLess(VCalcParser.ExprGreatLessContext ctx) {
        Stuff left = visit(ctx.expr(0));
        Stuff right = visit(ctx.expr(1));
        Stuff value = null;

        if (!left.type.equals(right.type)) {
            if (left.type.equals("int")) {
                left = promoteInteger(left, right);
            } else {
                right = promoteInteger(left, right);
            }
        }

        ArrayList<Integer> compareResult = new ArrayList<Integer>();

        if (left.type.equals("int") && right.type.equals("int")){
            if (ctx.op.getType() == VCalcParser.LESS) {
                if (left.intValue < right.intValue) {
                    value = new Stuff(1);
                } else {
                    value = new Stuff(0);
                }
            } else {
                if (left.intValue > right.intValue) {
                    value = new Stuff(1);
                } else {
                    value = new Stuff(0);
                }
            }
        } else if (left.type.equals("vector") && right.type.equals("vector")){
            if (ctx.op.getType() == VCalcParser.LESS) { 
                for (int i = 0; i < Math.min(right.vectorValues.size(), left.vectorValues.size()); i++) {
                    if (left.vectorValues.get(i) < right.vectorValues.get(i)) {
                        compareResult.add(1);
                    }
                    else if (left.vectorValues.get(i) >= right.vectorValues.get(i)) {
                        compareResult.add(0);
                    }
                }

                if(left.vectorValues.size() > right.vectorValues.size()) {
                    for (int i = right.vectorValues.size(); i < left.vectorValues.size(); i++) {
                        if (left.vectorValues.get(i) < 0) {
                            compareResult.add(1);
                        } else {
                            compareResult.add(0);
                        }
                    }
                }
            } else { //If we're checking for greater than
                for (int i = 0; i < Math.min(right.vectorValues.size(), left.vectorValues.size()); i++) {
                    if (left.vectorValues.get(i) > right.vectorValues.get(i)) {
                        compareResult.add(1);
                    }
                    else if (left.vectorValues.get(i) <= right.vectorValues.get(i)) {
                        compareResult.add(0);
                    }
                }

                if(left.vectorValues.size() > right.vectorValues.size()) {
                    for (int i = right.vectorValues.size(); i < left.vectorValues.size(); i++) {
                        if (left.vectorValues.get(i) > 0) {
                            compareResult.add(1);
                        } else {
                            compareResult.add(0);
                        }
                    }
                }
            }

            value = new Stuff(compareResult);
            
        } else {
            System.out.println("Type promotion hasn't been implemented yet");
        }

        return value;
    }
    
    @Override
    public Stuff visitExprEqual(VCalcParser.ExprEqualContext ctx) {
        Stuff left = visit(ctx.expr(0));
        Stuff right = visit(ctx.expr(1));
        Stuff value = null;

        if (!left.type.equals(right.type)) {
            if (left.type.equals("int")) {
                left = promoteInteger(left, right);
            } else {
                right = promoteInteger(left, right);
            }
        }

        ArrayList<Integer> compareResult = new ArrayList<Integer>();

        if (left.type.equals("int") && right.type.equals("int")){
            if (ctx.op.getType() == VCalcParser.EQUAL) {
                if (left.intValue == right.intValue) {
                    value = new Stuff(1);
                } else {
                    value = new Stuff(0);
                }
            } else {
                if (left.intValue != right.intValue) {
                    value = new Stuff(1);
                } else {
                    value = new Stuff(0);
                }
            }
        } else if (left.type.equals("vector") && right.type.equals("vector")) {
            if (ctx.op.getType() == VCalcParser.EQUAL) { 
                for (int i = 0; i < Math.min(right.vectorValues.size(), left.vectorValues.size()); i++) {
                    if (left.vectorValues.get(i) == right.vectorValues.get(i)) {
                        compareResult.add(1);
                    }
                    else if (left.vectorValues.get(i) != right.vectorValues.get(i)) {
                        compareResult.add(0);
                    }
                }

                if(left.vectorValues.size() > right.vectorValues.size()) {
                    for (int i = right.vectorValues.size(); i < left.vectorValues.size(); i++) {
                        if (left.vectorValues.get(i) == 0) {
                            compareResult.add(1);
                        } else {
                            compareResult.add(0);
                        }
                    }
                }
            } else { //If we're checking for not equal here
                for (int i = 0; i < Math.min(right.vectorValues.size(), left.vectorValues.size()); i++) {
                    if (left.vectorValues.get(i) != right.vectorValues.get(i)) {
                        compareResult.add(1);
                    }
                    else if (left.vectorValues.get(i) == right.vectorValues.get(i)) {
                        compareResult.add(0);
                    }
                }

                if(left.vectorValues.size() > right.vectorValues.size()) {
                    for (int i = right.vectorValues.size(); i < left.vectorValues.size(); i++) {
                        if (left.vectorValues.get(i) != 0) {
                            compareResult.add(1);
                        } else {
                            compareResult.add(0);
                        }
                    }
                }
            }

            value = new Stuff(compareResult);
           
        } else {
             System.out.println("I can't type promotion yet");
        }

        return value;
    }

    @Override 
    public Stuff visitExprRange(VCalcParser.ExprRangeContext ctx) { 
        Stuff left = visit(ctx.expr(0));
        Stuff right = visit(ctx.expr(1));
        ArrayList<Integer> newVec = new ArrayList<Integer>();
        Stuff value;

        if (!left.type.equals("int") || !right.type.equals("int")) {
            System.out.println("Error, integers expected on both sides");
        }

        for(int i = left.intValue; i <= right.intValue; i++) {
            newVec.add(Integer.valueOf(i));
        }

        value = new Stuff(newVec);

        return value;
    }

    @Override
    public Stuff visitExprGen(VCalcParser.ExprGenContext ctx) {
        // push scope for these vars
        scope = new Scope(scope);

        Stuff returnValue;
        ArrayList<Integer> newList = new ArrayList<Integer>();
        String loopId = ctx.generator().ID().getText();

        Stuff range = visit(ctx.generator().expr(0));

        for (Integer arrayInt : range.vectorValues) {
            Stuff loopVar = new Stuff(arrayInt);
            scope.addToScope(loopId, loopVar);
            newList.add(visit(ctx.generator().expr(1)).intValue);
        }

        returnValue = new Stuff(newList);

        //pop
        scope = scope.getParent();

        return returnValue;
    }

    @Override
    public Stuff visitExprFil(VCalcParser.ExprFilContext ctx) { 
        // push scope for these vars
        scope = new Scope(scope);

        Stuff returnValue;
        ArrayList<Integer> newList = new ArrayList<Integer>();
        String loopId = ctx.filter().ID().getText();
        Stuff conditionalCheck;

        Stuff range = visit(ctx.filter().expr(0));

        for (Integer arrayInt : range.vectorValues) {
            Stuff loopVar = new Stuff(arrayInt);
            scope.addToScope(loopId, loopVar);
            if (visit(ctx.filter().expr(1)).intValue == 1) {
                newList.add(arrayInt);
            }
        }

        returnValue = new Stuff(newList);

        //pop
        scope = scope.getParent();

        return returnValue;
    }

    @Override
    public Stuff visitExprIndex(VCalcParser.ExprIndexContext ctx) {

        Stuff vector = visit(ctx.expr(0));
        Stuff index = visit(ctx.expr(1));
        Stuff returnValue;
        ArrayList<Integer> returnList;

        // index can be an int or vector
        if (index.type.equals("int")) {
            returnValue = new Stuff(vector.vectorValues.get(index.intValue));
        } else {
            returnList = new ArrayList<Integer>();
            for (Integer indexVar : index.vectorValues) {
                if (indexVar >= vector.vectorValues.size()) {
                    returnList.add(0);
                } else {
                    returnList.add(vector.vectorValues.get(indexVar));
                }
            }
            returnValue = new Stuff(returnList);
        }

        return returnValue;
    }

    private Stuff promoteInteger(Stuff left, Stuff right) {
        ArrayList<Integer> promotedVec = new ArrayList<Integer>();
        if (left.type.equals("vector") && !right.type.equals("vector")) {
            for (int i = 0; i < left.vectorValues.size(); i++){
                promotedVec.add(right.intValue);
            }
            return new Stuff(promotedVec);
        } else if (!left.type.equals("vector") && right.type.equals("vector")) {
            for (int i = 0; i < right.vectorValues.size(); i++){
                promotedVec.add(left.intValue);
            }
            return new Stuff(promotedVec);
        }

        return null;
    }
}
