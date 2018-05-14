### Compiler for the Toy Language VCalc

VCalc was a toy language, which we implemented as an assignment before our Gazprea compiler in university.
It compiles down to three types of assembly language:  
* MIPS
* ARM
* x86

### Build Instructions

#### Prerequisits
Bash variable to be added to .bashrc XOR .bash_aliases:
```
export ANTLR4="/<PATH TO ANTLR JAR>/antlr-4.5-complete.jar"
export CLASSPATH="/<PATH TO ANTLR JAR>/antlr-4.5-complete.jar:$CLASSPATH"
```

#### Build Commands:
```
make:			Builds the project
make run:		Runs project takes argument
make test:		Runs test tools 
make clean:		Removes all generated and compiled files.
make submissible: 	Makes a subissible tar 
```


### Run Instructions
	The following shows how to run the project. It must be build first though.

#### Method 1: Makefile
```
<Build> /* (if not built) */
make run m=<mode> f=<file name>
```

#### Method 2: run using java
```
<Build> /* (if not built) */
java -cp "vcalc.jar:$ANTLR4" Main <mode> <file name>
```

### Files:
```
src/:		Source files for the project
makefile:	Build system for project
```
