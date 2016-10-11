import java.util.HashMap;
import java.util.Map;

/**
 * Created by TN on 2016-10-08.
 */
public class LLVMScope {

    private class LLVMvar {
        public String type;
        public String name;
        public Integer counter;
        public LLVMvar ( String name_, String type_) {
            type = type_;
            name = name_;
            counter = 0;
        }
    }

    Map<String, LLVMvar> vars = new HashMap<String, LLVMvar>();
    LLVMScope parent;
    int scopeNumber = 0;

    public LLVMScope() {
    }

    public LLVMScope(LLVMScope scope) {
        parent = scope;
        vars = new HashMap<String, LLVMvar>();
        scopeNumber++;
    }

    public LLVMScope getParent() {
        return parent;
    }

    public void addToScope(String name, String llvmName, String type) {
        LLVMvar var = new LLVMvar(llvmName, type);
        vars.put(name, var);
    }

    public boolean inCurrentScope(String name) {
        return vars.containsKey(name);
    }

    private LLVMvar resolveName(String name) {
       LLVMvar s = vars.get(name); // look in this scope
        if (s != null) return s; // return it if in this scope
        if ( parent != null ) { // have an enclosing scope?
            return parent.resolveName(name); // check enclosing scope
        }
        return null;
    }

    public String getLLVMName (String name) {
        LLVMvar tmp = resolveName(name);
        return tmp.name;
    }

    public String getLLVMType (String name) {
        LLVMvar tmp = resolveName(name);
        return tmp.type;
    }

    public Integer getScopeNumber(String name) {
        if(inCurrentScope(name)) {
            return scopeNumber;
        }
        if ( parent != null) {
            return parent.getScopeNumber(name);
        }
        return null;
    }

    public Integer getVarCounter(String name) {
        LLVMvar tmp = resolveName(name);
        return tmp.counter;
    }

    public void incrementVarCounter(String name) {
        LLVMvar s = vars.get(name); // look in this scope
        if (s != null) {
            s.counter++;
            vars.put(name, s);
        }
        if ( parent != null ) { // have an enclosing scope?
            parent.incrementVarCounter(name); // check enclosing scope
        }
    }


}