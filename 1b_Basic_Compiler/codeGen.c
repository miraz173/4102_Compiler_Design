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
    // printf( "%3d: %-15s  %4d\n", code_offset, op_name[code[code_offset].op], code[code_offset].arg);
    code_offset++;
}

int print_code()
{
    // Open a file to write the assembly output
    FILE *file = fopen("intermediate.txt", "w");
    if (file == NULL)
    {
        fprintf(file, "Error: Could not open file for writing.\n");
        return -1;
    }
    int i = 0;

    fprintf(file, "============= INTERMEDIATE CODE===============\n");
    for (i = 0; i < code_offset; i++)
    {
        fprintf(file, "%3d: %-15s  %4d\n", i, op_name[code[i].op], code[i].arg);
    }
    return 0;
}

int print_assembly()
{
    int i = 0;
    int j = 0;

    int stack_variable_counter = 0;

    // Open a file to write the assembly output
    FILE *file = fopen("output.asm", "w");
    if (file == NULL)
    {
        fprintf(file, "Error: Could not open file for writing.\n");
        return -1;
    }
    fprintf(file, ";============= ASM CODE===============\n");

    for (i = 0; i < code_offset; i++)
    {
        fprintf(file, "\n;%s %d\n", op_name[code[i].op], code[i].arg);

        if (code[i].op == LD_INT || code[i].op == LD_VAR)
            stack_variable_counter++;

        if (code[i].op == ADDI || code[i].op == MULTI)
            stack_variable_counter--;

        switch (code[i].op)
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
            fprintf(file, "output_string_msg_format byte \"%%s %%d\", 0Ah, 0\n");
            fprintf(file, "input_integer_format byte \"%%d\",0\n");
            fprintf(file, "output_msg byte \"Result: \", 0\n");
            fprintf(file, "\n");
            fprintf(file, "number sdword ?\n");
            fprintf(file, "\n");
            fprintf(file, ".code\n");
            fprintf(file, "\n");
            fprintf(file, "main proc\n");
            fprintf(file, "\tpush ebp\n");
            fprintf(file, "\tmov ebp, esp\n");
            fprintf(file, "\tsub esp, 100\n");
            fprintf(file, "\n");
            break;

        case HALT:
            fprintf(file, "\tmov esp, ebp\n");
            fprintf(file, "\tpop ebp\n");
            fprintf(file, "\tret\n");
            fprintf(file, "main endp\n");
            fprintf(file, "end\n");
            break;

        case STORE: // gencode(store, address);address=var_number
            // fprintf(file, "\tmov eax, [ebx-4]\n");
            fprintf(file, "\tmov dword ptr [ebp-%d], eax\n", 4 + 4 * code[i].arg);
            break;

        case SCAN_INT_VALUE: // gencode(scan_int_val, address)
            fprintf(file, "\tINVOKE scanf, ADDR input_integer_format, eax\n");
            fprintf(file, "\tmov dword ptr [ebp-%d], eax\n", 4 + 4 * code[i].arg);
            break;

        case PRINT_INT_VALUE:
            fprintf(file, "\tmov eax, [ebp-%d]\n", 4 + 4 * code[i].arg);
            fprintf(file, "\tINVOKE printf, ADDR output_string_msg_format, ADDR output_msg, eax\n");
            break;

        case LD_VAR: // gencode(ld_var, address)
            fprintf(file, "\tmov eax, [ebp-%d]\n", 4 + 4 * code[i].arg);
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\n");
            break;

        case LD_INT:
            fprintf(file, "\tmov eax, %d\n", code[i].arg);
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\n");
            break;

        case ADDI:
            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tadd eax, edx\n");
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\n");
            break;

        case MULTI:
            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\timul eax, edx\n");
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\n");
            break;
            
        case GT_OP:
            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tcmp eax, edx\n");
            fprintf(file, "\tjle O_\n");
            fprintf(file, "\tmov eax, 1\n"); // a>b -> push 1
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\tjmp END_GT\n");
            fprintf(file, "O_:\n");
            fprintf(file, "\tmov eax, 0\n"); // a!>b -> push 0
            fprintf(file, "\tpush eax\n");
            fprintf(file, "END_GT:\n");
            fprintf(file, "\n");
            break;
        case LT_OP:
            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tcmp eax, edx\n");
            fprintf(file, "\tjge O_\n");
            fprintf(file, "\tmov eax, 1\n"); // a<b -> push 1
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\tjmp END_LT\n");
            fprintf(file, "O_:\n");
            fprintf(file, "\tmov eax, 0\n"); // a!<b -> push 0
            fprintf(file, "\tpush eax\n");
            fprintf(file, "END_LT:\n");
            fprintf(file, "\n");
            break;
        case IF_START:
            fprintf(file, "\tmov eax, [ebx-4]\n");
            fprintf(file, "\tcmp eax, 0\n");
            {
                char else_start_label[] = "ELSE_START_LABEL_";
                char number[10];
                printf(number, "%d", code[i].arg); // Store the formatted string in `number`
                strcat(else_start_label, number);
                fprintf(file, "\tjle %s\n", else_start_label);
            }
            fprintf(file, "\n");
            break;
        case ELSE_START:
        {
            char else_start_label[50] = "ELSE_START_LABEL_";
            char else_end_label[50] = "ELSE_END_LABEL_";
            char number[10];
            printf(number, "%d", code[i].arg); // Store the formatted string in `number`
            strcat(else_end_label, number);
            fprintf(file, "\tjmp %s\n", else_end_label);
            strcat(else_start_label, number);
            fprintf(file, "%s:\n", else_start_label);
        }
            fprintf(file, "\n");
            break;
        case ELSE_END:
        {
            char else_end_label[50] = "ELSE_END_LABEL_";
            char number[10];
            printf(number, "%d", code[i].arg);
            strcat(else_end_label, number);
            fprintf(file, "%s:\n", else_end_label);
        }
            fprintf(file, "\n");
            break;
        case WHILE_LABEL:
        {
            char while_start_label[] = "WHILE_START_LABEL_";
            char number[10];
            printf(number, "%d", code[i].arg); // Store the formatted string in `number`
            strcat(while_start_label, number);
            fprintf(file, "%s:\n", while_start_label);
        }
            fprintf(file, "\n");
            break;
        case WHILE_START:
            fprintf(file, "\tmov eax, [ebx-4]\n");
            fprintf(file, "\tcmp eax, 0\n");
            {
                char while_end_label[] = "WHILE_END_LABEL_";
                char number[10];
                char number_str[10];
                printf(number_str, "%d", code[i].arg);
                strcat(while_end_label, number_str);
                fprintf(file, "\tjle %s\n", while_end_label);
            }
            fprintf(file, "\n");
            break;
        case WHILE_END:
        {
            char while_start_label[50] = "WHILE_START_LABEL_";
            char while_end_label[50] = "WHILE_END_LABEL_";
            char number[10];
            printf(number, "%d", code[i].arg);
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
    return 0;
}