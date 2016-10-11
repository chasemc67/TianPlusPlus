import java.util.EmptyStackException;
import java.util.HashMap;
import java.util.Map;

import org.stringtemplate.v4.*;

public class LLVMVisitor extends VCalcBaseVisitor<String> {

	LLVMScope scope = new LLVMScope();
	Integer scopeCounter = 0;

	STGroup group = new STGroupFile("./src/StringTemplates/llvm.stg");

	// The starting boilerplate for the assembly program
	ST st = group.getInstanceOf("prog");
	String beginProg = st.render();

	// The global variable declarations of the program
	String variableDeclarations = "";

	// The start of main
	ST st2 = group.getInstanceOf("main");
	String initMain = st2.render();

	// The main body of the program
	String programBody = "";

	// Code to safely exit program
	ST st3 = group.getInstanceOf("exit");
	String exitProgram = st3.render();

	// main uses 3 of these right off the bat
	Integer varCounter = 3;

	Map<String, Integer> userVarCounter = new HashMap<String, Integer>();

    String currentType = "int";

    int IfCount = 4;


	@Override
	public String visitProg(VCalcParser.ProgContext ctx) {
		// Have the children all write their subroutines to the program
		// body and variable declarations
		visitChildren(ctx);

		//Compile final program and print
		String output = beginProg + variableDeclarations + "\n" + initMain + programBody + "\n" + exitProgram;
		System.out.println(output);
		return null;
	}

    @Override public String visitExprBrac(VCalcParser.ExprBracContext ctx) { return visit(ctx.expr()); }

	@Override
    public String visitDeclAsn(VCalcParser.DeclAsnContext ctx) {
    	String userDefinedName = ctx.assignment().ID().getText();

		if (ctx.type().getText().equals("int")) {
            scope.addToScope(userDefinedName, getLLVMVarName(scope, userDefinedName), "int");
			ST output = group.getInstanceOf("declareIntVar");
			ST output2 = output.add("varName", getCurrentForUserVar(scope, userDefinedName));
			programBody = programBody + "\n" + output.render();
		} else {
			scope.addToScope(userDefinedName, getLLVMVarName(scope, userDefinedName), "vector");
			ST output = group.getInstanceOf("declareVecVar")
						.add("varName", getCurrentForUserVar(scope, userDefinedName));
			programBody = programBody + "\n" + output.render();
		}

    	visit(ctx.assignment());
    	return null;
    }

    @Override
    public String visitDeclNoAsn(VCalcParser.DeclNoAsnContext ctx) {
    	String userDefinedName = ctx.ID().getText();

        if (userVarCounter.containsKey(userDefinedName)){
            System.out.println("Var has already been defined");
        }
        userVarCounter.put(userDefinedName, 0);

        if (ctx.type().getText().equals("int")) {
            scope.addToScope(userDefinedName, getLLVMVarName(scope, userDefinedName), "int");
            ST output = group.getInstanceOf("declareIntVar");
            ST output2 = output.add("varName", getCurrentForUserVar(scope, userDefinedName));
            programBody = programBody + "\n" + output.render();

        } else {
            scope.addToScope(userDefinedName, getLLVMVarName(scope, userDefinedName), "vector");
            ST output = group.getInstanceOf("declareVecVar")
                        .add("varName", getCurrentForUserVar(scope, userDefinedName));
            programBody = programBody + "\n" + output.render();
        }

    	return null;
    }

    @Override
    public String visitAssignment(VCalcParser.AssignmentContext ctx) {
    	String userDefinedName = ctx.ID().getText();
    	visit(ctx.expr());
    	String exprResult = getCurrentVar();
		if (scope.getLLVMType(userDefinedName).equals("int")) {
			ST output = group.getInstanceOf("assignIntToVar");
			ST output2 = output.add("varName", getCurrentForUserVar(scope, userDefinedName));
			ST output3 = output.add("assignResult", exprResult);
			ST output4 = output.add("tempVar1", getNextVar());
			programBody = programBody + "\n" + output.render();
            return "int";
		} else {
            ST output = group.getInstanceOf("swapVec")
                    .add("var1", this.getCurrentForUserVar(scope, userDefinedName))
                    .add("var2", exprResult);
            programBody = programBody + "\n ;-------- \n" + output.render();
            currentType = "vector";
            return "vector";
		}
    }

	@Override
	public String visitPrint(VCalcParser.PrintContext ctx) {

	    // Get the value that we'll be printint out onto the stack
	    String type = visit(ctx.expr());

        if (type.equals("int")) {
            ST output = group.getInstanceOf("printIntFromStack");
            ST output2 = output.add("varNumberOfResult", this.getCurrentVar());
            ST output3 = output.add("newVarNumber", this.getNextVar());
            ST output4 = output.add("loaderVar", this.getNextVar());
            programBody = programBody + "\n" + output.render();
        } else {
            ST output = group.getInstanceOf("printVec")
                        .add("varName", this.getCurrentVar())
                        .add("tempVar1", this.getNextVar());
            programBody = programBody + "\n" + output.render();
        }
	    return null;
	}

	@Override
    public String visitExprId(VCalcParser.ExprIdContext ctx) {
        String userDefinedName = ctx.ID().getText();
        String type = scope.getLLVMType(userDefinedName);

        if (type.equals("int")) {
            ST output = group.getInstanceOf("writeIntIdToVar");
            ST output2 = output.add("varName", getCurrentForUserVar(scope, userDefinedName));
            ST output3 = output.add("tempVar1", getNextVar());
            ST output4 = output.add("resultVar", getNextVar());
            programBody = programBody + "\n" + output.render();
        } else {
			ST output = group.getInstanceOf("declareVecVar")
					.add("varName", this.getNextVar());
			programBody = programBody + "\n" + output.render();
            output = group.getInstanceOf("copyVec")
						.add("var1", getCurrentForUserVar(scope, userDefinedName))
						.add("var2", getCurrentVar());
			programBody = programBody + "\n" + output.render();
        }
        return type;
    }

	@Override
	public String visitExprInt(VCalcParser.ExprIntContext ctx) {
	    Integer intValue = Integer.valueOf(ctx.INTEGER().getText());
	    ST output = group.getInstanceOf("writeIntToStack");
	    ST output2 = output.add("varNumber", this.getNextVar());
	    ST output3 = output.add("intValue", intValue);
	    programBody = programBody + "\n" + output.render();
	    return "int";
	}

	@Override
    public String visitExprMulDiv(VCalcParser.ExprMulDivContext ctx) {
    	String leftType = visit(ctx.expr(0));
    	String leftVar = this.getCurrentVar();
    	String rightType = visit(ctx.expr(1));
    	String rightVar = this.getCurrentVar();

        if (!leftType.equals(rightType)) {
            if (leftType.equals("int")) {
                promoteVar(leftVar, rightVar);
                leftVar = this.getCurrentVar();
                leftType = "vector";
            } else {
                promoteVar(rightVar, leftVar);
                rightVar = this.getCurrentVar();
                rightType = "vector";
            }
        }

    	ST output;

        if (leftType.equals("int") && rightType.equals("int")) {

        	if (ctx.op.getType() == VCalcParser.MUL) {
        		output = group.getInstanceOf("integerMul");
        	} else {
        		output = group.getInstanceOf("integerDiv");
        	}
        	ST output2 = output.add("leftVar", leftVar);
        	ST output3 = output.add("rightVar", rightVar);
        	ST output4 = output.add("tempVar1", getNextVar());
        	ST output5 = output.add("tempVar2", getNextVar());
        	ST output6 = output.add("tempVar3", getNextVar());
        	ST output7 = output.add("resultVar", getNextVar());

        	programBody = programBody + "\n" + output.render();
         	return "int";
        } else if (leftType.equals("vector") && rightType.equals("vector")) {
            if (ctx.op.getType() == VCalcParser.MUL) {
                output = group.getInstanceOf("vectorMul");
            } else {
                output = group.getInstanceOf("vectorDiv");
            }
            ST output2 = output.add("leftVar", leftVar);
            ST output3 = output.add("rightVar", rightVar);
            ST output4 = output.add("tempVar1", getNextVar());
            ST output5 = output.add("tempVar2", getNextVar());
            ST output6 = output.add("tempVar3", getNextVar());
            output.add("tempVar4", getNextVar());
            ST output7 = output.add("resultVar", getNextVar());

            programBody = programBody + "\n" + output.render();
            return "vector";
        } else {
            System.out.println("I can't do integer promotion yet");
            return "vector";
        }
    }


	@Override
    public String visitExprAddSub(VCalcParser.ExprAddSubContext ctx) {
    	String leftType = visit(ctx.expr(0));
    	String leftVar = this.getCurrentVar();
    	String rightType = visit(ctx.expr(1));
    	String rightVar = this.getCurrentVar();

        if (!leftType.equals(rightType)) {
            if (leftType.equals("int")) {
                promoteVar(leftVar, rightVar);
                leftVar = this.getCurrentVar();
                leftType = "vector";
            } else {
                promoteVar(rightVar, leftVar);
                rightVar = this.getCurrentVar();
                rightType = "vector";
            }
        }

    	ST output;

        if (leftType.equals("int") && rightType.equals("int")) {

        	if (ctx.op.getType() == VCalcParser.ADD) {
        		output = group.getInstanceOf("integerAdd");
        	} else {
        		output = group.getInstanceOf("integerSub");
        	}
        	ST output2 = output.add("leftVar", leftVar);
        	ST output3 = output.add("rightVar", rightVar);
        	ST output4 = output.add("tempVar1", getNextVar());
        	ST output5 = output.add("tempVar2", getNextVar());
        	ST output6 = output.add("tempVar3", getNextVar());
        	ST output7 = output.add("resultVar", getNextVar());

        	programBody = programBody + "\n" + output.render();
        	return "int";
        } else if (leftType.equals("vector") && rightType.equals("vector")) {
            if (ctx.op.getType() == VCalcParser.ADD) {
                output = group.getInstanceOf("vectorAdd");
            } else {
                output = group.getInstanceOf("vectorSub");
            }
            ST output2 = output.add("leftVar", leftVar);
            ST output3 = output.add("rightVar", rightVar);
            ST output4 = output.add("tempVar1", getNextVar());
            ST output5 = output.add("tempVar2", getNextVar());
            ST output6 = output.add("tempVar3", getNextVar());
            output.add("tempVar4", getNextVar());
            ST output7 = output.add("resultVar", getNextVar());
            programBody = programBody + "\n" + output.render();
            return "vector";
        } else {
            System.out.println("I can't do integer promotion yet");
            return "vector";
        }

    }

    @Override
	public String visitExprGreatLess(VCalcParser.ExprGreatLessContext ctx) {
		String leftType = visit(ctx.expr(0));
		String leftVar = this.getCurrentVar();
		String rightType = visit(ctx.expr(1));
		String rightVar = this.getCurrentVar();

        if (!leftType.equals(rightType)) {
            if (leftType.equals("int")) {
                promoteVar(leftVar, rightVar);
                leftVar = this.getCurrentVar();
                leftType = "vector";
            } else {
                promoteVar(rightVar, leftVar);
                rightVar = this.getCurrentVar();
                rightType = "vector";
            }
        }

		ST output;

        if (leftType.equals("int") && rightType.equals("int")) {

    		if (ctx.op.getType() == VCalcParser.GREAT) {
    			output = group.getInstanceOf("integerGreat");
    		} else {
    			output = group.getInstanceOf("integerLess");
    		}
    		ST output2 = output.add("leftVar", leftVar);
    		ST output3 = output.add("rightVar", rightVar);
    		ST output4 = output.add("tempVar1", getNextVar());
    		ST output5 = output.add("tempVar2", getNextVar());
    		ST output6 = output.add("tempVar3", getNextVar());
    		ST output7 = output.add("tempVar4", getNextVar());
    		ST output8 = output.add("resultVar", getNextVar());

    		programBody = programBody + "\n" + output.render();
    		return "int";
        } else if (leftType.equals("vector") && rightType.equals("vector")) {
            if (ctx.op.getType() == VCalcParser.GREAT) {
                output = group.getInstanceOf("vectorGreat");
            } else {
                output = group.getInstanceOf("vectorLess");
            }
            ST output2 = output.add("leftVar", leftVar);
            ST output3 = output.add("rightVar", rightVar);
            ST output4 = output.add("tempVar1", getNextVar());
            ST output5 = output.add("tempVar2", getNextVar());
            ST output6 = output.add("tempVar3", getNextVar());
            ST output7 = output.add("tempVar4", getNextVar());
            ST output8 = output.add("resultVar", getNextVar());

            programBody = programBody + "\n" + output.render();
            return "vector";
        } else {
            System.out.println("I can't do integer promotion yet");
            return "vector";
        }
	}



	@Override
	public String visitExprEqual(VCalcParser.ExprEqualContext ctx) {
		String leftType = visit(ctx.expr(0));
		String leftVar = this.getCurrentVar();
		String rightType = visit(ctx.expr(1));
		String rightVar = this.getCurrentVar();

        if (!leftType.equals(rightType)) {
            if (leftType.equals("int")) {
                promoteVar(leftVar, rightVar);
                leftVar = this.getCurrentVar();
                leftType = "vector";
            } else {
                promoteVar(rightVar, leftVar);
                rightVar = this.getCurrentVar();
                rightType = "vector";
            }
        }

		ST output;

        if (leftType.equals("int") && rightType.equals("int")) {

    		if (ctx.op.getType() == VCalcParser.EQUAL) {
    			output = group.getInstanceOf("integerEquals");
    		} else {
    			output = group.getInstanceOf("integerNotEquals");
    		}
    		ST output2 = output.add("leftVar", leftVar);
    		ST output3 = output.add("rightVar", rightVar);
    		ST output4 = output.add("tempVar1", getNextVar());
    		ST output5 = output.add("tempVar2", getNextVar());
    		ST output6 = output.add("tempVar3", getNextVar());
    		ST output7 = output.add("tempVar4", getNextVar());
    		ST output8 = output.add("resultVar", getNextVar());

    		programBody = programBody + "\n" + output.render();
    		return "int";
        } else if (leftType.equals("vector") && rightType.equals("vector")) {
            if (ctx.op.getType() == VCalcParser.EQUAL) {
                output = group.getInstanceOf("vectorEqual");
            } else {
                output = group.getInstanceOf("vectorNotEqual");
            }
            ST output2 = output.add("leftVar", leftVar);
            ST output3 = output.add("rightVar", rightVar);
            ST output4 = output.add("tempVar1", getNextVar());
            ST output5 = output.add("tempVar2", getNextVar());
            ST output6 = output.add("tempVar3", getNextVar());
            ST output7 = output.add("tempVar4", getNextVar());
            ST output8 = output.add("resultVar", getNextVar());

            programBody = programBody + "\n" + output.render();
            return "vector";
        } else {
            System.out.println("I can't do integer promotion yet");
            return "vector";
        }
	}

    @Override 
    public String visitExprRange(VCalcParser.ExprRangeContext ctx) { 
        visit(ctx.expr(0));
        String leftVar = this.getCurrentVar();
        visit(ctx.expr(1));
        String rightVar = this.getCurrentVar();

        ST output = group.getInstanceOf("writeRangeToVar");
        ST output2 = output.add("leftVar", leftVar);
        ST output3 = output.add("rightVar", rightVar);
        output.add("tempVar1", getNextVar());
        output.add("tempVar2", getNextVar());
        output.add("tempVar3", getNextVar());
        output.add("tempVar4", getNextVar());
		output.add("tempVar5", getNextVar());
        ST outputf = output.add("resultVar", getNextVar());

        programBody = programBody + "\n" + output.render();
        return "vector";
    }

    @Override
    public String visitExprVec(VCalcParser.ExprVecContext ctx) {
//        Integer intValue = Integer.valueOf(ctx.INTEGER().getText());
        int size = ctx.INTEGER().size();
        String tmp = this.getNextVar();
        ST output = group.getInstanceOf("declareVecVar")
                    .add("varName", tmp);
        programBody = programBody + "\n" + output.render();

        String thisVector = this.getCurrentVar();

        output = group.getInstanceOf("allocateVecVar")
                 .add("varName", thisVector)
                 .add("size", size);
        programBody = programBody + "\n" + output.render();

        for (int i = 0; i < size; i++) {
            String num = ctx.INTEGER(i).getText();
            output = group.getInstanceOf("vecAssign")
                    .add("varName", thisVector)
                    .add("index", i+1)
                    .add("payload", num)
                    .add("tempVar1", this.getNextVar())
                    .add("tempVar2", this.getNextVar());
            programBody = programBody + "\n" + output.render();
        }


        output = group.getInstanceOf("declareVecVar")
                .add("varName", this.getNextVar());
        programBody = programBody + "\n" + output.render();
        output = group.getInstanceOf("swapVec")
                .add("var1", thisVector)
                .add("var2", this.getCurrentVar());
        programBody = programBody + "\n" + output.render();

		currentType = "vector";
        return "vector";
    }

    @Override
    public String visitConditional(VCalcParser.ConditionalContext ctx) {
        visit(ctx.expr());
        String ifVar = this.getCurrentVar();


        String label1 = getNextVar();
        String label2 = getNextVar();


        ST output = group.getInstanceOf("startIf")
                    .add("ifVar", ifVar)
                    .add("label1", label1)
                    .add("label2", label2)
                    .add("tempVar1", getNextVar())
                    .add("tempVar2", getNextVar());

        programBody = programBody + "\n" + output.render();

        scope = new LLVMScope(scope);
        for (VCalcParser.StatementContext stat: ctx.statement()) {
            visit(stat);
        }
        scope = scope.getParent();

        output = group.getInstanceOf("endIf")
                .add("label2", label2);
        programBody = programBody + "\n" + output.render();

        return null;
    }

    @Override
    public String visitLoop(VCalcParser.LoopContext ctx) {
        String label1 = getNextVar();

        String label2 = getNextVar();

        String label3 = getNextVar();

        ST output = group.getInstanceOf("initLoop")
                .add("label1", label1);
        programBody = programBody + "\n" + output.render();


        visit(ctx.expr());

        String loopVar = this.getCurrentVar();

        output = group.getInstanceOf("startLoop")
                .add("loopVar", loopVar)
                .add("label2", label2)
                .add("label3", label3)
                .add("tempVar1", getNextVar())
                .add("tempVar2", getNextVar());
        programBody = programBody + "\n" + output.render();

        scope = new LLVMScope(scope);
        for (VCalcParser.StatementContext stat: ctx.statement()) {
            visit(stat);
        }
        scope = scope.getParent();

        output = group.getInstanceOf("endLoop")
                .add("label3", label3)
                .add("label1", label1);
        programBody = programBody + "\n" + output.render();

        return null;
    }

    @Override
    public String visitExprIndex(VCalcParser.ExprIndexContext ctx) {
        visit(ctx.expr(0));
        String vecToIndex = getCurrentVar();
        String exprType = visit(ctx.expr(1));
        String indexExpr = getCurrentVar();

        if (exprType.equals("int")) {
            ST output = group.getInstanceOf("indexVectorWithInt");
            output.add("vector", vecToIndex);
            output.add("index", indexExpr);
            output.add("tempVar1", getNextVar());
            output.add("tempVar2", getNextVar());
            output.add("tempVar3", getNextVar());
            output.add("resultVar", getNextVar());
            programBody = programBody + "\n ; ++++++++++ " + output.render();
            return "int";
        } else {
            ST output = group.getInstanceOf("indexVectorWithVector");
            output.add("vector", vecToIndex);
            output.add("index", indexExpr);
            output.add("tempVar1", getNextVar());
            output.add("tempVar2", getNextVar());
            output.add("tempVar3", getNextVar());
            output.add("tempVar4", getNextVar());
            output.add("resultVar", getNextVar());
            programBody = programBody + "\n" + output.render();
            return "vector";
        }
    }


    public String visitGenerator(VCalcParser.GeneratorContext ctx) {
        String userDefinedName = ctx.ID().getText();
        String type = visit(ctx.expr(0));
        String loopVec = getCurrentVar();

        if (!userVarCounter.containsKey(userDefinedName)){
            userVarCounter.put(userDefinedName, 0);

        }

        String label1 = getNextVar();
        String label2 = getNextVar();
        String label3 = getNextVar();
        String label4 = getNextVar();
        String iter = getNextVar();
        String assignVec = getNextVar();

        scope = new LLVMScope(scope);

        scope.addToScope(userDefinedName, getLLVMVarName(scope, userDefinedName), "int");
        ST output = group.getInstanceOf("declareIntVar")
                    .add("varName", getCurrentForUserVar(scope, userDefinedName));
        programBody = programBody + "\n" + output.render();
        output = group.getInstanceOf("declareVecVar")
                .add("varName", getNextVar());
        programBody = programBody + "\n" + output.render();
        output = group.getInstanceOf("swapVec")
                .add("var1", loopVec)
                .add("var2", getCurrentVar());
        programBody = programBody + "\n" + output.render();

        output = group.getInstanceOf("startGeneratorLoop")
                .add("loopVec",loopVec)
                .add("label1",label1)
                .add("label2",label2)
                .add("label3",label3)
                .add("label4", label4)
                .add("iter",iter)
                .add("assignVec",assignVec)
                .add("tempVar7",getNextVar())
                .add("tempVar9",getNextVar())
                .add("tempVar10",getNextVar())
                .add("tempVar11",getNextVar())
                .add("tempVar12",getNextVar())
                .add("tempVar13",getNextVar())
                .add("tempVar14",getNextVar())
                .add("tempVar15",getNextVar());
        programBody = programBody + "\n" + output.render();

        visit(ctx.expr(1));

        output = group.getInstanceOf("endGeneratorLoop")
                .add("topOfStack",getCurrentVar())
                .add("label1",label1)
                .add("label3",label3)
                .add("label4",label4)
                .add("tempVar1",getNextVar())
                .add("tempVar2",getNextVar())
                .add("tempVar3",getNextVar())
                .add("tempVar4",getNextVar())
                .add("tempVar5",getNextVar())
                .add("tempVar6",getNextVar())
                .add("tempVar7",getNextVar())
                .add("tempVar8",getNextVar())
                .add("assignVec",assignVec)
                .add("iter",iter)
                .add("resultVar",getNextVar());
        programBody = programBody + "\n" + output.render();


        scope = scope.getParent();

        return "vector";
    }


    private String getCurrentVar() {
    	return "var" + varCounter.toString();
    }

    private String getNextVar() {
    	varCounter += 1;
    	return this.getCurrentVar();
    }

    private String getLLVMVarName(LLVMScope scope, String userDefinedName) {
        return "s" + scope.getScopeNumber(userDefinedName) + "var" + userDefinedName;
    }

    private String getCurrentForUserVar(LLVMScope scope, String userDefinedName) {
        return (getLLVMVarName(scope, userDefinedName) + scope.getVarCounter(userDefinedName).toString());
    }

    private String getNextForUserVar(LLVMScope scope, String userDefinedName) {
        scope.incrementVarCounter(userDefinedName);
    	return this.getCurrentForUserVar(scope, userDefinedName);
    }

    private void promoteVar(String varName, String vectorName) {
        ST output = group.getInstanceOf("promoteInt");
        output.add("intVar", varName);
        output.add("vectorVar", vectorName);
        output.add("tempVar1", getNextVar());
        output.add("tempVar2", getNextVar());
        output.add("tempVar3", getNextVar());
        output.add("tempVar4", getNextVar());
        output.add("resultVar", getNextVar());

        programBody = programBody + "\n" + output.render();
        return;
    }
}