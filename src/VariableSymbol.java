/**
 * Created by TN on 2016-10-07.
 */
public class VariableSymbol extends Symbol implements Type {
    public String name;

    public VariableSymbol(String name_) {
        name = name_;

    }

    public String getName() {
        return "Integer";
    };
}
