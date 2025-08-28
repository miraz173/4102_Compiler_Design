# # For Windows; go to cmd and type "make main", then press Enter button.  
# input = input.txt
# output = output.asm

# main: compiler compile assemble run

# compiler:
# 	bison -d -Wcounterexamples parse.y 
# 	flex lex.l 
# 	gcc parse.tab.c lex.yy.c
# # a is the compiler program. Now, compile the codes in input.txt

# compile:
# 	a <$(input)

# # prog1.asm is the assembly version of input.txt code

# assemble:
# 	C:\masm32\bin\ml /c /coff /Cp prog1.asm
# 	C:\masm32\bin\link -entry:main /subsystem:console prog1.obj

# # prog1.exe is the executable version of input.txt code
# run:
# 	prog1

# # if avobe assembling doesn't work, then, comment avobe part and uncomment the line below
# # 	C:\masm32\bin\ml /c /coff /Cp prog1.asm && C:\masm32\bin\link -entry:main /subsystem:console prog1.obj && prog1


#for Linux; go to cmd and type "make main", then press Enter button.  
input = input.txt
output = output.asm

main: createCompiler compile assemble run finish

createCompiler:
	bison -d parse.y 
	flex new_lex.l 
	gcc parse.tab.c lex.yy.c -o compiler.out

compile:
	./compiler.out <$(input)

assemble:
	wine "C:\\masm32\\bin\\ml.exe" /c /coff /Cp output.asm 
	wine "C:\\masm32\\bin\\link.exe" -entry:main /subsystem:console output.obj

run:
	wine "output.exe"

finish:
	rm output.obj parse.tab.h parse.tab.c lex.yy.c 
