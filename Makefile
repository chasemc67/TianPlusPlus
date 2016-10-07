#	ANTLR4 must be set as an exported variable 
#		
#			export ANTLR4="/<PATH TO ANTLR JAR>/antlr-4.5-complete.jar"
#			export CLASSPATH="/<PATH TO ANTLR JAR>/antlr-4.5-complete.jar:$CLASSPATH"
#
## Comands:
# all:					Builds everything to make a runable program
# run:					Runs The program builds if necessary
# clean: 				Cleans generated files
# submissible:	Builds a submission file
#
## Variables (DON'T TOUCH THESE. THEY WILL ONLY CHANGE ON YOUR COPY)
#	SRC:			The source folder
#	GEN:			The folder where generated antlr files will go
#	BIN:			The folder where the generated java class will go
#	JAR:			The name of the jar execuable will go
#	SUBFILES: The files for submisssion
#	INTELLIJ:	Files from INTELLIJ
SRC=src
GEN=gen
BIN=bin
TMP=tmp
JAR=vcalc.jar
TESTER=test_script
TESTFILES=TestFiles
SUBFILES=$(SRC) README
INTELLIJ=out

all: $(JAR)

run: $(JAR)
ifeq "$f" ""
	$(error "Usage: make run m=<mode> f=\"<filename>\"")
else ifeq "$m" ""
	$(error "Usage: make run m=<mode> f=\"<filename>\"")
endif
ifeq "$m"	"interpret"
	@java -cp "$(JAR):$(ANTLR4)" Main $m $f 
else
	@java -cp "$(JAR):$(ANTLR4)" Main $m $f > $(TMP).ll
endif

interpret: $(JAR)
ifeq "$f" ""	
	$(error "Usage: make interpret f=\"<filename>\"")
endif
	@java -cp "$(JAR):$(ANTLR4)" Main interpret $f 

llvm: $(JAR)
ifeq "$f" ""
	$(error "Usage: make llvm f=\"<filename>\"")
endif
	@java -cp "$(JAR):$(ANTLR4)" Main llvm $f > tmp.ll
	@lli tmp.ll

test: $(JAR)
	./$(TESTER) -a -s

test_verbos: $(JAR)
	./$(TESTER) -a

$(TESTFILES):
	@printf "Copying $(TESTFILES)...\t"
	@mkdir $(TESTFILES)
	-@cp -r ../../TestFiles/Current/Input $(TESTFILES)/Input
	-@cp -r ../../TestFiles/Current/Output $(TESTFILES)/Output
	@printf "Done\n"
	

clean:
ifneq "$(wildcard $(GEN))" ""
	@printf "Removing Generated files...\t"
	@-rm -rf $(GEN)
	@printf "Done\n"
endif
ifneq "$(wildcard $(BIN))" ""
	@printf "Removing Class files...\t\t"
	@-rm -rf $(BIN)
	@printf "Done\n"
endif
ifneq "$(wildcard $(JAR))" ""
	@printf "Removing Jar file...\t\t"
	@-rm -rf $(JAR) 
	@printf "Done\n"
endif
ifneq "$(wildcard *submission_*.tar.gz)" ""
	@printf "Removing submission file...\t"
	@-rm -rf *submission_*.tar.gz
	@printf "Done\n"
endif
ifneq "$(wildcard $(INTELLIJ))" ""
	@printf "Removing Intellij generated...\t"
	@-rm -rf $(INTELLIJ)
	@printf "Done\n"
endif
ifneq "$(wildcard $(TMP)*)" ""
	@printf "Removing temp file...\t\t"
	@-rm -rf $(TMP)*
	@printf "Done\n"
endif

submissible: 
ifneq "$(wildcard submission_*.tar.gz)" ""
	@printf "Removing submission file...\t"
	@-rm -rf submission_*.tar.gz
	@printf "Done\n"
endif
	@printf "This will create a submissible tar ball for you to submit\n"
	@printf "Enter your student CCID (the one you use to logon to beartracks).\n"
	@printf "Then hit [enter]: "
	@read -r -p "" NAME; \
	tar -zcvf submission_$$NAME.tar.gz $(SUBFILES);
	@printf "\nSubmissible ready\n"

submissible_testfiles:
ifneq "$(wildcard test_files_submission_*.tar.gz)" ""
	@printf "Removing test files submission file...\t"
	@-rm -rf test_files_submission_*.tar.gz
	@printf "Done\n"
endif
	@printf "This will create a submissible tar ball for you to submit\n"
	@printf "Enter your student CCID (the one you use to logon to beartracks).\n"
	@printf "Then hit [enter]: "
	@read -r -p "" NAME; \
	tar -zcvf test_files_submission_$$NAME.tar.gz $(TESTFILES);
	@printf "\nSubmissible ready\n"


$(GEN): $(SRC)/*.g4
	 @printf "Generating Antlr4 files..."
	 @java -cp "$(ANTLR4)" org.antlr.v4.Tool $(SRC)/*.g4 -o $(GEN)/ \
	 -listener -visitor
	 @mv $(GEN)/src/* $(GEN)/
	 @rmdir $(GEN)/src/
	 @touch $(GEN)
	 @printf "\tDone\n"

$(JAR): $(GEN) $(BIN)
	@printf "Building Jar file..."
	@jar cfe $(JAR) Main -C $(BIN)/ .
	@printf "\t\tDone\n"

$(BIN): $(GEN) $(SRC)/*.java
	@printf "Building class files..."
	@mkdir -p $(BIN) 
	@javac -cp "$(ANTLR4)" -d "$(BIN)" $(GEN)/*.java $(SRC)/*.java
	@touch $(BIN)
	@printf "\t\tDone\n"
