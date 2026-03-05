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
buffer: .space 1024 #pt scanf
scanf_format: .asciz "%d" #pt citirea de la tastatura
nroperatii: .long 0
currentfunction: .long 0
nrcalls: .long 0
callcounter: .long 0
cntoperatie: .long 0
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
cmpl $0, %edx
jne inceax
je maideparte
inceax:
addl $1, %eax
maideparte:
movl $v, %esi
xorl %ecx,%ecx
cautare:
cmpb $0,(%esi,%ecx,1)  #verifica daca al ecx lea element din v este 0 
jne incecxadd
je ouchei
incecxadd:
incl %ecx
jmp cautare
ouchei:
movl %ecx,c #c e pozitia primului 0

e0:
#verific daca incape
cmpb $0,(%esi,%ecx,1)
je incecx2
jne amAflatSpatiu
incecx2:
incl %ecx
jmp e0
amAflatSpatiu:
movl %ecx, %edi
subl c, %ecx
movl %ecx, amspatiu # amspatiu=cat spatiu am la dispozitie pentru a imi pune valorile



pentrudelete:
cmpl $1024, %edi
jge nuamloc
cmpb $0,(%esi,%edi,1)
jne incedi
je continuam
incedi:
incl %edi
jmp pentrudelete

nuamloc:
cmpl %ecx, %eax # pentru cand nu incape
jg add_exit

continuam:
movl %edi, %ecx #daca nu folosesc edi imi da segmentation fault cand ii dau run normal dar merge perfect daca ii dau din debugger
cmpl amspatiu, %eax
jle ok
jg cautare
ok:
movl c, %ecx #ecx= pozitia de unde incep sa adaug
addl %ecx, %eax
add_rest0:
cmpl %eax, %ecx
jge add_exit
movl 12(%ebp),%edx #desc in edx 
addb %dl, (%esi,%ecx,1)
incl %ecx
jmp add_rest0
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
movl $v, %esi
movl 4(%esp), %edx #ce element caut
et_get_loop:
cmpl $1024, %ecx
jge nuexista
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






#PRINT  DELETE DEFRAG 
#VAD CE DESCRIPTOR E SI APOI FAC PRINT SI GET DE DESCRIPTORUL ALA
print_delete_defrag:
movl $v, %esi           
xorl %ecx, %ecx              
xorl %eax, %eax
xorl %ebx, %ebx
movl $-1, %edx
delete_defrag_loop:
cmpl $1024, %ecx
jge delete_defrag_exit
movb (%esi,%ecx,1), %al  
movb (%esi,%edx,1), %bl  
cmpl $0, %eax
je next
cmpl %ebx, %eax          
jne printare
je next
printare:
pushl %eax
movb (%esi,%ecx,1), %al #ELEMENTUL DIN VECTOR IN DESC
movzbl %al, %eax
movl %eax, desc
popl %eax
#MEMORY SAFE 
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
#CITIREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
read_input:
pushl $buffer            
pushl $scanf_format     
call scanf              
addl $8, %esp         
movl buffer, %eax       
ret
handle_operatii:
movl cntoperatie, %ebx
cmpl nroperatii, %ebx #COMPARA 4 CU 1
jge end_operatii  
call read_input
movl %eax, currentfunction  # MOV 1 IN CURRENT FUNCTION
cmpl $1, currentfunction
je eadd
jne nueadd
eadd:
call read_input
movl %eax, nrcalls       
movl $0, callcounter        
jmp continuare
nueadd:
movl $1, nrcalls
movl $0, callcounter
continuare:
incl cntoperatie
handle_calls: #DOAR PT ADD
movl callcounter, %ecx #MOV 0 IN ECX
cmpl nrcalls, %ecx
jge handle_operatii  
incl callcounter #CALL COUNTER=1
cmpl $1, currentfunction
je call_add
cmpl $2, currentfunction
je call_get
cmpl $3, currentfunction
je call_delete
cmpl $4, currentfunction
je call_defrag
jmp handle_calls
call_add:
call read_input  
movl buffer, %ebx  
movl %ebx, desc  #DESCRIPTOR
call read_input  
movl buffer, %ecx  
pushl %ebx  
pushl %ecx  # SIZE
call et_add  
addl $8, %esp  
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
movl buffer, %ebx  
pushl %ebx
call et_get  
addl $4, %esp  
jmp handle_operatii
call_delete: # 1 INPUT
call read_input  
movl buffer, %ebx  
pushl %ebx
call et_delete  
addl $4, %esp  
call print_delete_defrag
jmp handle_operatii
call_defrag: #0 INPUT
call et_defrag
call print_delete_defrag
jmp handle_operatii
end_operatii:
ret
main:
movl $0, cntoperatie
movl $0, callcounter
call read_input
movl %eax, nroperatii
call handle_operatii
et_exit:
push $0
call fflush
popl %eax
mov $1, %eax
xor %ebx, %ebx
int $0x80
.extern printf
.extern stdout
.extern fflush 