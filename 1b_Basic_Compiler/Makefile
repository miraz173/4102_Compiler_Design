#for Linux
input = input2.txt
output = output.asm

main: 
	bison -d parse.y 
	flex lex.l 
	gcc parse.tab.c lex.yy.c -o compiler.out
	./compiler.out <$(input)

assembler:
	wine "C:\\masm32\\bin\\ml.exe" /c /coff /Cp output.asm 
	wine "C:\\masm32\\bin\\link.exe" -entry:main /subsystem:console output.obj
	wine "output.exe"

finish:
	rm output.obj parse.tab.h parse.tab.c lex.yy.c 