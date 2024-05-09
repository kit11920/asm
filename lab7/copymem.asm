global copymem
 
; 64-битный режим тк есть регистры RSI R...
; При вызове функций C/C++ на Windows первые 4 параметра передаются последовательно через регистры RCX, RDX, R8 и R9. 
; Остальные возможные параметры передаются через стек. 

section .text
copymem:
    lea rsi, [rdx]  ; src
    lea rdi, [rcx]  ; dst
    mov rcx, r8     ; len

    cmp rsi, rdi
    jae copy_left_to_right  ; dst <= src 

    ; dst > src
    copy_right_to_left:
    std                     ;  DF - флаг направления. Он контролирует поведение команд обработки
                            ; строк: когда он установлен в 1, строки обрабатываются в сторону уменьшения адресов, 
                            ; когда DF = 0 - наоборот.
                            ; команда STD устанавливает флаг DF в единицу. 
    ; перень регистры указывают на последие элементы строк
    add rsi, rcx
    dec rsi
    add rdi, rcx
    dec rdi

    copy_left_to_right:
    rep movsb       ; Копирование строки байтов. Копирует 1 байт из памяти по адресу rsi в rdi
                    ; rep - Повторять - префикс для операций над строками столько раз сколько RCX
    CLD    ; команда CLD сбрасывает флаг DF;

    mov rax, 0  ; код возврата
    ret
