[org 0x7c00]

mov ah, 0x0e ;use text mode

mov bx, boot_message
call print_string ;print the boot message

mov bx, boot_message
call print_string ;print the boot message

mov dx, 0x1fb6
call print_hex ;print the hex

call disk_load

jmp $

%include "bootsector_lib.s"

boot_message:
	db "Hello world!",0 ;declare as null terminating

times 510-($-$$) db 0
dw 0xaa55