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
output_int_format byte "%d", 0Ah, 0
output_str_format byte "%s", 0Ah, 0
output_str_int_format byte "%s %d", 0Ah, 0
msg db 64 dup ("Result: ", 0)
input_char_format byte "%c", 0
input_str_format byte "%s", 0
input_int_format byte "%d", 0

.code

main proc
	push ebp
	mov ebp, esp
	sub esp, 100

;  1: ld_int 4
	mov eax, 4
	push eax

;  2: store 1
	mov dword ptr [ebp-8], eax

;  3: while_label 1
WHILE_START_LABEL_1:
;  4: ld_var 1
	mov eax, [ebp-8]
	push eax

;  5: ld_int 7
	mov eax, 7
	push eax

;  6: lt 6
	pop edx
	pop eax
	cmp eax, edx
	jge O_6
	mov eax, 1
	push eax
	jmp END_LT_6
O_6:
	mov eax, 0
	push eax
END_LT_6:

;  7: while_start 1
	pop eax
	cmp eax, 0
	jle WHILE_END_LABEL_1

;  8: ld_var 1
	mov eax, [ebp-8]
	push eax

;  9: ld_int 1
	mov eax, 1
	push eax

; 10: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

; 11: store 1
	mov dword ptr [ebp-8], eax

; 12: ld_var 1
	mov eax, [ebp-8]
	push eax

; 13: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_str_int_format, ADDR msg, eax

; 14: ld_int 3
	mov eax, 3
	push eax

; 15: store 0
	mov dword ptr [ebp-4], eax

; 16: while_label 2
WHILE_START_LABEL_2:
; 17: ld_var 0
	mov eax, [ebp-4]
	push eax

; 18: ld_int 6
	mov eax, 6
	push eax

; 19: lt 9
	pop edx
	pop eax
	cmp eax, edx
	jge O_9
	mov eax, 1
	push eax
	jmp END_LT_9
O_9:
	mov eax, 0
	push eax
END_LT_9:

; 20: while_start 2
	pop eax
	cmp eax, 0
	jle WHILE_END_LABEL_2

; 21: ld_var 0
	mov eax, [ebp-4]
	push eax

; 22: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_str_int_format, ADDR msg, eax

; 23: ld_var 0
	mov eax, [ebp-4]
	push eax

; 24: ld_int 1
	mov eax, 1
	push eax

; 25: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

; 26: store 0
	mov dword ptr [ebp-4], eax

; 27: while_end 2
	jmp WHILE_START_LABEL_2
WHILE_END_LABEL_2:

; 28: while_end 1
	jmp WHILE_START_LABEL_1
WHILE_END_LABEL_1:

; 29: ld_int 6
	mov eax, 6
	push eax

; 30: store 1
	mov dword ptr [ebp-8], eax

; 31: scan_int_value 2
	INVOKE scanf, ADDR input_int_format, ADDR [ebp-12]
	mov eax, [ebp-12]

; 32: ld_var 2
	mov eax, [ebp-12]
	push eax

; 33: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_str_int_format, ADDR msg, eax

; 34: scan_str_value -1
	INVOKE scanf, ADDR input_str_format, ADDR msg

; 35: ld_var 2
	mov eax, [ebp-12]
	push eax

; 36: ld_int 5
	mov eax, 5
	push eax

; 37: gt 23
	pop edx
	pop eax
	cmp eax, edx
	jle O_23
	mov eax, 1
	push eax
	jmp END_GT_23
O_23:
	mov eax, 0
	push eax
END_GT_23:

; 38: check 3
	mov ebx, 1
	pop eax
	cmp eax, 0
	jle _END_3
	mov ebx, 0

; 39: ld_var 2
	mov eax, [ebp-12]
	push eax

; 40: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_str_int_format, ADDR msg, eax

; 41: skip 3
_END_3:
; 42: default 4
	mov eax, ebx
	cmp eax, 0
	jle _END_4

; 43: ld_int 0
	mov eax, 0
	push eax

; 44: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_str_int_format, ADDR msg, eax

; 45: skip 4
_END_4:
; 46: ld_var 2
	mov eax, [ebp-12]
	push eax

; 47: ld_var 0
	mov eax, [ebp-4]
	push eax

; 48: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

; 49: ld_int 3
	mov eax, 3
	push eax

; 50: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

; 51: ld_var 1
	mov eax, [ebp-8]
	push eax

; 52: add -1
	pop edx
	pop eax
	add eax, edx
	push eax

; 53: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_str_int_format, ADDR msg, eax

; 54: ld_var 1
	mov eax, [ebp-8]
	push eax

; 55: ld_int 3
	mov eax, 3
	push eax

; 56: mul -1
	pop edx
	pop eax
	imul eax, edx
	push eax

; 57: store 1
	mov dword ptr [ebp-8], eax

; 58: ld_var 1
	mov eax, [ebp-8]
	push eax

; 59: print_reg_value -1
	pop eax
	INVOKE printf, ADDR output_str_int_format, ADDR msg, eax

; 60: halt -1
	mov esp, ebp
	pop ebp
	xor eax, eax
	ret
main endp
end
