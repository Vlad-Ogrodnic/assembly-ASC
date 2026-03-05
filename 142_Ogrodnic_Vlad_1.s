.section .data
c: .long 0
desc: .long 0 #descriptor
d: .long 20 #dimensiune
descriptordefrag: .long 0 #pentru defragmentare
opt: .long 8 
omie24: .long 1024
omIe24: .long 1024
c2: .long 0
linieedx: .long 0
catide0: .long 0
undesunt: .long 0
primuldesc: .long 0
linia: .long 0
amspatiud: .long 0
v: .space 0x100000 #vector de 1024^2 bytes
format: .string "%d," #PENTRU DEBUG
formatendline: .string "\n"
amspatiu: .long 0
spatiupelinie: .long 0
k: .long 0 #folosit in get
add_format: .asciz "%d: "
buf: .asciz "((%d, %d), (%d, %d))\n" # print pt get
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
xorl %eax, %eax
xorl %edi, %edi 
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

cmpl $1025, %eax
jge add_exit

xorl %ecx,%ecx #intre 0 si 7
xorl %edx, %edx 
xorl %ebx, %ebx #intre 0 si (1024^2)-1

cautare: #aici caut primul 0
cmpl $1024, %ecx
jge incedi
jl continuam1
incedi:
incl %edi
xorl %ecx, %ecx

continuam1:

pushl %eax
movl  omie24, %eax
mul %edi #eax*edi si rezultatul se afla in eax
movl %eax, %ebx #ebx e aproape pozitia absoluta (eax este edi*8) 
addl %ecx, %ebx #acum sper ca ebx e pozitia absoluta (edi(adica linia)*8+ecx( adica elementul de pe linie))
popl %eax
cmpb $0,(%esi,%ebx,1)  #verifica daca al ebx lea element din v este 0
jne incecxadd
je ouchei
incecxadd:
incl %ecx
jmp cautare


ouchei:
movl %ecx, c #c e pozitia neabsoluta a primului 0
e0: #verific daca incape
cmpl $1024, %ecx
jge amAflatSpatiu
jl continuam2
continuam2:
pushl %eax
movl  omie24, %eax
mul %edi #eax*edi si rezultatul se afla in eax
movl %eax, %ebx #ebx e aproape pozitia absoluta (eax este edi*8) 
addl %ecx, %ebx #acum  ebx e pozitia absoluta (edi(adica linia)*8+ecx( adica elementul de pe linie))
popl %eax
cmpb $0,(%esi,%ebx,1)  #verifica daca al ebx lea element din v este 0
je incecxadd2
jne amAflatSpatiu
incecxadd2:
incl %ecx
jmp e0
amAflatSpatiu: 
pushl %edi
movl %ecx, %edi
subl c, %ecx #scad primul 0 din ultimul 0 ca sa aflu cati de 0 am liberi 
movl %ecx, amspatiu
addl c, %ecx #il adaug la loc pt ca imi trebui pozitia ultimului 0 in cazul in care nu am spatiu si vreau sa vad la ce element am ajuns
cmpl amspatiu, %eax
jg popedi2
jle pentrudelete
popedi2:
popl %edi
jmp cautare


pentrudelete:
cmpl $0x100000, %edi
jge nuamloc
cmpb $0,(%esi,%edi,1)
jne incedi3
je continuam
incedi3:
incl %edi
jmp pentrudelete

nuamloc:
cmpl amspatiu, %eax # pentru cand nu incape
jg popedi
jle continuam
popedi: 
popl %edi
jmp add_exit

continuam:
movl %edi, %ecx #daca nu folosesc edi imi da segmentation fault cand ii dau run normal dar merge perfect daca ii dau din debugger
popl %edi
cmpl amspatiu, %eax
jle ok
jg cautare
ok:
pushl %eax
movl  omie24, %eax
mul %edi #eax*edi si rezultatul se afla in eax
movl %eax, %ebx #ebx e aproape pozitia absoluta (eax este edi*8) 
addl c, %ebx #acum ebx e pozitia absoluta de unde incep sa adaug
popl %eax
movl %ebx, %ecx
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




#ADD DEFRAG 

add_defrag:
cmpb $0,(%esi,%ebx,1)  #verifica daca al ebx lea element din v este 0
jne incebxadd
je oucheid
incebxadd:
incl %ebx
jmp add_defrag
oucheid:
pushl %eax
pushl %edx
xorl %edx, %edx
movl  %ebx, %eax
divl omie24
movl %eax, %ecx  
addl %edx, %ecx #acum ecx e pozitia relativa
popl %edx
popl %eax
movl %ecx, c #c e pozitia absoluta a primului 0
e0d: #verific daca incape

pushl %eax
pushl %edx
xorl %edx, %edx
movl  %ebx, %eax
divl omie24
movl %eax, %ecx  
addl %edx, %ecx #acum ecx e pozitia relativa
popl %edx
popl %eax

cmpl $1024, %ecx
jge amAflatSpatiud
jl continuam2d
continuam2d:
cmpb $0,(%esi,%ebx,1)  #verifica daca al ebx lea element din v este 0
je incecxadd2d
jne amAflatSpatiud
incecxadd2d:
incl %ecx
incl %ebx
jmp e0d
amAflatSpatiud: 
subl c, %ecx #scad primul 0 din ultimul 0 ca sa aflu cati de 0 am liberi 
movl %ecx, amspatiu
addl c, %ecx #il adaug la loc pt ca imi trebui pozitia ultimului 0 in cazul in care nu am spatiu si vreau sa vad la ce element am ajuns
movl 4(%esp), %eax #marimea
cmpl amspatiu, %eax
jg add_defrag_exit
jle add_rest0d
add_rest0d:
cmpl %eax, %ecx
jge add_defrag_exit
movl 8(%esp),%edx #desc in edx 
addb %dl, (%esi,%ecx,1)
incl %ecx
jmp add_rest0d
add_defrag_exit:
ret




















#DELETEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE




et_delete: #desc e in edx si ecx e pozitia
xorl %ecx, %ecx
xorl %edi, %edi
xorl %ebx, %ebx
movl 4(%esp), %edx
et_delete_loop:
cmpl $1024, %edi
jge delete_exit
cmpl $1024, %ecx
jge incedidelete
jl continuamdelete
incedidelete:
incl %edi
xorl %ecx, %ecx 
continuamdelete:
pushl %edx
movl  omie24, %eax
mul %edi #eax*edi si rezultatul se afla in eax
movl %eax, %ebx #ebx e aproape pozitia absoluta (eax este edi*8) 
addl %ecx, %ebx #acum ebx e pozitia absoluta (edi(adica linia)*8+ecx( adica elementul de pe linie))
popl %edx
cmpb %dl,(%esi,%ebx,1)
je sterg
jne incecx
sterg:
movb $0, (%esi,%ebx,1)
jmp et_delete_loop
incecx:
incl %ecx
jmp et_delete_loop
delete_exit:
ret


#GETTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT




et_get:  
xorl %ecx, %ecx
xorl %edi, %edi
movl $v, %esi
movl 4(%esp), %edx #ce element caut
et_get_loop:
cmpl $1024, %edi
jge nuexista
cmpl $1024, %ecx
jge incediget
jl continuamget
incediget:
incl %edi
xorl %ecx, %ecx 

continuamget:
pushl %edx
movl  omie24, %eax
mul %edi #eax*edi si rezultatul se afla in eax
movl %eax, %ebx #ebx e aproape pozitia absoluta (eax este edi*8) 
addl %ecx, %ebx #acum ebx e pozitia absoluta (edi(adica linia)*8+ecx( adica elementul de pe linie))
popl %edx
cmpb %dl, (%esi,%ebx,1)
je numarare
jne incecxget
incecxget:
incl %ecx
jmp et_get_loop
numarare:
movl %ecx, k #k e prima aparitie a elementului pe care il caut
jmp numarare_loop
numarare_loop:
incl %ecx
incl %ebx
cmpl $1025, %ecx
jge incediget2
jl continuamget2
incediget2:
incl %edi
xorl %ecx, %ecx 
continuamget2:
cmpb %dl, (%esi,%ebx,1)
je numarare_loop
jne amgasitnumarul
amgasitnumarul: 
pushl %edx   
subl $1, %ecx                 
pushl %ecx
pushl %edi
pushl k  
pushl %edi                                       
pushl $buf                    
call printf                  
addl $20, %esp               
popl %edx                      
jmp get_exit
nuexista:
pushl %edx                    
movl $0, %ecx
push %ecx  
movl %ecx, k                 
push k
pushl %ecx
pushl %ecx                        
push $buf                    
call printf                  
addl $20, %esp               
popl %edx                      
jmp get_exit
get_exit:
ret





#DEFRAGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
#(am incercat si cum e mai jos si prin a da delete si add la toate fisierele, cu conditia ca atunci cand dau add sa inceapa de la un anumit element, ca sa nu se strice ordinea)
et_defrag:
xorl %ecx, %ecx # ecx =i
xorl %edx, %edx # element abosolut pe post de j
xorl %edi, %edi
xorl %ebx, %ebx #element absolut pe post de i
shift:
cmpl $1024, %edi
jge defrag_exit
cmpl $1024, %ecx
jge incedidefrag
jl continuamdefrag
incedidefrag:
incl %edi
xorl %ecx, %ecx
continuamdefrag:
pushl %edx
movl  omie24, %eax
mul %edi #eax*edi si rezultatul se afla in eax
movl %eax, %ebx #ebx e aproape pozitia absoluta (eax este edi*8) 
movl %eax, %edx
addl %ecx, %edx #asta nu face nimic
addl %ecx, %ebx #acum ebx e pozitia absoluta (edi(adica linia)*8+ecx( adica elementul de pe linie))
popl %edx
cmpl $0x100000, %edx 
jge zero
movb (%esi,%edx,1), %al  
cmpl $0, %eax        
je incedx
movb %al, (%esi,%ebx,1)  
incl %ebx
incl %ecx           
incedx:
incl %edx         
jmp shift 
zero:
cmpl $0x100000, %ebx  
jge defrag_exit
movb $0, (%esi,%ebx,1)
incl %ebx  
jmp zero
defrag_exit:
ret





#PRINT PENTRU DEBUGGING (nu e folosit in cod)
print_loop:
xorl %edx, %edx            # COLOANE
xorl %ecx, %ecx            #ELEMENTE IN TOTAL
xorl %ebx,%ebx              
print_start:
cmpl $0x100, %ecx            
jge et_exit                
xorl %ebx, %ebx         
matrice_loop:
cmpl $20, %ebx          
jge print_newline          
movb v(,%ecx,1), %al      
pushl %ecx
pushl %edx
pushl %eax
pushl $format           
call printf              
addl $8, %esp             
popl %edx
popl %ecx
incl %ebx                 
incl %ecx
jmp matrice_loop       
print_newline:
pushl %ecx
pushl %edx
pushl $formatendline       
call printf
addl $4, %esp              
popl %edx
popl %ecx
incl %edx
jmp print_start   



#PRINT DELETE DEFRAG 
#VAD CE DESCRIPTOR E SI APOI FAC PRINT SI GET DE DESCRIPTORUL ALA
print_delete_defrag:
movl $v, %esi          
xorl %ecx, %ecx               
xorl %eax, %eax
xorl %ebx, %ebx
movl $-1, %edx
delete_defrag_loop:
cmpl $0x100000, %ebx 
jge delete_defrag_exit
movb (%esi,%ebx,1), %al 
movb (%esi,%edx,1), %cl  
cmpl $0, %eax
je next
cmpl %ecx, %eax          
jne printare
je next
printare: 
pushl %eax
movb (%esi,%ebx,1), %al #ELEMENTUL DIN VECTOR IN DESC
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
subl $1, %ebx        
next:
movl %ebx, %edx #EDX E EBX-1
incl %ebx
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