;============= ASM CODE===============
;  0: start -1
.686
.model flat, c
include C:\masm32\include\msvcrt.inc
includelib C:\masm32\lib\msvcrt.lib

.stack 100h
printf PROTO arg1:Ptr Byte, printlist:VARARG
scanf PROTO arg2:Ptr Byte, inputlist:VARARG

.data
constStr0 db "Input: ", 0
constStr1 db "Triangle Size:", 0
constStr2 db " ", 0
constStr3 db "^", 0
constStr4 db ": ", 0
constStr5 db "String Input: ", 0
constStr6 db "Input was: ", 0
constStr7 db "Bigger than five. ", 0
constStr8 db "Smaller than five. ", 0
output_new_line byte 0Ah, 0
output_int_format byte "%d", 0
output_str_format byte "%s", 0
output_str_int_format byte "%s %d", 0Ah, 0
input_char_format byte "%c", 0
input_str_format byte "%16s", 0
input_int_format byte "%d", 0

.code

main proc
	push ebp
	mov ebp, esp
	sub esp, 100

;  1: ld_str 0
	lea edi, [ebp-50+0]
	lea esi, constStr0
	mov ecx, LENGTHOF constStr0
	rep movsb

;  2: ld_str 1
	lea edi, [ebp-50+16]
	lea esi, constStr1
	mov ecx, LENGTHOF constStr1
	rep movsb

;  3: ld_str_var 0
	lea eax, [ebp-50+0]
	push eax

;  4: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

;  5: scan_int_value 0
	INVOKE scanf, ADDR input_int_format, ADDR [ebp-4]
	mov eax, [ebp-4]

;  6: ld_str_var 1
	lea eax, [ebp-50+16]
	push eax

;  7: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

;  8: ld_var 0
	mov eax, [ebp-4]
	push eax

;  9: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_int_format, eax

; 10: print_new_line -1
	INVOKE printf, ADDR output_new_line, eax

; 11: ld_str 0
	lea edi, [ebp-50+0]
	lea esi, constStr2
	mov ecx, LENGTHOF constStr2
	rep movsb

; 12: ld_str 1
	lea edi, [ebp-50+16]
	lea esi, constStr3
	mov ecx, LENGTHOF constStr3
	rep movsb

; 13: ld_int 0
	mov eax, 0
	push eax

; 14: store 1
	mov dword ptr [ebp-8], eax

; 15: while_label 1
WHILE_START_LABEL_1:
; 16: ld_var 1
	mov eax, [ebp-8]
	push eax

; 17: ld_var 0
	mov eax, [ebp-4]
	push eax

; 18: lt 19
	pop edx
	pop eax
	cmp eax, edx
	jge O_19
	mov eax, 1
	push eax
	jmp END_LT_19
O_19:
	mov eax, 0
	push eax
END_LT_19:

; 19: while_start 1
	pop eax
	cmp eax, 0
	jle WHILE_END_LABEL_1

; 20: ld_var 1
	mov eax, [ebp-8]
	push eax

; 21: ld_int 1
	mov eax, 1
	push eax

; 22: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

; 23: store 1
	mov dword ptr [ebp-8], eax

; 24: ld_int 0
	mov eax, 0
	push eax

; 25: store 2
	mov dword ptr [ebp-12], eax

; 26: while_label 2
WHILE_START_LABEL_2:
; 27: ld_var 2
	mov eax, [ebp-12]
	push eax

; 28: ld_var 0
	mov eax, [ebp-4]
	push eax

; 29: ld_var 1
	mov eax, [ebp-8]
	push eax

; 30: sub -1
	pop edx
	pop eax
	sub eax, edx
	push eax

; 31: lt 20
	pop edx
	pop eax
	cmp eax, edx
	jge O_20
	mov eax, 1
	push eax
	jmp END_LT_20
O_20:
	mov eax, 0
	push eax
END_LT_20:

; 32: while_start 2
	pop eax
	cmp eax, 0
	jle WHILE_END_LABEL_2

; 33: ld_var 2
	mov eax, [ebp-12]
	push eax

; 34: ld_int 1
	mov eax, 1
	push eax

; 35: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

; 36: store 2
	mov dword ptr [ebp-12], eax

; 37: ld_str_var 0
	lea eax, [ebp-50+0]
	push eax

; 38: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

; 39: while_end 2
	jmp WHILE_START_LABEL_2
WHILE_END_LABEL_2:

; 40: ld_int 0
	mov eax, 0
	push eax

; 41: store 2
	mov dword ptr [ebp-12], eax

; 42: while_label 3
WHILE_START_LABEL_3:
; 43: ld_var 2
	mov eax, [ebp-12]
	push eax

; 44: ld_int 2
	mov eax, 2
	push eax

; 45: ld_var 1
	mov eax, [ebp-8]
	push eax

; 46: mul -1
	pop edx
	pop eax
	imul eax, edx
	push eax

; 47: ld_int 1
	mov eax, 1
	push eax

; 48: sub -1
	pop edx
	pop eax
	sub eax, edx
	push eax

; 49: lt 24
	pop edx
	pop eax
	cmp eax, edx
	jge O_24
	mov eax, 1
	push eax
	jmp END_LT_24
O_24:
	mov eax, 0
	push eax
END_LT_24:

; 50: while_start 3
	pop eax
	cmp eax, 0
	jle WHILE_END_LABEL_3

; 51: ld_var 2
	mov eax, [ebp-12]
	push eax

; 52: ld_int 1
	mov eax, 1
	push eax

; 53: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

; 54: store 2
	mov dword ptr [ebp-12], eax

; 55: ld_str_var 1
	lea eax, [ebp-50+16]
	push eax

; 56: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

; 57: while_end 3
	jmp WHILE_START_LABEL_3
WHILE_END_LABEL_3:

; 58: print_new_line -1
	INVOKE printf, ADDR output_new_line, eax

; 59: while_end 1
	jmp WHILE_START_LABEL_1
WHILE_END_LABEL_1:

; 60: ld_str 1
	lea edi, [ebp-50+16]
	lea esi, constStr4
	mov ecx, LENGTHOF constStr4
	rep movsb

; 61: ld_int 0
	mov eax, 0
	push eax

; 62: store 1
	mov dword ptr [ebp-8], eax

; 63: while_label 4
WHILE_START_LABEL_4:
; 64: ld_var 1
	mov eax, [ebp-8]
	push eax

; 65: ld_int 7
	mov eax, 7
	push eax

; 66: lt 33
	pop edx
	pop eax
	cmp eax, edx
	jge O_33
	mov eax, 1
	push eax
	jmp END_LT_33
O_33:
	mov eax, 0
	push eax
END_LT_33:

; 67: while_start 4
	pop eax
	cmp eax, 0
	jle WHILE_END_LABEL_4

; 68: ld_var 1
	mov eax, [ebp-8]
	push eax

; 69: ld_int 2
	mov eax, 2
	push eax

; 70: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

; 71: store 1
	mov dword ptr [ebp-8], eax

; 72: ld_var 1
	mov eax, [ebp-8]
	push eax

; 73: ld_int 2
	mov eax, 2
	push eax

; 74: sub -1
	pop edx
	pop eax
	sub eax, edx
	push eax

; 75: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_int_format, eax

; 76: ld_str_var 1
	lea eax, [ebp-50+16]
	push eax

; 77: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

; 78: ld_int 0
	mov eax, 0
	push eax

; 79: store 2
	mov dword ptr [ebp-12], eax

; 80: while_label 5
WHILE_START_LABEL_5:
; 81: ld_var 2
	mov eax, [ebp-12]
	push eax

; 82: ld_int 9
	mov eax, 9
	push eax

; 83: ld_var 1
	mov eax, [ebp-8]
	push eax

; 84: sub -1
	pop edx
	pop eax
	sub eax, edx
	push eax

; 85: lt 36
	pop edx
	pop eax
	cmp eax, edx
	jge O_36
	mov eax, 1
	push eax
	jmp END_LT_36
O_36:
	mov eax, 0
	push eax
END_LT_36:

; 86: while_start 5
	pop eax
	cmp eax, 0
	jle WHILE_END_LABEL_5

; 87: ld_var 2
	mov eax, [ebp-12]
	push eax

; 88: ld_int 1
	mov eax, 1
	push eax

; 89: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

; 90: store 2
	mov dword ptr [ebp-12], eax

; 91: ld_var 2
	mov eax, [ebp-12]
	push eax

; 92: ld_int 1
	mov eax, 1
	push eax

; 93: sub -1
	pop edx
	pop eax
	sub eax, edx
	push eax

; 94: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_int_format, eax

; 95: ld_str_var 0
	lea eax, [ebp-50+0]
	push eax

; 96: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

; 97: while_end 5
	jmp WHILE_START_LABEL_5
WHILE_END_LABEL_5:

; 98: print_new_line -1
	INVOKE printf, ADDR output_new_line, eax

; 99: while_end 4
	jmp WHILE_START_LABEL_4
WHILE_END_LABEL_4:

;100: print_new_line -1
	INVOKE printf, ADDR output_new_line, eax

;101: ld_int 6
	mov eax, 6
	push eax

;102: store 1
	mov dword ptr [ebp-8], eax

;103: ld_str 1
	lea edi, [ebp-50+16]
	lea esi, constStr5
	mov ecx, LENGTHOF constStr5
	rep movsb

;104: ld_str_var 1
	lea eax, [ebp-50+16]
	push eax

;105: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

;106: scan_str_value 2
	INVOKE scanf, ADDR input_str_format, ADDR [ebp-50+32]

;107: ld_str 1
	lea edi, [ebp-50+16]
	lea esi, constStr6
	mov ecx, LENGTHOF constStr6
	rep movsb

;108: ld_str_var 1
	lea eax, [ebp-50+16]
	push eax

;109: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

;110: ld_str_var 2
	lea eax, [ebp-50+32]
	push eax

;111: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

;112: print_new_line -1
	INVOKE printf, ADDR output_new_line, eax

;113: scan_int_value 0
	INVOKE scanf, ADDR input_int_format, ADDR [ebp-4]
	mov eax, [ebp-4]

;114: ld_var 0
	mov eax, [ebp-4]
	push eax

;115: ld_int 5
	mov eax, 5
	push eax

;116: gt 59
	pop edx
	pop eax
	cmp eax, edx
	jle O_59
	mov eax, 1
	push eax
	jmp END_GT_59
O_59:
	mov eax, 0
	push eax
END_GT_59:

;117: check 6
	mov ebx, 1
	pop eax
	cmp eax, 0
	jle _END_6
	mov ebx, 0

;118: ld_str 1
	lea edi, [ebp-50+16]
	lea esi, constStr7
	mov ecx, LENGTHOF constStr7
	rep movsb

;119: skip 6
_END_6:
;120: default 7
	mov eax, ebx
	cmp eax, 0
	jle _END_7

;121: ld_str 1
	lea edi, [ebp-50+16]
	lea esi, constStr8
	mov ecx, LENGTHOF constStr8
	rep movsb

;122: skip 7
_END_7:
;123: ld_str_var 1
	lea eax, [ebp-50+16]
	push eax

;124: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

;125: print_new_line -1
	INVOKE printf, ADDR output_new_line, eax

;126: ld_var 0
	mov eax, [ebp-4]
	push eax

;127: ld_int 3
	mov eax, 3
	push eax

;128: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

;129: ld_var 1
	mov eax, [ebp-8]
	push eax

;130: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

;131: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_int_format, eax

;132: print_new_line -1
	INVOKE printf, ADDR output_new_line, eax

;133: ld_var 1
	mov eax, [ebp-8]
	push eax

;134: ld_int 3
	mov eax, 3
	push eax

;135: mul -1
	pop edx
	pop eax
	imul eax, edx
	push eax

;136: store 1
	mov dword ptr [ebp-8], eax

;137: ld_var 1
	mov eax, [ebp-8]
	push eax

;138: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_int_format, eax

;139: print_new_line -1
	INVOKE printf, ADDR output_new_line, eax

;140: ld_str_var 2
	lea eax, [ebp-50+32]
	push eax

;141: print_str_value -1
	INVOKE printf, ADDR output_str_format, eax

;142: halt -1
	mov esp, ebp
	pop ebp
	xor eax, eax
	ret
main endp
end
