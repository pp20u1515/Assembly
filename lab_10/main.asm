.386 
.model flat, stdcall ; Здесь flat указывает на использование плоской модели памяти, 
                     ; в которой адреса памяти представляются без сегментного смещения.
                     ; stdcall указывает на использование соглашения о вызове функций stdcall, 
                     ; при котором параметры функции передаются через стек в обратном порядке, 
                     ; а очистка стека выполняется вызываемой функцией.
option casemap :none   ; case sensitive

include \masm32\include\windows.inc
include \masm32\include\user32.inc 
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc
include \masm32\include\masm32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\masm32.lib

; Local macros
szText MACRO Name, Text:VARARG
  LOCAL lbl ; Эта строка объявляет локальную метку lbl. Локальные метки используются 
            ; внутри макросов для обозначения места перехода или ссылки на определенные участки кода.
    jmp lbl 
      Name db Text, 0
    lbl:
  ENDM 
  
; Local prototypes
WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
    
.data
    Edit1      dd 0
    Edit2      dd 0
    Edit3      dd 0
    Buton      dd 0
    Instance   dd 0
    dlgname db "TestWin", 0
    answer db 10 dup(?)

.code

start:

      invoke GetModuleHandle, NULL ; вызываем дескриптор
      mov Instance, eax ; сохраняем дескриптор  в Instance
      
      ; Call the dialog box stored in resource file
      invoke DialogBoxParam, Instance, ADDR dlgname, 0, ADDR WndProc, 0  

      invoke ExitProcess, eax

WndProc proc hWin   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

      .if uMsg == WM_INITDIALOG
      
        szText dlgTitle,"Sum of two digits"
        invoke SendMessage, hWin, WM_SETTEXT, 0, ADDR dlgTitle

        invoke GetDlgItem, hWin, 100
        mov Edit1, eax

        invoke GetDlgItem,hWin,101
        mov Edit2, eax

        invoke GetDlgItem,hWin,103
        mov Edit3, eax

        invoke GetDlgItem, hWin, 1000
        mov Buton, eax

        xor eax, eax
        ret

      .elseif uMsg == WM_COMMAND
        .if wParam == 1000
        
			invoke GetWindowText, Edit1, addr answer, 10	

			xor ebx, ebx
			mov bl, byte ptr answer
			sub bl, '0'
			push ebx
			
			invoke GetWindowText, Edit2, addr answer, 10 
			xor ebx, ebx
			mov bl, byte ptr answer
			sub bl, '0'
			
			pop eax
			add eax, ebx
			
			mov bl, 10
			div bl
			
			add al, '0'
			add ah, '0'
			mov answer[0], al
			mov answer[1], ah
			
			invoke SetWindowText, Edit3, addr answer	
			
        .endif


      .elseif uMsg == WM_CLOSE
        invoke EndDialog, hWin, 0

        xor eax, eax
        ret

      .endif

    xor eax, eax
    ret

WndProc endp
end start