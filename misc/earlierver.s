.section .data
c: .long 0
desc: .long 0 #descriptor
d: .long 20 #dimensiune
opt: .long 8 
v: .space 1024
format: .string "v[%d]=%d\n" #PENTRU DEBUG
amspatiu: .long 0
k: .long 0 #folosit in functia get
add_format: .asciz "%d: "
buf: .asciz "(%d, %d)\n" # print pt get
print_format: .asciz "[%d]: (%d, %d)\n"  # DELETE SI DEFRAG
#CITIRE
buffer: .space 102 #pt scanf
scanf_format: .asciz "%d" #pt citirea de la tastatura
num_operations: .long 0
current_function: .long 0
num_calls: .long 0
call_counter: .long 0
operation_counter: .long 0
.text
.global main




#ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD



et_add: #12 desc,d,ret,ebp,
xor %eax, %eax
pushl %ebp
mov %esp,%ebp
movl 8(%ebp),%eax #d in eax
xorl %edx, %edx
divl opt #eax=20/8=2 edx=4
movl $v, %esi
xorl %ebx,%ebx


cautare:
cmpb $0,(%esi,%ebx,1) #verifica daca al ebx lea element din v este 0 
jne incebx
je test
incebx:
incl %ebx
jmp cautare
test: 
mov %ebx,c 
jmp e0


e0:
#verific daca incape 
incl %ebx
cmpb $0,(%esi,%ebx,1)
je incebx2
jne amAflatSpatiu
incebx2:
incl %ebx
jmp e0
amAflatSpatiu:
movl %ebx, %ecx #il mut pe ebx care e pozitia ultimului 0 in ecx
subl c, %ecx
movl %ecx, amspatiu # amspatiu=cat spatiu am la dispozitie pentru a imi pune valorile
cmpl amspatiu, %eax
jle ok
jg cautare
#sfarsit cautare


ok:
movl $v, %esi
movl c, %ecx #ecx= pozitia de unde incep sa adaug
addl %ecx, %eax
cmpl $0, %edx 
je add_rest0
jne add_restd0
add_rest0:
cmpl %eax, %ecx
jge add_exit
movl 12(%ebp),%edx #desc in edx 
addb %dl, (%esi,%ecx,1)
incl %ecx
jmp add_rest0
add_restd0:
cmpl %eax, %ecx
jg add_exit
movl 12(%ebp),%edx #desc in edx
addb %dl, (%esi,%ecx,1)
incl %ecx
jmp add_restd0
add_exit:
popl %ebp

ret





#DELETEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE




et_delete: #desc e in edx si ecx e pozitia
xorl %ecx, %ecx
movl 4(%esp), %edx
et_delete_loop:
cmpl $1024, %ecx
jge delete_exit
cmpb %dl,(%esi,%ecx,1)
je sterg
jne incecx
sterg:
movb $0, (%esi,%ecx,1)
jmp et_delete_loop
incecx:
incl %ecx
jmp et_delete_loop
delete_exit:
ret


#GETTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT




et_get:
xorl %ecx, %ecx
movl 4(%esp), %edx #ce element caut
et_get_loop:
cmpl $1024, %ecx
jg nuexista
cmpb %dl, (%esi,%ecx,1)
je numarare
jne incecxget
numarare:
movl %ecx, k
jmp numarare_loop
numarare_loop:
incl %ecx
cmpb %dl, (%esi,%ecx,1)
je numarare_loop
jne amgasitnumarul
incecxget:
incl %ecx
jmp et_get_loop
amgasitnumarul:
push %edx                    
subl $1, %ecx
push %ecx                   
push k                        
push $buf                    
call printf                  
addl $12, %esp                
pop %edx                      
jmp get_exit
nuexista:
push %edx                    
movl $0, %ecx
push %ecx  
movl %ecx, k                 
push k                        
push $buf                    
call printf                  
addl $12, %esp                
pop %edx                      
jmp get_exit
get_exit:
ret






#DEFRAGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG

et_defrag:
xorl %ecx, %ecx # ecx =i
xorl %edx, %edx # edx=j

shift:
cmpl $1024, %edx 
jge zero
movb (%esi,%edx,1), %al  
cmpl $0, %eax        
je incedx
movb %al, (%esi,%ecx,1)  
incl %ecx           
incedx:
incl %edx         
jmp shift 

zero:
cmpl $1024, %ecx  
jge defrag_exit
movb $0, (%esi,%ecx,1)
incl %ecx  
jmp zero
defrag_exit:
ret






#PRINT ADEVARAT DELETE DEFRAG 
#VAD CE DESCRIPTOR E SI APOI FAC PRINT SI GET DE DESCRIPTORUL ALA
print_delete_defrag:
    movl $v, %esi           # Adresa de început a vectorului
    xorl %ecx, %ecx                # Indexul de pornire
    xorl %eax, %eax
    xorl %ebx, %ebx
    movl $-1, %edx
delete_defrag_loop:
cmpl $1024, %ecx
jge delete_defrag_exit
movb (%esi,%ecx,1), %al   # Load the value from the vector at position ECX into EAX
movb (%esi,%edx,1), %bl   # Load the value from the vector at position EDX into EBX
cmpl $0, %eax
je next
cmpl %ebx, %eax            # Compare the values in EAX and EBX
jne printare
je next
printare:
pushl %eax
movb (%esi,%ecx,1), %al #ELEMENTUL DIN VECTOR IN DESC
movzbl %al, %eax
movl %eax, desc
popl %eax
#MEMERY SAFE 
pushl %eax        
pushl %ecx         
pushl %edx         
#MEMORY SAFE END
pushl desc
pushl $add_format
call printf
addl $8, %esp
#POP
popl %edx            
popl %ecx           
popl %eax         
#POP END
#PRINT LA INTERVAL
pushl %eax           
pushl %ecx           
pushl %edx           
pushl desc
call et_get
add $4, %esp
popl %edx            
popl %ecx            
popl %eax            
next:
movl %ecx, %edx #EDX E ECX-1
incl %ecx
jmp delete_defrag_loop
delete_defrag_exit:
ret


#PRINT PENTRU DEBUG 
print_loop:
xorl %ecx, %ecx
print_start:
cmpl $160, %ecx
jge et_exit
movl %ecx, %edx
xorl %eax,%eax
movb v(,%ecx,1), %al
pushl %ecx
pushl %eax
pushl %edx
pushl $format
call printf
addl $12, %esp
popl %ecx
incl %ecx
jmp print_start


#CITIREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE

read_input:
    # Configurarea pentru a citi un număr cu scanf
    pushl $buffer             # Push adresa arrayului buffer in stack
    pushl $scanf_format      # Push format string pentru scanf
    call scanf               # Apelează scanf
    addl $8, %esp            # Curăță stiva

    # Salvarea valorii citite
    movl buffer, %eax        # Mută valoarea citită în EAX

    ret

handle_operations:
    movl operation_counter, %ebx
    cmpl num_operations, %ebx #COMPARA 4 CU 1
    jge end_operations  # Dacă am terminat toate operațiile, ieși

    # Citirea codului funcției
    call read_input
    movl %eax, current_function  # MOV 1 IN CURRENT FUNCTION

    # Citirea numărului de apeluri pentru funcția curentă
    cmpl $1, current_function
    je eadd
    jne nueadd
    eadd:
    call read_input
    movl %eax, num_calls       # Salvează numărul de apeluri
    movl $0, call_counter        # Resetează contorul de apeluri
    jmp continuare
    nueadd:
    movl $1, num_calls
    movl $0, call_counter
    continuare:

    incl operation_counter
#SO FAR SO GOOD
handle_calls: #DOAR PT ADD
    movl call_counter, %ecx #MOV 0 IN ECX
    cmpl num_calls, %ecx
    jge handle_operations  # Dacă am terminat toate apelurile, trece la următoarea funcție

    # Creșterea contorului de apeluri
    incl call_counter #CALL COUNTER=1

    # Apelarea funcției corespunzătoare
    cmpl $1, current_function
    je call_add
    cmpl $2, current_function
    je call_get
    cmpl $3, current_function
    je call_delete
    cmpl $4, current_function
    je call_defrag

    jmp handle_calls

call_add:
    call read_input  # Citește primul parametru (elementul adăugat)
    movl buffer, %ebx  # Salvează primul parametru în EBX
    movl %ebx, desc  #DESCRIPTOR
    call read_input  # Citește al doilea parametru
    movl buffer, %ecx  # Salvează al doilea parametru în ECX

    # Apelul funcției `et_add` pentru a realiza adăugarea
    pushl %ebx  # Al doilea parametru (ultima poziție)
    pushl %ecx  # Primul parametru (elementul adăugat)
    call et_add  # Apelează funcția `et_add`
    addl $8, %esp  # Curăță stiva
    #PRINT LA DESCRPTIOR
    pushl desc
    pushl $add_format
    call printf
    addl $8, %esp
    #PRINT LA INTERVAL
    pushl desc
    call et_get
    add $4, %esp

    jmp handle_calls  


call_get: #1 INPUT
call read_input
movl buffer, %ebx  # Salvează parametrii în EBX sau alte registre
pushl %ebx
call et_get  # Apelează funcția 2
addl $4, %esp  
jmp handle_operations

call_delete: # 1 INPUT
    call read_input  # Citește parametrii necesari
    movl buffer, %ebx  # Salvează parametrii în EBX sau alte registre
    pushl %ebx
    call et_delete  # Apelează funcția 3
    addl $4, %esp  # Curăță stiva
    call print_delete_defrag
    jmp handle_operations

call_defrag: #0 INPUT
    call et_defrag
    call print_delete_defrag
    jmp handle_operations

end_operations:
    ret
main:
movl $0, operation_counter
movl $0, call_counter
call read_input
movl %eax, num_operations
call handle_operations
call print_loop
#ecx counter pt nr de apeluri pt o functie
#cmpl nr apeluri cu ecx
#jle call read input 
et_exit:
mov $1, %eax
xor %ebx, %ebx
int $0x80

.extern printf