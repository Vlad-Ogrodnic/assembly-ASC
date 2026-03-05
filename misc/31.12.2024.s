cautare:
pushl %eax
pushl %ecx
mov opt, %eax
mul %edi
mov %eax, %ecx #acum ecx este edi*8
cmpb $0,(%esi,%ecx,1)  #verifica daca al ecx lea element din v este 0 
jne incecxadd
je ouchei
incecxadd:
popl %ecx
popl %eax

incl %ecx
incl %edx
jmp cautare
ouchei:
popl %ecx
popl %eax
movl %ecx,c #c e pozitia primului 0
e0:
#verific daca incape
cmpl $8, %ecx
jge urmlinie
jl continuam1
urmlinie:
incl %edi
mov %ecx, amspatiu
xorl %ecx, %ecx
pushl %eax
pushl %ecx
jmp amAflatSpatiu
#PLAN NOU: ECX*EDI VA FI ELEMENTUL ABSOLUT IAR ECX VA FI INTRE 0 SI 1023
continuam1:
pushl %eax
pushl %ecx
mov opt, %eax
mul %edi
mov %eax, %ecx #acum ecx este edi*8
cmpb $0,(%esi,%ecx,1)
je incecx2
jne amAflatSpatiu
incecx2:
popl %ecx
popl %eax
incl %ecx
jmp e0
amAflatSpatiu:
popl %ecx
popl %eax
pushl %edi #DE AICI PANA LA A 3 A LINIE DIN ETICHETA CONTINUAM EDI INSEAMNA ALTCEVA
movl %ecx, %edi
subl c, %ecx
movl %ecx, amspatiu # amspatiu=cat spatiu am la dispozitie pentru a imi pune valorile