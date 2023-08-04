global inverse_permutation

SIZE_MAX equ 0x80000000
INT_MAX equ 0x7fffffff

inverse_permutation:
        cmp     rdi, 0x0                        ; check if n > 0
        jle     .permutation_invalid

        mov     rax, SIZE_MAX                   ; check if n < INT_MAX + 2
        cmp     rdi, rax
        jg      .permutation_invalid

        mov     rcx, rsi                        ; rcx = address of the first element i.e. iterator
        lea     rdx, [rsi + rdi * 4]            ; rdx = address of the last + 1 element

.check_range_loop:
        mov     eax, [rcx]                      ; eax = content of rcx i.e. i-th element of the permutation
        cmp     eax, edi                        ; check if eax < n
        jge     .permutation_invalid
        cmp     eax, 0x0                        ; chceck if eax > 0
        jl      .permutation_invalid

        add     rcx, 0x4                        ; inc the address by 4 bytes i.e. increment the iterator
        cmp     rcx, rdx                        ; check if the iterator is still in the range
        jne     .check_range_loop

        mov     rcx, rsi                        ; reset iterator

.check_repetitions_loop:                
        mov     eax, [rcx]              
        and     eax, INT_MAX            
        add     DWORD [rsi + rax * 4], SIZE_MAX
        cmovo   rcx, rsi                        ; if 32nd bit is = 1 already we are a duplicate
        jo      .clean_up                       ; jump to clean_up

        add     rcx, 0x4
        cmp     rcx, rdx                
        jne     .check_repetitions_loop
    
        mov     ecx, 0x0                        ; set iterator to ecx = i = 0

.reverse_permutation_main_loop:                 ; reverses cycles
        mov     eax, [rsi + rcx * 4]            ; eax = p[ecx]
        cmp     eax, 0x0                        ; if 32nd bit = 1 then cycle with ecx wasnt reversed
        jge     .continue_main_loop             ; if not above then continue

        and     eax, INT_MAX            
        mov     edx, ecx                        ; edx = prev

.reverse_permutation_loop:
        mov     r8d, [rsi + rax * 4]            ; r8d = next
        mov     DWORD [rsi + rax * 4], edx
        mov     edx, eax                        ; p[j] = prev, prev = j
        mov     eax, r8d                        ; j = next
        and     eax, INT_MAX            
        cmp     ecx, eax                        ; if i = j end loop
        jne     .reverse_permutation_loop

        mov     DWORD [rsi + rax * 4], edx

.continue_main_loop:
        inc     ecx
        cmp     ecx, edi                        ; check if the iterator is still in the range
        jne     .reverse_permutation_main_loop

        mov     rax, 0x1
        ret

.clean_up:
        and     DWORD [rcx], INT_MAX            ; reset every 32nd bit to 0
        add     rcx, 0x4
        cmp     rcx, rdx
        jne     .clean_up

.permutation_invalid:
        mov     rax, 0x0
        ret