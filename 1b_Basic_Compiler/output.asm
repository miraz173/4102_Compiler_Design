;============= ASM CODE===============

;start -1
.686
.model flat, c
include C:\masm32\include\msvcrt.inc
includelib C:\masm32\lib\msvcrt.lib

.stack 100h
printf PROTO arg1:Ptr Byte, printlist:VARARG
scanf PROTO arg2:Ptr Byte, inputlist:VARARG

.data
output_integer_msg_format byte "%d", 0Ah, 0
output_string_msg_format byte "%s %d", 0Ah, 0
input_integer_format byte "%d",0
output_msg byte "Result: ", 0

number sdword ?

.code

main proc
	push ebp
	mov ebp, esp
	sub esp, 100


;ld_int 5
	mov eax, 5
	push eax


;store 0
	mov dword ptr [ebp-4], eax

;ld_int 7
	mov eax, 7
	push eax


;store 1
	mov dword ptr [ebp-8], eax

;ld_var 0
	mov eax, [ebp-4]
	push eax


;ld_var 1
	mov eax, [ebp-8]
	push eax


;mul -1
	pop edx
	pop eax
	imul eax, edx
	push eax


;store 0
	mov dword ptr [ebp-4], eax

;print_int_value 0
	mov eax, [ebp-4]
	INVOKE printf, ADDR output_string_msg_format, ADDR output_msg, eax

;ld_int 7
	mov eax, 7
	push eax


;ld_var 0
	mov eax, [ebp-4]
	push eax


;add -1
	pop edx
	pop eax
	add eax, edx
	push eax


;store 1
	mov dword ptr [ebp-8], eax

;print_int_value 1
	mov eax, [ebp-8]
	INVOKE printf, ADDR output_string_msg_format, ADDR output_msg, eax

;ld_var 0
	mov eax, [ebp-4]
	push eax


;ld_var 1
	mov eax, [ebp-8]
	push eax


;ld_int 2
	mov eax, 2
	push eax


;mul -1
	pop edx
	pop eax
	imul eax, edx
	push eax


;add -1
	pop edx
	pop eax
	add eax, edx
	push eax


;store 0
	mov dword ptr [ebp-4], eax

;print_int_value 0
	mov eax, [ebp-4]
	INVOKE printf, ADDR output_string_msg_format, ADDR output_msg, eax

;halt -1
	mov esp, ebp
	pop ebp
	ret
main endp
end
