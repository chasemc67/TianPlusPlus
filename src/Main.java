import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.io.FileInputStream;
import java.io.InputStream;
import org.stringtemplate.v4.*;

import java.io.*;

public class Main {
    public void writeToFile(String output){
        try {
            PrintWriter out = new PrintWriter(new FileWriter("debug.txt"));
            out.println(output);
            out.close();
        } catch(IOException e1) {
            System.out.println("Couldn't write to output");
        }
    }


    public static void main(String [] args) throws Exception {
        String inputFile = null;
        String interpreterType = null;
        // Is this the right argument?
        if (args.length > 0) inputFile = args[0];
        InputStream is = System.in;
        if (inputFile != null) is = new FileInputStream(inputFile);
        ANTLRInputStream input = new ANTLRInputStream(is);
        VCalcLexer lexer = new VCalcLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        VCalcParser parser = new VCalcParser(tokens);
        ParseTree tree = parser.prog();

        InterpreterVisitor eval = new InterpreterVisitor();
        eval.visit(tree);

        return;

    }
}