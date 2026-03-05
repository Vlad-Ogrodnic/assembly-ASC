#ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD

#LA ADD DELETE 1 AM 22 DE LA 50 LA 99 SI ADD 31 100 DE BLOCURI DECI AR TREBUI

et_add: #12 desc,d,ret,ebp,
xor %eax, %eax
pushl %ebp
mov %esp,%ebp
movl 8(%ebp),%eax #d in eax
xorl %edx, %edx
divl opt #eax=20/8=2 edx=4
movl $v, %esi
xorl %ebx,%ebx


movl %eax, %ecx 
cmpl $1024, %ecx
jg add_exit # Exit if input size exceeds buffer

#MAI AM DE ADAUGAT DACA UN ELEMENT CARE A FOST ADAUGAT DEJA INCERACA SA FIE ADAUGAT NU SE INTAMPLA NIMIC
cautare:
cmpb $0,(%esi,%ebx,1) #verifica daca al ebx lea element din v este 0 
jne incebx
je test
incebx:
incl %ebx
jmp cautare
test: 
mov %ebx,c #c e pozitia primului 0
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
cmpl $1025, %ebx
je minusunu
jne ochei
minusunu:
movl $1024, %ebx
ochei:
movl %ebx, %ecx #il mut pe ebx care e pozitia ultimului 0 in ecx
subl c, %ecx
movl %ecx, amspatiu # amspatiu=cat spatiu am la dispozitie pentru a imi pune valorile
#VERIFIC DACA MAI E VREUN 0 ORIUNDE IN VECTOR DACA MAI E SAR LA CONTINUAM DACA NU MAI E MA DUC LA BREAKPOINT
xorl %edi, %edi
pentrudelete:
cmpl $1025, %edi
jge breakpoint
cmpb $0,(%esi,%edi,1)
jne incedi
je continuam
incedi:
incl %edi
jmp pentrudelete

breakpoint:
cmpl %eax, %ecx # EAX E SIZE DOAR CA NU E CEIL E INT DE SIZE
jl add_exit
je cazspecial
cmpl %eax, %ecx # EAX E SIZE DOAR CA NU E CEIL E INT DE SIZE
jg continuam
cazspecial:
cmpl $0, %edx
jne add_exit
continuam:
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
