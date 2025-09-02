#include <stdio.h>
//#include"codegen.h" not needed as its contents have been moved here

enum code_ops
{
    START,
    HALT,
    LD_INT,
    LD_STR,
    LD_VAR,
    LD_STR_VAR,
    STORE,
    SCAN_INT_VALUE,
    SCAN_STR_VALUE,
    SCAN_CHAR_VALUE,
    PRINT_INT_VALUE,
    PRINT_REG_VALUE,
    PRINT_STR_VALUE,
    PRINT_NEW_LINE,
    ADDI,
    SUBS,
    MULTI,
    GT_OP,
    LT_OP,
    GE_OP,
    LE_OP,
    EQ_OP,
    IF_START,
    ELSE_START,
    ELSE_END,
    WHILE_LABEL,
    WHILE_START,
    WHILE_END,
    CHECK,
    DFLT,
    SKIP
};

char *op_name[] =
    {
        "start", "halt",
        "ld_int", "ld_str", "ld_var", "ld_str_var",
        "store",
        "scan_int_value", "scan_str_value", "scan_char_value",
        "print_int_value", "print_reg_value", "print_str_value", "print_new_line",
        "add", "sub", "mul", "gt", "lt", "ge", "le", "eq",
        "if_start", "else_start", "else_end",
        "while_label", "while_start", "while_end",
        "check", "default", "skip"};

struct instruction
{
    enum code_ops op;
    int arg;
};

struct instruction code[999];
extern int address;
extern int constStrNum;
extern char *strs[10];
int code_offset = 0;
int maxStringLen=16;

int gen_label()
{
    return code_offset;
}

void gen_code(enum code_ops op, int arg)//creates intermediate code
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
    char num[4];
    char str1[10];
    char str2[10];
    char else_end_label[30];
    char else_start_label[30];
    char while_end_label[30];
    char while_start_label[30];

    int i = 0;

    int constStrLoaded=0;
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
        fprintf(file, ";%3d: %s %d\n", i, op_name[code[i].op], code[i].arg);

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
            fprintf(file, ".stack 100h\n");//256 byte
            fprintf(file, "printf PROTO arg1:Ptr Byte, printlist:VARARG\n");
            fprintf(file, "scanf PROTO arg2:Ptr Byte, inputlist:VARARG\n");
            fprintf(file, "\n");
            fprintf(file, ".data\n");
            for (int in = 0; in < constStrNum; in++)
            {
                fprintf(file, "constStr%d db \"%s\", 0\n", in, strs[in]);
            }
            fprintf(file, "output_new_line byte 0Ah, 0\n");//0Ah =\n
            fprintf(file, "output_int_format byte \"%%d\", 0\n");//0Ah =\n
            fprintf(file, "output_str_format byte \"%%s\", 0\n");
            fprintf(file, "output_str_int_format byte \"%%s %%d\", 0Ah, 0\n");
            fprintf(file, "input_char_format byte \"%%c\", 0\n");
            fprintf(file, "input_str_format byte \"%%%ds\", 0\n", maxStringLen);
            fprintf(file, "input_int_format byte \"%%d\", 0\n");
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
            fprintf(file, "\txor eax, eax\n"); // returns 0;
            fprintf(file, "\tret\n");
            fprintf(file, "main endp\n");
            fprintf(file, "end\n");
            break;

        case STORE: // gencode(store, address);address=var_number
            fprintf(file, "\tmov dword ptr [ebp-%d], eax\n", 4 + 4 * code[i].arg);
            fprintf(file, "\n");
            break;

        case SCAN_INT_VALUE: // gencode(scan_int_val, address)
            fprintf(file, "\tINVOKE scanf, ADDR input_int_format, ADDR [ebp-%d]\n", 4 + 4 * code[i].arg);
            fprintf(file, "\tmov eax, [ebp-%d]\n", 4 + 4 * code[i].arg);
            fprintf(file, "\n");
            break;

        case SCAN_STR_VALUE: // gencode(scan_str_val, address) 3 character string input
            // fprintf(file, "\tINVOKE scanf, ADDR input_str_format, ADDR msg\n");//<--            fprintf(file, "\tINVOKE scanf, ADDR input_str_format, ADDR msg\n");//<--
            fprintf(file, "\tINVOKE scanf, ADDR input_str_format, ADDR [ebp-50+%d]\n", maxStringLen * code[i].arg);//<--
            fprintf(file, "\n");
            break;

        case SCAN_CHAR_VALUE: // gencode(scan_int_val, address) 1 character input
            fprintf(file, "\tlea eax, [ebp - %d]\n", 4 + 4 * code[i].arg);
            fprintf(file, "\tINVOKE scanf, ADDR input_char_format, eax\n");
            fprintf(file, "\tmov al, 0\n");
            fprintf(file, "\tmov byte ptr[ebp - %d], al\n", 5 + 4 * code[i].arg);
            fprintf(file, "\n");
            break;

        case PRINT_INT_VALUE:
            fprintf(file, "\tmov eax, [ebp-%d]\n", 4 + 4 * code[i].arg);
            fprintf(file, "\tINVOKE printf, ADDR output_int_format, ADDR msg, eax\n");
            fprintf(file, "\n");
            break;

        case PRINT_STR_VALUE:
            // fprintf(file, "\tlea eax, [ebp-50+%d]\n", maxStringLen * code[i].arg);
            fprintf(file, "\tINVOKE printf, ADDR output_str_format, eax\n");
            fprintf(file, "\n");
            break;

        case PRINT_REG_VALUE:
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tINVOKE printf, ADDR output_int_format, eax\n");
            fprintf(file, "\n");
            break;

        case PRINT_NEW_LINE:
            fprintf(file, "\tINVOKE printf, ADDR output_new_line, eax\n");
            fprintf(file, "\n");
            break;
        
        case LD_STR_VAR: // gencode(ld_str_var, address)
            fprintf(file, "\tlea eax, [ebp-50+%d]\n", maxStringLen * code[i].arg);
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\n");
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

        case LD_STR:
            fprintf(file, "\tlea edi, [ebp-50+%d]\n", maxStringLen*code[i].arg);// load address of desyination local buffer into edi    
            fprintf(file, "\tlea esi, constStr%d\n", constStrLoaded); //load address of source "string" into esi
            fprintf(file, "\tmov ecx, LENGTHOF constStr%d\n", constStrLoaded); //load lrngth of source "string" into ecx
            fprintf(file, "\trep movsb\n");    //copy string with rep movsb
            fprintf(file, "\n");
            constStrLoaded++;
            break;

        case ADDI:
            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tadd eax, edx\n");
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\n");
            break;

        case SUBS:
            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tsub eax, edx\n");
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

        case EQ_OP:
            strcpy(str1, "O_");
            strcpy(str2, "END_EQ_");
            sprintf(num, "%d", code[i].arg);
            strcat(str1, num);
            strcat(str2, num);

            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tcmp eax, edx\n");
            fprintf(file, "\tjne %s\n", str1); // jle 0_11
            fprintf(file, "\tmov eax, 1\n");   // a==b -> push 1
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\tjmp %s\n", str2); // jmp END_EQ_11
            fprintf(file, "%s:\n", str1);      // O_11:
            fprintf(file, "\tmov eax, 0\n");   // a!=b -> push 0
            fprintf(file, "\tpush eax\n");
            fprintf(file, "%s:\n", str2); // END_EQ_11:
            fprintf(file, "\n");
            break;

        case GT_OP:
            strcpy(str1, "O_");
            strcpy(str2, "END_GT_");
            sprintf(num, "%d", code[i].arg);
            strcat(str1, num);
            strcat(str2, num);

            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tcmp eax, edx\n");
            fprintf(file, "\tjle %s\n", str1); // jle 0_11
            fprintf(file, "\tmov eax, 1\n");   // a>b -> push 1
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\tjmp %s\n", str2); // jmp END_GT_11
            fprintf(file, "%s:\n", str1);      // O_11:
            fprintf(file, "\tmov eax, 0\n");   // a!>b -> push 0
            fprintf(file, "\tpush eax\n");
            fprintf(file, "%s:\n", str2); // END_GT_11:
            fprintf(file, "\n");
            break;

        case LT_OP:
            strcpy(str1, "O_");
            strcpy(str2, "END_LT_");
            sprintf(num, "%d", code[i].arg);
            strcat(str1, num);
            strcat(str2, num);

            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tcmp eax, edx\n");
            fprintf(file, "\tjge %s\n", str1);
            fprintf(file, "\tmov eax, 1\n"); // a<b -> push 1
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\tjmp %s\n", str2);
            fprintf(file, "%s:\n", str1);
            fprintf(file, "\tmov eax, 0\n"); // a!<b -> push 0
            fprintf(file, "\tpush eax\n");
            fprintf(file, "%s:\n", str2);
            fprintf(file, "\n");
            break;

        case GE_OP:
            strcpy(str1, "O_");
            strcpy(str2, "END_GE_");
            sprintf(num, "%d", code[i].arg);
            strcat(str1, num);
            strcat(str2, num);

            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tcmp eax, edx\n");
            fprintf(file, "\tjl %s\n", str1);
            fprintf(file, "\tmov eax, 1\n"); // a>=b -> push 1
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\tjmp %s\n", str2);
            fprintf(file, "%s:\n", str1);
            fprintf(file, "\tmov eax, 0\n"); // a!<b -> push 0
            fprintf(file, "\tpush eax\n");
            fprintf(file, "%s:\n", str2);
            fprintf(file, "\n");
            break;

        case LE_OP:
            strcpy(str1, "O_");
            strcpy(str2, "END_LE_");
            sprintf(num, "%d", code[i].arg);
            strcat(str1, num);
            strcat(str2, num);

            fprintf(file, "\tpop edx\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tcmp eax, edx\n");
            fprintf(file, "\tjg %s\n", str1);
            fprintf(file, "\tmov eax, 1\n"); // a<=b -> push 1
            fprintf(file, "\tpush eax\n");
            fprintf(file, "\tjmp %s\n", str2);
            fprintf(file, "%s:\n", str1);
            fprintf(file, "\tmov eax, 0\n"); // a!>b -> push 0
            fprintf(file, "\tpush eax\n");
            fprintf(file, "%s:\n", str2);
            fprintf(file, "\n");
            break;

        case CHECK:
            strcpy(else_start_label, "_END_");
            sprintf(num, "%d", code[i].arg); // Store the formatted string in `num`
            strcat(else_start_label, num);

            fprintf(file, "\tmov ebx, 1\n");
            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tcmp eax, 0\n");
            fprintf(file, "\tjle %s\n", else_start_label);
            fprintf(file, "\tmov ebx, 0\n");
            fprintf(file, "\n");
            break;

        case DFLT:
            strcpy(else_start_label, "_END_");
            sprintf(num, "%d", code[i].arg); // Store the formatted string in `num`
            strcat(else_start_label, num);

            fprintf(file, "\tmov eax, ebx\n");
            fprintf(file, "\tcmp eax, 0\n");
            fprintf(file, "\tjle %s\n", else_start_label);
            fprintf(file, "\n");
            break;

        case SKIP:
            strcpy(else_start_label, "_END_");
            sprintf(num, "%d", code[i].arg); // Store the formatted string in `num`
            strcat(else_start_label, num);

            fprintf(file, "%s:\n", else_start_label);
            break;

        case IF_START:
            strcpy(else_start_label, "ELSE_START_LABEL_");
            sprintf(num, "%d", code[i].arg); // Store the formatted string in `num`
            strcat(else_start_label, num);

            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tcmp eax, 0\n");
            fprintf(file, "\tjle %s\n", else_start_label);
            fprintf(file, "\n");
            break;

        case ELSE_START:
            strcpy(else_start_label, "ELSE_START_LABEL_");
            strcpy(else_end_label, "ELSE_END_LABEL_");
            sprintf(num, "%d", code[i].arg); // Store the formatted string in `num`
            strcat(else_end_label, num);
            strcat(else_start_label, num);

            fprintf(file, "\tjmp %s\n", else_end_label);
            fprintf(file, "%s:\n", else_start_label);
            fprintf(file, "\n");
            break;

        case ELSE_END:
            strcpy(else_end_label, "ELSE_END_LABEL_");
            sprintf(num, "%d", code[i].arg);
            strcat(else_end_label, num);

            fprintf(file, "%s:\n", else_end_label);
            fprintf(file, "\n");
            break;

        case WHILE_LABEL:
            strcpy(while_start_label, "WHILE_START_LABEL_");
            sprintf(num, "%d", code[i].arg); // Store the formatted string in `num`
            strcat(while_start_label, num);

            fprintf(file, "%s:\n", while_start_label);
            break;

        case WHILE_START:
            strcpy(while_end_label, "WHILE_END_LABEL_");
            sprintf(num, "%d", code[i].arg);
            strcat(while_end_label, num);

            fprintf(file, "\tpop eax\n");
            fprintf(file, "\tcmp eax, 0\n");
            fprintf(file, "\tjle %s\n", while_end_label);
            fprintf(file, "\n");
            break;

        case WHILE_END:
            strcpy(while_start_label, "WHILE_START_LABEL_");
            strcpy(while_end_label, "WHILE_END_LABEL_");
            sprintf(num, "%d", code[i].arg);
            strcat(while_start_label, num);
            strcat(while_end_label, num);

            fprintf(file, "\tjmp %s\n", while_start_label);
            fprintf(file, "%s:\n", while_end_label);
            fprintf(file, "\n");
            break;

        default:
            break;
        }
    }
    return 0;
}