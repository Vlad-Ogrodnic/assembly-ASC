#ADDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD

#LA ADD DELETE 1 AM 22 DE LA 50 LA 99 SI ADD 31 100 DE BLOCURI DECI AR TREBUI

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
xorl %ebx, %ebx
movl %ecx, %ebx
subl c, %ebx
movl %ebx, amspatiu # amspatiu=cat spatiu am la dispozitie pentru a imi pune valorile



pentrudelete:
cmpl $1024, %ecx
jge nuamloc
cmpb $0,(%esi,%ecx,1)
jne incedi
je continuam
incedi:
incl %ecx
jmp pentrudelete

nuamloc:
cmpl %ecx, %eax # pentru cand nu incape
jg add_exit

continuam:
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