enum code_ops
{
    START,
    HALT,
    LD_INT,
    LD_VAR,
    STORE,
    SCAN_INT_VALUE,
    PRINT_INT_VALUE,
    ADDI,
    MULTI,
    GT_OP,
    LT_OP,
    IF_START,
    ELSE_START,
    ELSE_END,
    WHILE_LABEL,
    WHILE_START,
    WHILE_END
};
// enum code_ops {MAKE, FUNC, MAIN, FBegin, FEnd, VISIBLE, DESIGN, INT, CALC, MUL, SEMI, ASSIGN, TO};

char *op_name[] =
// { "make", "func", "main", "func_begin", "func_end", "visible", "design", "intvar", "calc", "*", ";", "=", "to"};

 {"start", "halt", "ld_int", "ld_var", "store", "scan_int_value", "print_int_value", "add", "mul", "gt", "lt", "if_start", "else_start", "else_end", "while_label", "while_start", "while_end"};

struct instruction
{
    enum code_ops op;
    int arg;
};

struct instruction code[999];
extern int address;
int code_offset = 0;

// char if_label[]="IF_LABEL";
// char else_label[]="ELSE_LABEL";

// typedef struct if_while
// {
//     int label;
// }if_while;

// if_while *new_if_while()
// {
//     return (if_while*) malloc (sizeof(if_while));
// }
/*
#include "codeGen.h"
#include <stdio.h>

int gen_label()
{
    return code_offset;
}

void gen_code(enum code_ops op, int arg)
{
    code[code_offset].op = op;
    code[code_offset].arg = arg;
    printf( "%3d: %-15s  %4d\n", code_offset, op_name[code[code_offset].op], code[code_offset].arg);
    code_offset++;
}

void print_code()
{
    int i = 0;

    for(i=0; i<code_offset; i++)
    {
        printf("%3d: %-15s  %4d\n", i, op_name[code[i].op], code[i].arg);
    }
}

void print_assembly()
{
    int i = 0;
    int j = 0;

    int stack_variable_counter = 0;

    // Open a file to write the assembly output
    FILE *file = fopen("assembly_output.asm", "w");
    if (file == NULL) {
        fprintf(file, "Error: Could not open file for writing.\n");
        return;
    }

    for(i=0; i<code_offset; i++)
    {
        fprintf(file, "\n;%s %d\n", op_name[code[i].op], code[i].arg);

        if(code[i].op == LD_INT || code[i].op == LD_VAR)
            stack_variable_counter++;
        
        if(code[i].op == ADD)
            stack_variable_counter--;

        switch(code[i].op)
        {
            case START:
                            fprintf(file, ".686\n");
                            fprintf(file, ".model flat, c\n");
                            fprintf(file, "include C:\\masm32\\include\\msvcrt.inc\n");
                            fprintf(file, "includelib C:\\masm32\\lib\\msvcrt.lib\n");                            
                            fprintf(file, "\n");
                            fprintf(file, ".stack 100h\n");
                            fprintf(file, "printf PROTO arg1:Ptr Byte, printlist:VARARG\n");
                            fprintf(file, "scanf PROTO arg2:Ptr Byte, inputlist:VARARG\n");
                            fprintf(file, "\n");
                            fprintf(file, ".data\n");
                            fprintf(file, "output_integer_msg_format byte \"%%d\", 0Ah, 0\n");
                            fprintf(file, "output_string_msg_format byte \"%%s\", 0Ah, 0\n");
                            fprintf(file, "input_integer_format byte \"%%d\",0\n");
                            fprintf(file, "output_msg byte \"Result: \",0Ah, 0\n");
                            fprintf(file, "\n");
                            fprintf(file, "number sdword ?\n");
                            fprintf(file, "\n");
                            fprintf(file, ".code\n");
                            fprintf(file, "\n");
                            fprintf(file, "main proc\n");
                            fprintf(file, "\tpush ebp\n");
                            fprintf(file, "\tmov ebp, esp\n");
                            fprintf(file, "\tsub ebp, 100\n");
                            fprintf(file, "\tmov ebx, ebp\n");
                            fprintf(file, "\tadd ebx, 4\n");
                            break;

            case HALT:
                            fprintf(file, "\tadd ebp, 100\n");
                            fprintf(file, "\tmov esp, ebp\n");
                            fprintf(file, "\tpop ebp\n");
                            fprintf(file, "\tret\n");
                            fprintf(file, "main endp\n");
                            fprintf(file, "end\n");
                            break;

            case STORE:
                            fprintf(file, "\tmov eax, [ebx-4]\n");
                            fprintf(file, "\tmov dword ptr [ebp-%d], eax\n", 4*code[i].arg);
                            break;

            case SCAN_INT_VALUE:                                
                            fprintf(file, "\tpush eax\n");
                            fprintf(file, "\tpush ebx\n");
                            fprintf(file, "\tpush ecx\n");
                            fprintf(file, "\tpush edx\n");
                            for(j=address-1; j>=0; j--)
                                fprintf(file, "\tpush [ebp-%d]\n", 4*j);
                            for(j=1; j<=stack_variable_counter; j++)
                                fprintf(file, "\tpush [ebp+%d]\n", 4*j);
                            fprintf(file, "\tpush ebp\n");
                            
                            fprintf(file, "\tINVOKE scanf, ADDR input_integer_format, ADDR number\n");

                            fprintf(file, "\tpop ebp\n");
                            for(j=stack_variable_counter; j>=1; j--)
                                fprintf(file, "\tpop [ebp+%d]\n", 4*j);
                            for(j=0; j<=address-1; j++)
                                fprintf(file, "\tpop [ebp-%d]\n", 4*j);

                            fprintf(file, "\tmov eax, number\n");
                            fprintf(file, "\tmov dword ptr [ebp-%d], eax\n", 4*code[i].arg);

                            fprintf(file, "\tpop edx\n");
                            fprintf(file, "\tpop ecx\n");
                            fprintf(file, "\tpop ebx\n");
                            fprintf(file, "\tpop eax\n");
                            break;


            case PRINT_INT_VALUE:              
                            fprintf(file, "\tpush eax\n");
                            fprintf(file, "\tpush ebx\n");
                            fprintf(file, "\tpush ecx\n");
                            fprintf(file, "\tpush edx\n");
                            for(j=address-1; j>=0; j--)
                                fprintf(file, "\tpush [ebp-%d]\n", 4*j);
                            for(j=1; j<=stack_variable_counter; j++)
                                fprintf(file, "\tpush [ebp+%d]\n", 4*j);
                            fprintf(file, "\tpush ebp\n");

                            fprintf(file, "\tmov eax, [ebp-%d]\n", 4 * code[i].arg);
                            fprintf(file, "\tINVOKE printf, ADDR output_string_msg_format, output_msg\n");
                            fprintf(file, "\tINVOKE printf, ADDR output_integer_msg_format, eax\n");

                            fprintf(file, "\tpop ebp\n");
                            for(j=stack_variable_counter; j>=1; j--)
                                fprintf(file, "\tpop [ebp+%d]\n", 4*j);
                            for(j=0; j<=address-1; j++)
                                fprintf(file, "\tpop [ebp-%d]\n", 4*j);
                            fprintf(file, "\tpop edx\n");
                            fprintf(file, "\tpop ecx\n");
                            fprintf(file, "\tpop ebx\n");
                            fprintf(file, "\tpop eax\n");
                            break;

            case LD_VAR: 
                            fprintf(file, "\tmov eax, [ebp-%d]\n", 4*code[i].arg);
                            fprintf(file, "\tmov dword ptr [ebx], eax\n");
                            fprintf(file, "\tadd ebx, 4\n");
                            fprintf(file, "\n");
                            break;

            case LD_INT:
                            fprintf(file, "\tmov eax, %d\n", code[i].arg);
                            fprintf(file, "\tmov dword ptr [ebx], eax\n");
                            fprintf(file, "\tadd ebx, 4\n");
                            fprintf(file, "\n");
                            break;

            case ADD:
                            fprintf(file, "\tsub ebx, 4\n");
                            fprintf(file, "\tmov eax, [ebx]\n");
                            fprintf(file, "\tsub ebx, 4\n");
                            fprintf(file, "\tmov edx, [ebx]\n");
                            fprintf(file, "\tadd eax, edx\n");
                            fprintf(file, "\tmov dword ptr [ebx], eax\n");
                            fprintf(file, "\tadd ebx, 4\n");
                            fprintf(file, "\n");
                            break;

            case MULTI:
                            fprintf(file, "\tsub ebx, 4\n");
                            fprintf(file, "\tmov eax, [ebx]\n");
                            fprintf(file, "\tsub ebx, 4\n");
                            fprintf(file, "\tmov edx, [ebx]\n");
                            fprintf(file, "\tmul eax, edx\n");
                            fprintf(file, "\tmov dword ptr [ebx], eax\n");
                            fprintf(file, "\tadd ebx, 4\n");
                            fprintf(file, "\n");
                            break;
            case GT_OP:
                            fprintf(file, "\tsub ebx, 4\n");
                            fprintf(file, "\tmov eax, [ebx]\n");
                            fprintf(file, "\tsub ebx, 4\n");
                            fprintf(file, "\tmov edx, [ebx]\n");
                            fprintf(file, "\tcmp edx, eax\n");

                            {
                                char relop_start_label[50]="LS";
                                char relop_end_label[50]="LE";
                                char number[10];
                                sprintf(number, "%d", code[i].arg); // Store the formatted string in `number`
                                strcat(relop_end_label, number);
                                strcat(relop_start_label, number);

                                fprintf(file, "\tjg %s\n", relop_start_label);
                                fprintf(file, "\tmov dword ptr [ebx], 0\n");
                                fprintf(file, "\tjmp %s\n", relop_end_label);
                                fprintf(file, "\t%s: mov dword ptr [ebx], 1\n", relop_start_label);
                                fprintf(file, "\t%s: add ebx, 4\n\n", relop_end_label);
                            }
                            fprintf(file, "\n");
                            break;
            case LT_OP:
                            fprintf(file, "\tsub ebx, 4\n");
                            fprintf(file, "\tmov eax, [ebx]\n");
                            fprintf(file, "\tsub ebx, 4\n");
                            fprintf(file, "\tmov edx, [ebx]\n");
                            fprintf(file, "\tcmp edx, eax\n");

                            {
                                char relop_start_label[50]="LS";
                                char relop_end_label[50]="LE";
                                char number[10];
                                printf( number, "%d", code[i].arg); // Store the formatted string in `number`
                                strcat(relop_end_label, number);
                                strcat(relop_start_label, number);

                                fprintf(file, "\tjl %s\n", relop_start_label);
                                fprintf(file, "\tmov dword ptr [ebx], 0\n");
                                fprintf(file, "\tjmp %s\n", relop_end_label);
                                fprintf(file, "\t%s: mov dword ptr [ebx], 1\n", relop_start_label);
                                fprintf(file, "\t%s: add ebx, 4\n\n", relop_end_label);
                            }
                            fprintf(file, "\n");
                            break;
            case IF_START:
                            fprintf(file, "\tmov eax, [ebx-4]\n");
                            fprintf(file, "\tcmp eax, 0\n");
                            {
                                char else_start_label[]="ELSE_START_LABEL_";
                                char number[10];
                                printf( number, "%d", code[i].arg); // Store the formatted string in `number`
                                strcat(else_start_label, number);
                                fprintf(file, "\tjle %s\n", else_start_label);
                            }
                            fprintf(file, "\n");
                            break;
            case ELSE_START:
                            {
                                char else_start_label[50]="ELSE_START_LABEL_";
                                char else_end_label[50]="ELSE_END_LABEL_";
                                char number[10];
                                printf( number, "%d", code[i].arg); // Store the formatted string in `number`
                                strcat(else_end_label, number);
                                fprintf(file, "\tjmp %s\n", else_end_label);
                                strcat(else_start_label, number);
                                fprintf(file, "%s:\n", else_start_label);
                            }
                            fprintf(file, "\n");
                            break;
            case ELSE_END:
                            {
                                char else_end_label[50]="ELSE_END_LABEL_";
                                char number[10];
                                printf( number, "%d", code[i].arg);
                                strcat(else_end_label, number);
                                fprintf(file, "%s:\n", else_end_label);
                            }
                            fprintf(file, "\n");
                            break;
            case WHILE_LABEL:
                            {
                                char while_start_label[]="WHILE_START_LABEL_";
                                char number[10];
                                printf( number, "%d", code[i].arg); // Store the formatted string in `number`
                                strcat(while_start_label, number);
                                fprintf(file, "%s:\n", while_start_label);
                            }
                            fprintf(file, "\n");
                            break;
            case WHILE_START:
                            fprintf(file, "\tmov eax, [ebx-4]\n");
                            fprintf(file, "\tcmp eax, 0\n");
                            {
                                char while_end_label[]="WHILE_END_LABEL_";
                                char number[10];char number_str[10];
                                printf( number_str, "%d", code[i].arg);
                                strcat(while_end_label, number_str);
                                fprintf(file, "\tjle %s\n", while_end_label);
                            }
                            fprintf(file, "\n");
                            break;
            case WHILE_END:
                            {
                                char while_start_label[50]="WHILE_START_LABEL_";
                                char while_end_label[50]="WHILE_END_LABEL_";
                                char number[10];
                                printf( number, "%d", code[i].arg);
                                strcat(while_start_label, number);
                                fprintf(file, "\tjmp %s\n", while_start_label);
                                strcat(while_end_label, number);
                                fprintf(file, "%s:\n", while_end_label);
                            }
                            fprintf(file, "\n");
                            break;
            default:
                            break;
        }

    }
} */