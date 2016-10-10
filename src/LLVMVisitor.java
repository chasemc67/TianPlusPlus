import java.util.HashMap;
import java.util.Map;

import org.antlr.v4.runtime.tree.TerminalNode;
import org.stringtemplate.v4.*;

public class LLVMVisitor extends VCalcBaseVisitor<Void> {

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


	@Override
	public Void visitProg(VCalcParser.ProgContext ctx) {
		// Have the children all write their subroutines to the program
		// body and variable declarations
		visitChildren(ctx);

		//Compile final program and print
		String output = beginProg + variableDeclarations + "\n" + initMain + programBody + "\n" + exitProgram;
		System.out.println(output);
		return null;
	}

	@Override
    public Void visitDeclAsn(VCalcParser.DeclAsnContext ctx) {
    	String userDefinedName = ctx.assignment().ID().getText();
        String llvmName = 

    	if (userVarCounter.containsKey(userDefinedName)){
    		System.out.println("Var has already been defined");
    	}

		if (ctx.type().getText().equals("int")) {
            scope.addToScope(userDefinedName, getLLVMVarName(userDefinedName), "int")
			userVarType.put(userDefinedName, "int");
			ST output = group.getInstanceOf("declareIntVar");
			ST output2 = output.add("varName", getCurrentForUserVar(scope, userDefinedName));
			programBody = programBody + "\n" + output.render();
		} else {
			scope.addToScope(userDefinedName, getLLVMVarName(userDefinedName), "vector")
			ST output = group.getInstanceOf("declareVecVar")
						.add("varName", getCurrentForUserVar(scope, userDefinedName));
			programBody = programBody + "\n" + output.render();
		}

    	visit(ctx.assignment());
    	return null;
    }

    @Override
    public Void visitDeclNoAsn(VCalcParser.DeclNoAsnContext ctx) {
    	String userDefinedName = ctx.ID().getText();

        if (userVarCounter.containsKey(userDefinedName)){
            System.out.println("Var has already been defined");
        }
        userVarCounter.put(userDefinedName, 0);

        if (ctx.type().getText().equals("int")) {
            scope.addToScope(userDefinedName, getLLVMVarName(userDefinedName), "int")
            ST output = group.getInstanceOf("declareIntVar");
            ST output2 = output.add("varName", getCurrentForUserVar(scope, userDefinedName));
            programBody = programBody + "\n" + output.render();
        } else {
            scope.addToScope(userDefinedName, getLLVMVarName(userDefinedName), "vector")
            ST output = group.getInstanceOf("declareVecVar")
                        .add("varName", getCurrentForUserVar(scope, userDefinedName));
            programBody = programBody + "\n" + output.render();
        }

    	return null;
    }

    @Override
    public Void visitAssignment(VCalcParser.AssignmentContext ctx) {
    	String userDefinedName = ctx.ID().getText();
    	visit(ctx.expr());
    	String exprResult = getCurrentVar();
		if (scope.getLLVMType(userDefinedName).equals("int")) {
			ST output = group.getInstanceOf("assignIntToVar");
			ST output2 = output.add("varName", getCurrentForUserVar(scope, userDefinedName));
			ST output3 = output.add("assignResult", exprResult);
			ST output4 = output.add("tempVar1", getNextVar());
			programBody = programBody + "\n" + output.render();
		} else {
            ST output = group.getInstanceOf("swapVec")
                    .add("var1", this.getCurrentForUserVar(scope, userDefinedName))
                    .add("var2", exprResult);
            programBody = programBody + "\n ;-------- \n" + output.render();
            currentType = "vector";
		}
    	return null;
    }

	@Override
	public Void visitPrint(VCalcParser.PrintContext ctx) {

	    // Get the value that we'll be printint out onto the stack
	    visit(ctx.expr());

        if (currentType.equals("int")) {
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
    public Void visitExprId(VCalcParser.ExprIdContext ctx) {
        String userDefinedName = ctx.ID().getText();

        ST output = group.getInstanceOf("writeIntIdToVar");
        ST output2 = output.add("varName", getCurrentForUserVar(scope, userDefinedName));
        ST output3 = output.add("tempVar1", getNextVar());
        ST output4 = output.add("resultVar", getNextVar());
        programBody = programBody + "\n" + output.render();
        return null;
    }

	@Override
	public Void visitExprInt(VCalcParser.ExprIntContext ctx) {
        System.out.println("; bro, im gonna print an int");
	    Integer intValue = Integer.valueOf(ctx.INTEGER().getText());
	    ST output = group.getInstanceOf("writeIntToStack");
	    ST output2 = output.add("varNumber", this.getNextVar());
	    ST output3 = output.add("intValue", intValue);
	    programBody = programBody + "\n" + output.render();
	    return null;
	}

	@Override
    public Void visitExprMulDiv(VCalcParser.ExprMulDivContext ctx) {
    	visit(ctx.expr(0));
    	String leftVar = this.getCurrentVar();
    	visit(ctx.expr(1));
    	String rightVar = this.getCurrentVar();

    	ST output;

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
    	return null;
    }


	@Override
    public Void visitExprAddSub(VCalcParser.ExprAddSubContext ctx) {
    	visit(ctx.expr(0));
    	String leftVar = this.getCurrentVar();
    	visit(ctx.expr(1));
    	String rightVar = this.getCurrentVar();

    	ST output;

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
    	return null;
    }

    @Override
	public Void visitExprGreatLess(VCalcParser.ExprGreatLessContext ctx) {
		visit(ctx.expr(0));
		String leftVar = this.getCurrentVar();
		visit(ctx.expr(1));
		String rightVar = this.getCurrentVar();

		ST output;

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
		return null;
	}



	@Override
	public Void visitExprEqual(VCalcParser.ExprEqualContext ctx) {
		visit(ctx.expr(0));
		String leftVar = this.getCurrentVar();
		visit(ctx.expr(1));
		String rightVar = this.getCurrentVar();

		ST output;

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
		return null;
	}

	@Override
    public Void visitExprVec(VCalcParser.ExprVecContext ctx) {
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
        programBody = programBody + "\n;!!!!!\n" + output.render();

		currentType = "vector";
        return null;
    }


    private String getCurrentVar() {
    	return "var" + varCounter.toString();
    }

    private String getNextVar() {
    	varCounter += 1;
    	return this.getCurrentVar();
    }

    private String getLLVMVarName(LLVMScope scope, String userDefinedName) {
        return "s" + scope.getScopeNumber() + "var" + userDefinedName;
    }

    private String getCurrentForUserVar(LLVMScope scope, String userDefinedName) {
        return (getLLVMVarName(scope, userDefinedName) + scope.getVarCounter(userDefinedName).toString());
    }

    private String getNextForUserVar(LLVMScope scope, String userDefinedName) {
        scope.incrementVarCounter(userDefinedName);
    	return this.getCurrentForUserVar(scope, userDefinedName);
    }
}