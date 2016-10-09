import java.util.HashMap;
import java.util.Map;
import org.stringtemplate.v4.*;

public class LLVMVisitor extends VCalcBaseVisitor<Void> {
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


	@Override 
	public Void visitProg(VCalcParser.ProgContext ctx) {
		// Have the children all write their subroutines to the program
		// body and variable declarations
		visitChildren(ctx);

		//Compile final program and print
		String output = beginProg + variableDeclarations + "\n" + initMain + programBody + exitProgram;
		System.out.println(output);
		return null;
	}

	@Override
    public Void visitDeclAsn(VCalcParser.DeclAsnContext ctx) {
    	String userDefinedName = ctx.assignment.ID().getText();

    	ST output = group.getInstanceOf("declareIntVar");
    	ST output2 = output.add("varName", getCurrentForUserVar(scope, userDefinedName));
    	visit(ctx.assignment.expr());
    	return null;
    }

    @Override
    public Void visitDeclNoAsn(VCalcParser.DeclNoAsnContext ctx) {
    	String userDefinedName = ctx.ID().getText();
    	ST output = group.getInstanceOf("declareIntVar")
    	ST output2 = output.add("varName", getCurrentForUserVar(scope, userDefinedName));
    	return null;
    }

    @Override
    public Void visitAssignment(VCalcParser.AssignmentContext ctx) {
    	String userDefinedName = ctx.ID().getText();
    	ST output = group.getInstanceOf("assignIntToVar");
    	ST output2 = output.add("varName", getNextForUserVar(scope, userDefinedName));
    	ST output3 = output.add("assignResult", getCurrentVar());
    	ST output3 = output.add("tempVar1", getNextVar());
    	return null;
    }

	@Override
	public Void visitPrint(VCalcParser.PrintContext ctx) {
	    // Get the value that we'll be printint out onto the stack 
	    visit(ctx.expr());

	    // Will need to add some check here for whether we're
	    // printing an int or vec
	    ST output = group.getInstanceOf("printIntFromStack");
	    ST output2 = output.add("varNumberOfResult", this.getCurrentVar());
	    ST output3 = output.add("newVarNumber", this.getNextVar());
	    ST output4 = output.add("loaderVar", this.getNextVar());
	    programBody = programBody + "\n" + output.render();
	    return null;
	}

	@Override
	public Void visitExprInt(VCalcParser.ExprIntContext ctx) {
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


    private String getCurrentVar() {
    	return "t" + varCounter.toString();
    }

    private String getNextVar() {
    	varCounter += 1;
    	return this.getCurrentVar();
    }

    private String getNextForUserVar(scope, userDefinedName) {

    }

    private String getCurrentForUserVar(scope, userDefinedName) {

    }
}