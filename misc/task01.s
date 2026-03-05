et_defrag:
xorl %ecx, %ecx # ecx =i
xorl %edx, %edx # element abosolut pe post de j
xorl %edi, %edi
xorl %ebx, %ebx #element absolut pe post de i
shift:
cmpl $1024, %edi
jge defrag_exit
#jl continuamdefrag
#continuamdefrag:
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
addl %ecx, %edx
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


#DEFRAG CU ADDD SI DELETE

et_defrag: #gasesc descriptorul ultimului element diferit de 0, apoi ii dau delete, apoi ii dau add
#cerinta e facuta astfel incat ca daca eu cand fac defragmentare si nu imi incape un element intr-un spatiu pe o linie, dar urmatorul element dupa ala incape, nu il mai pun asa ca trebuie sa rezolv asta)
xorl %edx, %edx 
xorl %edi, %edi
xorl %ebx, %ebx 
xorl %eax, %eax
cautdescriptor:
xorl %ecx, %ecx 
cmpl $0x100000, %ebx
jge defrag_exit 
cmpb $0, (%esi,%ebx,1)
jne poateamgasitunul
je incebx
incebx:
incl %ebx
jmp cautdescriptor
poateamgasitunul:
subl $1, %ebx
cmpb $0, (%esi,%ebx,1)
je amgasitunul
jne namgasitunul
namgasitunul:
incl %ebx
incl %ebx
jmp cautdescriptor
amgasitunul:
addl $1, %ebx
movb (%esi,%ebx,1), %al
movb %al, x(,%edx,1)
incl %edx
movb %al, descriptordefrag
amgasit_loop:
incl %ebx
cmpb %al, (%esi,%ebx,1)
je size
jne amgasitsize
size:
incl %ecx #counter pt marimea descriptorului
jmp amgasit_loop
amgasitsize: #ONYL IF THERE IS A SPACE OF 0S RIGHT BEFORE #ACTAUULYY STILL DOES NOT WORK BECAUSE WHAT IF THERE IS A SPACE OF 0S THTAS NOT BIG ENOUGHT O FIT BUT THERE IS ANOTHER ONE EARLIER ONE THAT IS BIG ENOUGH
incl %ecx #size
pushl %edx
pushl %ebx
pushl %ecx
pushl %eax
call et_delete 
addl $4, %esp
popl %ecx
popl %ebx
pushl descriptordefrag
pushl %ecx #size
call add_defrag
addl $8, %esp
popl %edx
jmp cautdescriptor
defrag_exit:
ret





#ADDD
pushl %ecx
pushl %edx
movl $1, %ecx
pentru_defrag:
cmpb $0, x(,%ecx,1)
je add_rest0
movl 12(%ebp),%edx
cmpb %dl, x(,%ecx,1)
je add_exit
jne incecxadd3
incecxadd3:
incl %ecx
jmp pentru_defrag

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

cmpl $1024, %edx
je cazspecial
jne mda
cazspecial: #CAND ADAUG CEVA ADAUG LA URMATOARE LINIE DACA NU ARE LOC PE LINIA PRECEDENTA SI GATA
pushl %edx #1024
pushl %ecx #va fi un counter
xorl %ecx, %ecx
subl %ebx, %edx
movl %edx, amspatiud #cat spatiu am de 0 pe linia respectiva
addl %ebx, %edx
cazspecial_loop:
cmpb %al , (%esi, %edx,1)
je numaram
jne aflatsize
numaram: #numar lungimea de primul descriptor
incl %ecx
incl %edx
jmp cazspecial_loop
aflatsize:
cmpl amspatiud, %ecx
jg caznormal
jle cazanormal
cazanormal:
popl %ecx
popl %edx
jmp mda 
caznormal:
popl %ecx
popl %edx
incl %edi
xorl %ecx, %ecx
movl $1024, %ebx
mda:


subl %ecx, omIe24
movl omIe24, amspatiud #cat spatiu am pe linia respectiva
pushl %edx



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


#PRINT PENTRU DEBUGGING
print_loop:
xorl %edx, %edx            # COLOANE
xorl %ecx, %ecx            #ELEMENTE IN TOTAL
xorl %ebx,%ebx              # INTRE 0 SI 7
print_start:
    cmpl $260, %ecx            
    jge et_exit                
    xorl %ebx, %ebx         

matrice_loop:
    cmpl $8, %ebx          
    jge print_newline          

    movb v(,%ecx,1), %al      
    pushl %ecx
    pushl %edx
    pushl %eax
    pushl $format           
    call printf              
    addl $8, %esp             
    popl %edx

















et_defrag:
xorl %ecx, %ecx # ecx =i
xorl %edx, %edx # element abosolut pe post de j
xorl %edi, %edi
xorl %ebx, %ebx #element absolut pe post de i
movl linia, %edi
#movl elementul, %ecx
shift:
cmpl $1024, %edi
jge defrag_exit
#jl continuamdefrag
#continuamdefrag:
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
addl %ecx, %edx
addl %ecx, %ebx #acum ebx e pozitia absoluta (edi(adica linia)*8+ecx( adica elementul de pe linie))
popl %edx
cmpl $0x100000, %edx 
jge zero
cmpl $0x100000, %ebx 
jge zero
#compar linia pe care e ebx cu cea pe care e edx, daca sunt la fel e ok, daca nu trec mai departe
comaprlinie:
pushl %ebx
shr $10, %ebx
movl %ebx, linieebx
popl %ebx
pushl %edx
shr $10, %edx
movl %edx, linieedx
cmpl linieebx, %edx # %edx e linieedx aici pt ca inca nu i-am dat pop
jg inclinieebx
je ok2
inclinieebx:
pushl %eax
movl %ebx, %eax
movl $0, %edx
divl omie24 #catul e in eax(adica linia pe care sunt)restul e in edx
incl %eax
mul %edi
movl %eax, %ebx #acum ebx e primul element de pe aceasi linie ca si edx
popl %eax

popl %edx
movl %ebx, %edx
pushl %edx

ok2:
popl %edx
movb (%esi,%edx,1), %al  
movzbl %al, %eax   
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
movl %edi, linia
#movl %ecx, elementul
ret



































































et_defrag:
xorl %ecx, %ecx # ecx =i
xorl %edx, %edx # element abosolut pe post de j
xorl %edi, %edi
xorl %ebx, %ebx #element absolut pe post de i #movl linia, %edi
shift:
cmpl $1024, %edi
jge defrag_exit
#jl continuamdefrag
#continuamdefrag:
cmpl $1024, %ecx
jge incedidefrag
jl continuamdefrag
incedidefrag:
incl %edi
xorl %ecx, %ecx
movl %edx, %ebx
continuamdefrag:
pushl %edx
movl  omie24, %eax
mul %edi #eax*edi si rezultatul se afla in eax
movl %eax, %ebx #ebx e aproape pozitia absoluta (eax este edi*8) 
movl %eax, %edx
addl %ecx, %edx
addl %ecx, %ebx #acum ebx e pozitia absoluta (edi(adica linia)*8+ecx( adica elementul de pe linie))
popl %edx
cmpl $0x100000, %edx 
jge zero
movb (%esi,%edx,1), %al  
cmpl $0, %eax        
je incedx 
#CAND ADAUG CEVA ADAUG LA URMATOARE LINIE DACA NU ARE LOC PE LINIA PRECEDENTA SI GATA
#acum sunt pe oricare element, nu neaparat 1024 ca inainte
amincercat:
pushl %ebx #de aici ebx e counter pt cati de 0 am pe linie
pushl %eax
movl %ecx, %ebx
cmpl $0, (%esi,%ebx,1)
je numaram
numaram:
movl %ebx, c2 
numaram_loop:
cmpl $0, (%esi, %ebx,1)
je incebx2
jne ok3
incebx2:
incl %ebx
jmp numaram_loop
amaflat:
movb (%esi, %ebx,1), %al
movl %ebx, primuldesc
subl c2, %ebx #acum ebx e cati de 0 am 
movl %ebx, catide0
addl c2, %ebx
cmpb %al, (%esi, %ebx,1)
je numardesc
numardesc:
cmpb %al, (%esi, %ebx,1)
je incebx3
jne amaflattot
incebx3:
incl %ebx 
jmp numardesc
amaflattot:
subl primuldesc, %ebx #acum ebx e lungimea primului descriptor diferit de 0
cmpl catide0, %ebx
jg urmatoarealinie
jle ok3
urmatoarealinie:
incl %edi
xorl %ecx, %ecx
pushl %eax
mul %edi
movl %eax, %ebx
popl %eax
popl %ebx
popl %eax
jmp shift
ok3:
popl %ebx
popl %eax
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
jge add_exit
movl 8(%esp),%edx #desc in edx 
addb %dl, (%esi,%ecx,1)
incl %ecx
jmp add_rest0d
add_defrag_exit:
ret




































































add_defrag:
et_addd: #12 desc,d,ret,ebp,
xorl %eax, %eax
xorl %edi, %edi 
pushl %ebp
mov %esp,%ebp
movl 8(%ebp),%eax #d in eax
xorl %edx, %edx
divl opt #eax=20/8=2 edx=4
cmpl $0, %edx
jne inceaxd
je maideparted
inceaxd:
addl $1, %eax
maideparted:
movl $v, %esi

cmpl $1025, %eax
jge add_defrag_exit

xorl %ecx,%ecx #intre 0 si 7
xorl %edx, %edx 
xorl %ebx, %ebx #intre 0 si (1024^2)-1

cautared: #aici caut primul 0
cmpl $1024, %ecx
jge incedid
jl continuam1d
incedid:
incl %edi
xorl %ecx, %ecx
continuam1d:

pushl %eax
movl  omie24, %eax
mul %edi #eax*edi si rezultatul se afla in eax
movl %eax, %ebx #ebx e aproape pozitia absoluta (eax este edi*8) 
addl %ecx, %ebx #acum sper ca ebx e pozitia absoluta (edi(adica linia)*8+ecx( adica elementul de pe linie))
popl %eax
cmpl undesunt, %ebx
cmpb $0,(%esi,%ebx,1)  #verifica daca al ebx lea element din v este 0
jne incecxaddd
je oucheid
incecxaddd:
incl %ecx
jmp cautared


oucheid:
movl %ecx, c #c e pozitia neabsoluta a primului 0
e0d: #verific daca incape
cmpl $1024, %ecx
jge amAflatSpatiud
jl continuam2d
continuam2d:
pushl %eax
movl  omie24, %eax
mul %edi #eax*edi si rezultatul se afla in eax
movl %eax, %ebx #ebx e aproape pozitia absoluta (eax este edi*8) 
addl %ecx, %ebx #acum sper ca ebx e pozitia absoluta (edi(adica linia)*8+ecx( adica elementul de pe linie))
popl %eax
cmpb $0,(%esi,%ebx,1)  #verifica daca al ebx lea element din v este 0
je incecxadd2d
jne amAflatSpatiud
incecxadd2d:
incl %ecx
jmp e0d
amAflatSpatiud: 
pushl %edi
movl %ecx, %edi
subl c, %ecx #scad primul 0 din ultimul 0 ca sa aflu cati de 0 am liberi 
movl %ecx, amspatiu
addl c, %ecx #il adaug la loc pt ca imi trebui pozitia ultimului 0 in cazul in care nu am spatiu si vreau sa vad la ce element am ajuns
cmpl amspatiu, %eax
jg popedi2d
jle pentrudeleted
popedi2d:
popl %edi
jmp cautared


pentrudeleted:
cmpl $0x100000, %edi
jge nuamlocd
cmpb $0,(%esi,%edi,1)
jne incedi3d
je continuamd
incedi3d:
incl %edi
jmp pentrudeleted

nuamlocd:
cmpl amspatiu, %eax # pentru cand nu incape
jg popedid
jle continuamd
popedid: 
popl %edi
jmp add_defrag_exit

continuamd:
movl %edi, %ecx #daca nu folosesc edi imi da segmentation fault cand ii dau run normal dar merge perfect daca ii dau din debugger
popl %edi
cmpl amspatiu, %eax
jle okd
jg cautared
okd:
pushl %eax
movl  omie24, %eax
mul %edi #eax*edi si rezultatul se afla in eax
movl %eax, %ebx #ebx e aproape pozitia absoluta (eax este edi*8) 
addl c, %ebx #acum  ebx e pozitia absoluta de unde incep sa adaug
popl %eax
movl %ebx, %ecx
addl %ecx, %eax
add_rest0d:
cmpl %eax, %ecx
jge add_defrag_exit
movl 12(%ebp),%edx #desc in edx 
addb %dl, (%esi,%ecx,1)
incl %ecx
jmp add_rest0d
add_defrag_exit:
popl %ebp
ret
