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
	public Void visitPrint(VCalcParser.PrintContext ctx) {
	    // Get the value that we'll be printint out onto the stack 
	    visit(ctx.expr());

	    // Will need to add some check here for whether we're
	    // printing an int or vec
	    ST output = group.getInstanceOf("printIntFromStack");
	    ST output2 = output.add("varNumberOfResult", "t" + varCounter.toString());
	    varCounter += 1;
	    ST output3 = output.add("newVarNumber", "t" + varCounter.toString());
	    varCounter += 1;
	    ST output4 = output.add("loaderVar", "t" + varCounter.toString());
	    programBody = programBody + "\n" + output.render();
	    return null;
	}

	@Override
	public Void visitExprInt(VCalcParser.ExprIntContext ctx) {
	    Integer intValue = Integer.valueOf(ctx.INTEGER().getText());
	    varCounter += 1;
	    ST output = group.getInstanceOf("writeIntToStack");
	    ST output2 = output.add("varNumber", "t" + varCounter.toString());
	    ST output3 = output.add("intValue", intValue);
	    programBody = programBody + "\n" + output.render();
	    return null;
	}

}