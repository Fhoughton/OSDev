print_string:
	pusha
	mov ah, 0x0e
	mov al, [bx]
	int 0x10
	cmp al, 0
	jne increment
	jmp the_end
increment:  
		add bx , 1
		mov al, [bx]    
		int 0x10
		cmp al, 0
		jne increment
		jmp the_end
the_end:    
	popa    
	ret

print_hex:
	pusha
	
	mov si, hex_output + 2 ;keep track of char in si
	mov cx, 0 ;counter
next_character:
	inc cx
	
	;isolate 4 bits
	mov bx, dx
	and bx, 0xf000
	shr bx, 4
	
	add bh, 0x30 ;adding 30 gets the value as ascii
	
	;if digit was less than 9 then will be less than 39 so add 7 to resolve ascii
	cmp bh, 0x39
	jg add_7
add_character_hex:
	mov [si],bh ;put into string template
	
	inc si ;increment char position
	
	shl dx, 4 ;shift dx by 4 to get the next right nibble
	
	;exit if all nibbles processed, else loop
	cmp cx, 4
	jnz next_character
	
	;done so let's copy to the string
	mov bx, hex_output
	
	call print_string ;print the ascii
	
	popa
	ret
	
add_7:
	add bh, 0x07
	jmp add_character_hex
		
disk_load:
	push dx
	
	mov ah, 0x02 ;read sector function
	mov al, dh ;read dh sectors
	mov ch, 0x00 ;cyclinder 0
	mov dh, 0x00 ;head 0
	mov cl, 0x02 ;statr reading from second sector
	
	jc disk_error ;carry so read error
	
	pop dx ;restore dx from stack
	cmp dh, al ;if expected and read sectors differ
	jne disk_error
	ret
	
disk_error:
	mov bx, disk_errormsg
	call print_string
	jmp $
	
hex_output:
	db "0x0000",0
	
disk_errormsg:
	db "Error: failed to read disk.",0