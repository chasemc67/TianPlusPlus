import java.util.ArrayList;
import java.util.List;

public class Stuff {

	public String type;
	public Integer intValue = null;
	public ArrayList<Integer> vectorValues = null;

	Stuff(Integer value) {
		type = "int";
		intValue = value;
		vectorValues = null;
	}

	Stuff(ArrayList<Integer> vector) {
		type = "vector";
		vectorValues = new ArrayList<Integer>(vector);
		intValue = null;
	}

	public void print() {
		if (type.equals("int")) {
			System.out.print(intValue);
		} else {
			System.out.print("[");
			for (int i = 0; i < vectorValues.size(); i++) {
				System.out.print(" ");
				System.out.print(vectorValues.get(i));
			}
			System.out.print(" ]");
		}
	}

}