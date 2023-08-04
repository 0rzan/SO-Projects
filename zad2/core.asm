global core
extern get_value
extern put_value

section .bss

align 8
stack_val: resq N                               ; reserve memory for stack top values for each thread

section .data

align 8
stack_id: times N DQ N                          ; reserve memory for partner_id to synchronize exchange

section .text

core:
        push    rbx                             ; preserve starting value of rbx 
        mov     rcx, rsp                        ; preserve starting stack pointer

.main_loop:
        movzx   eax, BYTE [rsi]                 
        inc     rsi
        test    al, al
        jz      .return
        cmp     al, '+'
        je      .op_plus
        cmp     al, '*'
        je      .op_mul
        cmp     al, '-'
        je      .op_minus
        cmp     al, 'n'
        je      .op_n
        cmp     al, 'B'
        je      .op_B
        cmp     al, 'C'
        je      .op_C
        cmp     al, 'D'
        je      .op_D
        cmp     al, 'E'
        je      .op_E
        cmp     al, 'G'
        je      .op_G
        cmp     al, 'P'
        je      .op_P
        cmp     al, 'S'
        je      .op_S

.op_digit:
        sub     al, '0'
        push    rax
        jmp     .main_loop

.return:
        pop     rax
        mov     rsp, rcx                        ; restore starting stack pointer  
        pop     rbx                             ; restore starting rbx value
        ret

.op_plus:
        pop     rax
        pop     rdx
        add     rax, rdx
        push    rax
        jmp     .main_loop

.op_mul:
        pop     rax
        pop     rdx
        mul     rdx
        push    rax
        jmp     .main_loop

.op_minus:
        neg     QWORD [rsp]
        jmp     .main_loop

.op_n:
        push    rdi
        jmp     .main_loop

.op_B:
        pop     rax
        cmp     QWORD [rsp], 0x0
        je      .main_loop
        add     rsi, rax
        jmp     .main_loop

.op_C:
        pop     rax
        jmp     .main_loop

.op_D:
        push    QWORD [rsp]
        jmp     .main_loop

.op_E:
        pop     rax
        pop     rdx
        push    rax
        push    rdx
        jmp     .main_loop

.op_G:
        push    rcx
        push    rdi
        push    rsi                             ; preserve starting stack address, n, address of next char
        mov     rbx, rsp
        and     rsp, -16                        ; allign stack befor call
        call    get_value
        mov     rsp, rbx
        pop     rsi
        pop     rdi
        pop     rcx                             ; restore values mentioned above
        push    rax
        jmp     .main_loop

.op_P:
        pop     rdx
        push    rcx
        push    rdi
        push    rsi                             ; preserve starting stack address, n, address of next char
        mov     rsi, rdx
        mov     rbx, rsp
        and     rsp, -16                        ; allign stack befor call
        call    put_value
        mov     rsp, rbx
        pop     rsi
        pop     rdi
        pop     rcx                             ; restore values mentioned above
        jmp     .main_loop

; setting stack_val[my_id] before stack_id[my_id] ensures that my partner can exchange the right value
; setting stack_id[my_id] ensures that my partner can exchange and no other thread can
.op_S:
        pop     rax                             ; partner_id
        pop     r9                              ; my stack top value for exchanging with partner
        lea     rdx, [rel stack_id]
        lea     r8, [rel stack_val]
        mov     [r8 + rdi * 8], r9              ; set stack_val[my_id] to my stack top
        mov     [rdx + rdi * 8], rax            ; set stack_id[my_id] to partner_id

.wait_for_partner_and_exchange:
        cmp     [rdx + rax * 8], rdi            ; check if partner is ready
        jne     .wait_for_partner_and_exchange
        push    QWORD [r8 + rax * 8]            ; push stack_val[partner_id]
        mov     QWORD [rdx + rax * 8], N        ; set stack_id[partner_id] = N to synchronize with partner

.wait_after_exchange:
        cmp     QWORD [rdx + rdi * 8], N        ; wait for partner
        jne     .wait_after_exchange
        jmp     .main_loop