import java.util.HashMap;
import java.util.Map;

/**
 * Created by TN on 2016-10-08.
 */
public class Scope {

    Map<String, Stuff> vars = new HashMap<String, Stuff>();
    Scope parent;

    public Scope() {
    }

    public Scope(Scope scope) {
        parent = scope;
        vars = new HashMap<String, Stuff>();
    }

    public Scope getParent() {
        return parent;
    }

    public void addToScope(String name, Stuff payload) {
        vars.put(name, payload);
    }

    public void assign(String name, Stuff payload) {
        if(resolve(name) != null) {
            if(vars.containsKey(name)) { //Var in this scope
                vars.put(name, payload);
            }
            else if(parent != null) {
                parent.assign(name, payload);
            }
        }
    }

    public boolean inCurrentScope(String name) {
        return vars.containsKey(name);
    }

    public Stuff resolve(String name) {
        Stuff s = vars.get(name); // look in this scope
        if (s != null) return s; // return it if in this scope
        if ( parent != null ) { // have an enclosing scope?
            return parent.resolve(name); // check enclosing scope
        }
        return null;
    }
}