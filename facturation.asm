global _start

SECTION .bss 
	input: resb 64
	temp_aux: resb 4
	temp_total: resb 0x8
	montant_remise: resb 0x8
	total_avant_remise: resb 0x8
	total: resb 0x8
	result_buffer: resb 0x8
	temp: resb 64 ; memorie temporara, pentru operatii, conversii sau uz in caz de lipsa de registri
	barman: resb 64 ; 64 de caractere pentru numele barmanului
	lungime_rand: resb 8

SECTION .data 
	aerisire_sfarsit: db " ", 0xA, 0xA, 0xA   ; pentru a printa cateva caractere de \n la sfarsit
	cantitate_bauturi: dq 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 999    ; acest 999 este un '\0' artifical pentru a marca sfarsitul listei
	lungimi: dq 0x6, 0x7, 0x8, 0x6, 0x4, 0x6, 0x3, 0x5, 0x7      ; fiecare index are 8 bytes (offset din  8 in 8
	texte_aide: db 0x00,0x00, 0xA, "[Facturation]    Manuel d'utilisation", 0xA, 0xA, 0xA, "h          Affiche le menu d'aide.", 0xA, "l          Liste de toutes les boissons disponibles au bar.", 0xA, "a          Permet d'ajouter une boisson à la facture du client.",0xA, "f          Génère la facture.", 0xA, "q          Quitter le programme.", 0xA, 0xA
	ricard: db 'Ricard', 0x00
         ; valoarea care se va afisa cand dam comanda "d"
	pastis: db 'Pastis', 0x00
	vin: db 'Vin', 0x00
	whiskey: db 'Whiskey', 0x00
	calva: db 'Calvados', 0x00
	coniac: db 'Coniac', 0x00
	biere: db 'Biere', 0x00
	cafe: db 'Cafe', 0x00
	casanis: db 'Casanis', 0x00
	prix: dq 0x2, 0x6, 0x5, 0x2, 0x1, 0x6, 0x3, 0x3, 0x2         ;     array unde stocam preturile sub forma de INT
	lista_bauturi: dq pastis, whiskey, calva, ricard, cafe, coniac, vin, biere, casanis, 0
	nl: db 0xA
	ansi_lineup: db 0x1B,'[A', 0x00
	ansi_verde: db 0x1B, '[32m',0x00
	ansi_bold: db 0x1B,'[1m',0x00
	ansi_italic: db 0x1B, '[3m',0x00
	ansi_reverse: db 0x1B, '[7m', 0x00
	ansi_screen_update: db 0x1B, '[2J', 0x1B, '[H', 0x00
	ansi_reset: db 0x1B, '[0m', 0x00
	egal: db "="
	doua_puncte :db ": "
	tilda: db "~ "
	underscore: db "_" ; ci-contre figurent les caracteres pour l'affichage de la grille structurelle du programme
	texte_pastis_facturation: db 0xA, 0xA, "Terminal Basic: [Facturation] Le Bistrot du Peintre",0xA    ; texte introductif 
	copyright: db "Copyright (c) 1978,1979,1980 Hewlett-Packard, Inc. Tous droits réservés.",0xA 
	unite: db "Unité 88 | SNID 840726", 0xA; texte introductif 
	texte_barman: db "Barman: "
	pret: db "[stdout]: Prêt pour un numéro d’option ou une commande.", 0xa, 0xa, 0xa
	main_prompt: db "[stdout]: $ "
	quit: db "q",0x00
	list: db "l", 0x00
	addd: db "a", 0x00
	ajouter: db 0xA,"[Ajouter] Verre: ", 0x00
	quantite: db 0xA, "[Ajouter] Quantité: ", 0x00
	ngasit: db "non!", 0xA, 0xA
	texte_facturation: db "           [Facture]", 0x00
	facturation_temporaire: db "Facturation.", 0xa, 0xa
	aucune_donnee: db "Aucune donnée.", 0xa, 0xa
	h_char: db "h"
	d_char: db "d"
	f_char: db "f"
	dot_char: db "."
	proc_char: db "%.", 0x00
	times_string: db " X ", 0
	space: db " "
	nlnl: db 0xA, 0xA
	consommation_client: db 0xA, "Consommation Client: ", 0xA, 0xA
	texte_total_temporaire: db "[Total temporaire]: ", 0x00
	texte_total: db "[Total]", 0x00
	delay_inceput: dq 2, 0       ;    2 secunde, 0 nanosecunde
	spatiu: db "                      ", 0   ;    pentru aliniere, formula magica dar functioneaza
	texte_pourcentage: db 0xA, "Appliquer une éventuelle remise: ", 0x00
	prix_final: db "Remise de ", 0x00
	definitif: db "[Final]", 0x00
		
SECTION .text 
	int_to_string:
	    xor r15, r15
	    mov rbx, 10          
	    xor rcx, rcx        
	    
	    convert_loop:
		xor rdx, rdx         
		div rbx              
		add dl, '0'          
		inc r15
		mov [rdi + rcx], dl  
		inc rcx              
		test rax, rax       
		jnz convert_loop     
	    
		mov byte [rdi + rcx], 0
	   
		mov rsi, rdi         
		lea rdi, [rdi + rcx - 1] 
	    
	    reverse_loop:
		cmp rsi, rdi         
		jge done_reverse     

mov al, [rsi]
		mov bl, [rdi]
		mov [rsi], bl
		mov [rdi], al
		inc rsi              
		dec rdi             
		jmp reverse_loop

	    done_reverse:
		ret
		

	str_to_int:                     ; conversie str la int
		xor rax, rax      ; aici avem valoare de retur
		xor rcx, rcx     
		mov rbx, 10         ;    pentru conversie

		bucla_conversie:
			movzx rdi, byte [rsi]
			test rdi, rdi 
			jz conversie_terminata

			sub rdi, '0'
			imul rax, rbx
			add rax, rdi

			inc rsi
			jmp bucla_conversie

		conversie_terminata:
			ret



	delay:               ; functie de delay
		mov rax, 35
		lea rdi, [delay_inceput]
		xor rsi, rsi
		syscall

		ret


	draw_borders:
		xor rbx, rbx ; avem contor pentru for in rbx 
		
		mov rdi, nl   ; printam un  \n pentru a separa de restul programului
		call print_char


		; pentru banda de =, setam culorile la reverse 

		mov rax, 1
		mov rdi, 1
		mov rsi, ansi_reverse
		mov rdx, 5
		syscall

		bucla_afisare:  ; facem o bucla separata, altfel ne arunca un infinite loop din cauza la xor rbx 
			mov rdi, egal
			call print_char
			inc rbx 
			cmp rbx, 80 ; numarul de caractere egal pe care il vreau 
			jl bucla_afisare

		
		ret 

	update:   ; label pentru a goli ecranul
		mov rax, 1
		mov rdi, 1
		mov rsi, ansi_screen_update
		mov rdx, 5
		syscall
		
		ret 

	reset_visual:
		; resetam totul, si dupa dam call la visual ca sa avem textul verde dar background negru din nou
		
		mov rax, 1
		mov rdi, 1
		mov rsi, ansi_reset
		mov rdx, 5
		syscall
		
		ret 

	visual:    ; tot ce tine de aspectul '80 a programului
		
		mov rax, 1   
		mov rdi, 1 
		mov rsi, ansi_verde
		mov rdx, 5
		syscall     ; schimbam culoarea textului in verde
		
		mov rax, 1   
		mov rdi, 1 
		mov rsi, ansi_bold
		mov rdx, 5
		syscall 
		ret 



	print_char:   ; functie pentru a printa un singur char 
		push rbp 
		mov rbp, rsp

		mov rax, 1
		mov rsi, rdi
		mov rdi, 1
		mov rdx, 1
		syscall

		pop rbp
		ret 
	
	afisare_text_introductiv:
		
		call draw_borders

		call reset_visual ; resetam visual la default green 
		call visual
		
	
		mov rax, 1
		mov rdi, 1
		mov rsi, ansi_italic  ; il facem si italic pentru textul de bunvenit
		mov rdx, 5
		syscall

		mov rdi, nl ; afisam un \n la sfarsit 
		call print_char
		
		; printam textul de bunvenit

		mov rax, 1
		mov rdi, 1
		mov rsi, texte_pastis_facturation
		mov rdx, 153
		syscall
		

		mov rdi, nl 
		call print_char ; aerisire
		call print_char
		
		call reset_visual ; sa scoatem italic 
		call visual

		ret
	gata:

		mov rax, 1
		mov rdi, 1
		mov rsi, aerisire_sfarsit
		mov rdx, 2
		syscall

		mov rax, 60
		mov rdi, 51     ; exit code PASTIS 51
		syscall
	

	choix_barman:
		mov rax, 1
		mov rdi, 1
		mov rsi, texte_barman
		mov rdx, 8
		syscall 
		
		mov rax, 0       ; setam in memorie cine e barman 
		mov rdi, 0
		mov rsi, barman
		mov rdx, 64
		syscall

		mov rdi, nl
		call print_char    ; aerisire
		call print_char

		ret
	
	afisare_barman:
		mov rax, 1
		mov rdi, 1
		mov rsi, texte_barman  ; afisam Barman: 
		mov rdx, 8
		syscall

		mov rax, 1     ; se afiseaza numele lui, care a fost introdus la inceput 
		mov rdi, 1
		mov rsi, barman
		mov rdx, 64
		syscall

		mov rdi, nl
		call print_char

		ret 



	afisare_bauturi:
		
		; prolog de functii obisnuit, manipulare ansi in mare parte

		call update     ; dam refresh la ecran cu ansi 
		
		call visual     ; dam draw la vizual din nou cu ansi 

		call afisare_text_introductiv    ; afisam textul de la inceput
		
		call afisare_barman      ; afisam numele barmanului


		mov rax, 1
		mov rdi, 1
		mov rsi, texte_aide    ; printare mesaj autor (de implementat)
		mov rdx, 269
		syscall
		
		call draw_borders

		call reset_visual

		call visual	

		mov rdi, nl
		call print_char
		
		mov rax, 1
		mov rdi, 1
		mov rsi, nlnl
		mov rdx, 2
		syscall

		
		xor r8, r8 ; aici avem offset, trebuie sarit din byte in byte pentru urmatorul index
		lea rcx , [lista_bauturi]

		parcurgere_bauturi:
			
			mov rsi, [rcx+r8]
			cmp rsi, 0
			je efectuat

			push rcx    ; le salvam pe stack pentru ca avem nevoie de ele mai tarziu
			push rsi 

			mov rax, 1 
			mov rdi, 1
			mov rsi, ansi_reverse     ;  inversam culorile 
			mov rdx, 5
			syscall

			mov rax, 1
			mov rdi, 1
			mov rsi, tilda      ; printam si un tilda (aspect batranesc)
			mov rdx, 1          ; doar un caracter, printam spatiu separat pentru ca altfel se coloreaza si spatiu (nu vrem asta)
			syscall

			call reset_visual    ; resetam ansi 
			call visual          ; si apelam din nou modificarile vizuale uzuale definite pentru program
			
			mov rdi, space
			call print_char

			; continuam cu afisarea bauturilor dar fara cantitati
			
			pop rsi
			pop rcx   ; il salvasem pentru ca aveam syscall 




			xor rdx, rdx  ; lungime string
			
			bucla:
				lodsb 
				inc rdx
				cmp al, 0
				jne bucla  ; calculam lungime string
			
			mov rax, 1
			mov rdi, 1
			mov rsi, [rcx+r8] 
			
			push rcx ; syscall modifica rcx, dar noi avem nevoie pentru pointer catre lista de bauturi

			syscall

			mov rdi, nl
			call print_char
			
			pop rcx 

			add r8, 8  ; index urmator 
			jmp parcurgere_bauturi
				
		efectuat:
			mov rdi, nl
			call print_char   ; aerisire

			ret 

	listt:
		mov rdi, nl
		call print_char    ; functia ca sa afisam lista de bauturi

		call afisare_bauturi
		jmp master_loop


	adaugare:

		; prolog de functii obisnuit, manipulare ansi in mare parte

		call update     ; dam refresh la ecran cu ansi 
		
		call visual     ; dam draw la vizual din nou cu ansi 

		call afisare_text_introductiv    ; afisam textul de la inceput
		
		call afisare_barman      ; afisam numele barmanului


		mov rax, 1
		mov rdi, 1
		mov rsi, texte_aide    ; printare mesaj autor (de implementat)
		mov rdx, 269
		syscall
		
		call draw_borders

		call reset_visual

		call visual	

		mov rdi, nl
		call print_char
		
		mov rax, 1
		mov rdi, 1
		mov rsi, nlnl
		mov rdx, 2
		syscall


		
		mov rax, 1
		mov rdi, 1
		mov rsi, ajouter ; textul care cere input
		mov rdx, 19
		syscall


		; cerem input 

		mov rax, 0
		mov rdi, 0       
		mov rsi, input     ; folosim input pentru ca vom folosi temp buffer mai jos 
		mov rdx, 32
		syscall

		; aici urmeaza logica serioasa

		xor r8, r8     ; ca de obicei, in r8 avem offset pentru parcurgere array 
		lea rdx, [lista_bauturi]
		lea r9, [lungimi]      ; array care contine lungimea fiecarui element din lista_bauturi 
		
		incercare:

			mov rsi, input
			mov rdi, [rdx+r8]    ; lista_bauturi + offset 
			cmp rdi, 0      ; am ajuns la null terminator de la array, nu s-a gasit bautura respectiva
			je not_found  
			mov rcx, [r9+r8]     ;  lungimi_ stringuri + offset 

			mov rsi, input
			repe cmpsb
			
			je found  ;    s-a gasit bautura respectiva
			add r8, 8
			jmp incercare     ; incercam din nou la urmatorul index al vectorului
	

		not_found:
			mov rax, 1
			mov rdi, 1
			mov rsi, ngasit    ; cazul in care bautura nu a fost gasita 
			mov rdx, 6
			syscall
			
			jmp master_loop    ; sarim din nou in master loop

		found:
					
			push r8       ; aici avem locatia bauturii care a fost gasita



			mov rax, 1
			mov rdi, 1
			mov rsi, quantite     ; afisare mesaj ca a fost gasit 
			mov rdx, 22
			syscall

			mov rax, 0
			mov rdi, 0             ; aici avem ce cantitate trebuie sa adaugam 
			mov rsi, temp
			mov rdx, 4
			syscall
				
			pop r8

			
			; acum urmeaza conversia de la string la int pentru temp


			
			mov byte [rsi+rax-1], 0     ; dam null terminate la string indiferent de lungimea lui		
			call str_to_int        

			; in rax avem cate bauturi trebuie sa adaugam sub format de int 

			lea rcx, [cantitate_bauturi]
			mov rdi, [rcx+r8]

			add rax, rdi    ; in rdi avem numarul de bauturi final
			mov [result_buffer], rax        

			lea rdx, [result_buffer]
			mov [rcx+r8], rax      ; si il mutam la adresa de memorie in array + offset din r8

			; pare ca merge pana aici ( trebuie testat )
			
			
			mov rdi, nl         ; aerisire
			call print_char


			jmp master_loop
	

	ajutor:
		; prolog de functii obisnuit, manipulare ansi in mare parte

		call update     ; dam refresh la ecran cu ansi 
		
		call visual     ; dam draw la vizual din nou cu ansi 

		call afisare_text_introductiv    ; afisam textul de la inceput
		
		call afisare_barman      ; afisam numele barmanului


		mov rax, 1
		mov rdi, 1
		mov rsi, texte_aide    ; printare mesaj autor (de implementat)
		mov rdx, 269
		syscall
		
		call draw_borders

		call reset_visual

		call visual	

		mov rdi, nl
		call print_char
		
		mov rax, 1
		mov rdi, 1
		mov rsi, nlnl
		mov rdx, 2
		syscall


		mov rax, 1
		mov rdi, 1
		mov rsi, pret       ; programul este gata sa accepte comenzi 
		mov rdx, 61
		syscall
		
		mov rdi, nl
		call print_char

		jmp master_loop      ; sarim din nou in master loop


	display:
		; prolog obisnuit de functii, ca sa fie aspectul batranesc
			
		xor rdx, rdx
		mov [temp_total], rdx
		mov rdx, 1


		call update     ; dam refresh la ecran cu ansi 
		
		call visual     ; dam draw la vizual din nou cu ansi 

		call afisare_text_introductiv    ; afisam textul de la inceput
		
		call afisare_barman      ; afisam numele barmanului


		mov rax, 1
		mov rdi, 1
		mov rsi, texte_aide    ; printare mesaj autor 
		mov rdx, 269
		syscall
		
		call draw_borders

		call reset_visual      ; vizual ansi

		call visual	

		mov rax, 1
		mov rdi, 1
		mov rsi, nlnl
		mov rdx, 2
		syscall

		

		mov rax, 1
		mov rdi, 1
		mov rsi, consommation_client     ; imprimam titlul "Consommation client: "
		mov rdx, 24
		syscall
 

		lea rcx, [cantitate_bauturi]     ; aci avem cantitatile consumate 
		lea r12, [lista_bauturi]         ; avem in r12 numele bauturilor 
		lea r14, [lungimi]               ; aci avem lungimile stringurilor din lista_bauturi (r12)
	
		xor r8, r8        ; offset pentru diversii vectori
		
		xor r13, r13      ; contor pentru numar de bauturi la care exista consum. Daca e 0, afisam "Aucune donnée"
		

		afisam_unde_nui_zero:
			
			mov rsi, [rcx+r8]
			cmp rsi, 999                    ; stocam totul sub forma de int, si cum sunt 0 la inceput, cauzeaza probleme
			je terminat                     ; 999 e un fel de null terminator artificial

			; verificam aici sa nu fie 0, latfel nu avem nevoie sa afisam bautura respectiva (consum inexistent)

			xor r9, r9

			cmp rsi, 0
			je consum_inexistent_bautura      ; daca clientul nu a comandat bautura respectiva, nu are rost sa-l printam la consum client 
			
			
			; daca se ajunge aici, exista consum 
			; avem nevoie de valorile astea pentru mai jos in functie, anume lista cantitatea de bauturi (rcx) 			
			
			inc r13     ;   incrementam contorul de bauturi la care exista consum
			push rcx 
			push rsi    ; cantitatea de bautura 

			mov rax, 1 
			mov rdi, 1
			mov rsi, ansi_reverse     ;  inversam culorile 
			mov rdx, 5
			syscall

			mov rax, 1
			mov rdi, 1
			mov rsi, tilda      ; printam si un tilda (aspect batranesc)
			mov rdx, 1          ; doar un caracter, printam spatiu separat pentru ca altfel se coloreaza si spatiu (nu vrem asta)
			syscall

			call reset_visual    ; resetam ansi 
			call visual          ; si apelam din nou modificarile vizuale uzuale definite pentru program
			
			mov rdi, space
			call print_char

	
			mov rax, 1
			mov rdi, 1
			mov rsi, [r12+r8]      ;    aici se afla numele bauturii
			mov rdx, [r14+r8]      ;    aici se afla lungimea stringului cu numele bauturii
			syscall
			
			mov rax, 1
			mov rdi, 1
			mov rsi, doua_puncte     ; printam doua puncte, urmate de cantitate (cod mai jos)
			mov rdx, 2
			syscall
			
			pop rsi
			pop rcx 
							
			;     inceput conversie 

			
			; in rsi avem cantitatea

			lea r9, [prix]
			mov r11, [r9+r8]    ; aici avem pretul => trebuie facut total = total+r11*rsi
			
			; pret in r11 OK

			mov rax, [rcx+r8]       ;   aici avem valoarea pe care vrem sa o convertim la un string (pentru a o printa)
			push rax 
			
			mul r11     ; avem rezultatul in rax 

			
			mov r15, [temp_total]
			add r15, rax
			mov [temp_total], r15


			pop rax       ; resincronizam valorile de pe stiva
			push rcx   

			mov rdi, result_buffer     ; aici va fi numarul sub forma de string
			mov rbx, 10      ; pentru conversie
			mov rcx, rdi

			xor r15, r15    ; aici avem lungimea stringului, pentru a-l printa
			
			
			bucla_conv:
				xor rdx, rdx
				div rbx

				add dl, '0'
				mov [rdi], dl
				inc rdi 
				inc r15      ; incrementam lungimea stringului
				test rax, rax
				jnz bucla_conv

				mov rsi, rdi 
				dec rsi
				mov byte [rdi], 0   ; dam null terminate la string, foarte important

				rev:
					cmp rcx, rsi
					jge conv_terminata
					mov al, [rcx]
					mov bl, [rsi]
					mov [rcx], bl
					mov [rsi], al
					inc rcx 
					dec rsi
					jmp rev 

			conv_terminata:
	
				mov rax, 1
				mov rdi, 1
				mov rsi, result_buffer
				mov rdx, r15
				syscall
				
				mov rdi, nl
				call print_char
				

				pop rcx        ;   adresa de memorie pe care se bazeaza iteratia 
  
			

				add r8, 8  ; index urmator 
				jmp afisam_unde_nui_zero


		terminat:

				
			cmp r13, 0       ; daca nu e consum la nicio bautura, atunci afisam "aucune donnee"
			je afisare_aucune_donnee 	
			
			mov rdi, nl      ;  linie noua doar daca exista consum, altfel e prea multa aerisire si e urat
			call print_char


			; aici se afiseaza totalul (calculat anterior) 


			mov rax, 1
			mov rdi, 1
			mov rsi, texte_total_temporaire
			mov rdx, 20
			syscall
			

			
			mov rax, [temp_total]     
			mov rdi, result_buffer      ;    conversie int la string pentru a printa valoarea
			call int_to_string
		
			mov rsi, result_buffer
			mov rdi, 1
			mov rax, 1
			mov rdx, r15
			syscall
			

			mov rdi, f_char     ; f de la franci
			call print_char

			mov rax, 1
			mov rdi, 1    
			mov rsi, nlnl        ; aerisire
			mov rdx, 2
			syscall
			

			jmp master_loop       ; sarim la loc in bucla principala

		
		afisare_aucune_donnee:    ; afisam "aucune donnee"
			
			mov rax, 1
			mov rdi, 1
			mov rsi, aucune_donnee      
			mov rdx, 17
			syscall

			jmp master_loop
	
	
	consum_inexistent_bautura:
		add r8, 8                                       ;   label daca nu exista consum la o bautura respectiva
		jmp afisam_unde_nui_zero                   ; incremenetam offsetul cu 8 si sarim din nou in bucla mare
		
	

	facturation:                  ; functionalitate principala a aplicatiei
		

		; prolog obisnuit de vizual	
		
		call update     ; dam refresh la ecran cu ansi 
		
		call visual     ; dam draw la vizual din nou cu ansi 

		xor rbx, rbx ; avem contor pentru for in rbx 
		
		mov rdi, nl   ; printam un  \n pentru a separa de restul programului
		call print_char


		; pentru banda de =, setam culorile la reverse 

		mov rax, 1
		mov rdi, 1
		mov rsi, ansi_reverse
		mov rdx, 5
		syscall

		buclaa_afisare:  ; facem o bucla separata, altfel ne arunca un infinite loop din cauza la xor rbx 
			mov rdi, egal
			call print_char
			inc rbx 
			cmp rbx, 30 ; numarul de caractere egal pe care il vreau 
			jl buclaa_afisare


		call reset_visual      ;resetam 

		call visual

		mov rax, 1
		mov rdi, 1
		mov rsi, nlnl
		mov rdx, 2
		syscall


		mov rax, 1
		mov rdi, 1
		mov rsi, texte_facturation
		mov rdx, 21
		syscall

		mov rax, 1
		mov rdi, 1
		mov rsi, nlnl
		mov rdx, 2
		syscall

		call afisare_barman    ; afisam si barmanul 

		mov rdi, nl
		call print_char
		
		xor rdx, rdx          		 ; mutam 0 in variabila total sub forma de INT
		mov [total], rdx		 
						
         	; mutam 0 in variabila total sub forma de STRING




		lea rcx, [cantitate_bauturi]     ; aci avem cantitatile consumate 
		lea r12, [lista_bauturi]         ; avem in r12 numele bauturilor 
		lea r14, [lungimi]               ; aci avem lungimile stringurilor din lista_bauturi (r12)
	
		xor r8, r8        ; offset pentru diversii vectori
		
		xor r13, r13      ; contor pentru numar de bauturi la care exista consum. Daca e 0, afisam "Aucune donnée"
		

		afisam_unde_nui_zeroo:
			mov rdx, 18
			mov [lungime_rand], rdx

			mov rsi, [rcx+r8]
			cmp rsi, 999                    ; stocam totul sub forma de int, si cum sunt 0 la inceput, cauzeaza probleme
			je terminatt                     ; 999 e un fel de null terminator artificial

			; verificam aici sa nu fie 0, latfel nu avem nevoie sa afisam bautura respectiva (consum inexistent)

			xor r9, r9

			cmp rsi, 0
			je consum_inexistent_bauturaa      ; daca clientul nu a comandat bautura respectiva, nu are rost sa-l printam la consum client 
			
			
			; daca se ajunge aici, exista consum 
			; avem nevoie de valorile astea pentru mai jos in functie, anume lista cantitatea de bauturi (rcx) 			
			
			inc r13     ;   incrementam contorul de bauturi la care exista consum
			push rcx 
			push rsi    ; cantitatea de bautura 

			mov rax, 1 
			mov rdi, 1
			mov rsi, ansi_reverse     ;  inversam culorile 
			mov rdx, 5
			syscall

			mov rax, 1
			mov rdi, 1
			mov rsi, tilda      ; printam si un tilda (aspect batranesc)
			mov rdx, 1          ; doar un caracter, printam spatiu separat pentru ca altfel se coloreaza si spatiu (nu vrem asta)
			syscall

			call reset_visual    ; resetam ansi 
			call visual          ; si apelam din nou modificarile vizuale uzuale definite pentru program
			
			mov rdi, space
			call print_char

	
			mov rax, 1
			mov rdi, 1
			mov rsi, [r12+r8]      ;    aici se afla numele bauturii
			mov rdx, [r14+r8]      ;    aici se afla lungimea stringului cu numele bauturii
			syscall
			

			mov rdi, space
			call print_char

	
			
			pop rsi
			pop rcx 
							
			;     inceput conversie 

			
			; in rsi avem cantitatea

			lea r9, [prix]
			mov r11, [r9+r8]    ; aici avem pretul => trebuie facut total = total+r11*rsi
			
			; pret in r11 OK

			mov rax, [rcx+r8]       ;   aici avem valoarea pe care vrem sa o convertim la un string (pentru a o printa)
			push rax 

			cmp rax, 10
			jge spatiu_minus
			
			restttt:
				mul r11     ; avem rezultatul in rax 

				mov [temp_total], rax        ; punem in temp rezultatul de la PRET*CANTITATE (pentru afisare)

				mov r15, [total]
				add r15, rax
				mov [total], r15


				pop rax       ; resincronizam valorile de pe stiva
				push rcx   

				mov rdi, result_buffer     ; aici va fi numarul sub forma de string
				mov rbx, 10      ; pentru conversie
				mov rcx, rdi

				xor r15, r15    ; aici avem lungimea stringului, pentru a-l printa
				
				
				bbucla_conv:
					xor rdx, rdx
					div rbx

					add dl, '0'
					mov [rdi], dl
					inc rdi 
					inc r15      ; incrementam lungimea stringului
					test rax, rax
					jnz bbucla_conv

					mov rsi, rdi 
					dec rsi
					mov byte [rdi], 0   ; dam null terminate la string, foarte important

					rrev:
						cmp rcx, rsi
						jge cconv_terminata
						mov al, [rcx]
						mov bl, [rsi]
						mov [rcx], bl
						mov [rsi], al
						inc rcx 
						dec rsi
						jmp rrev 

				cconv_terminata:
		
					mov rax, 1
					mov rdi, 1
					mov rsi, result_buffer
					mov rdx, r15
					syscall
					

					mov rax, 1
					mov rdi, 1
					mov rsi, times_string
					mov rdx, 3
					syscall



					lea rcx, [prix]
					
					mov rax, [rcx+r8]    ; mutam aici pretul (int) care trebuie convertit la STRING

					mov rdi, result_buffer     ; aici convertim pretul la STRING
					call int_to_string

					mov rax, 1
					mov rdi, 1
					mov rsi, result_buffer    ; afisam pretul 
					mov rdx, r15 
					syscall

					mov rax, 1
					mov rdi, 1
					mov rsi, f_char       ; afisam caracterul de franci
					mov rdx, 1
					syscall

					lea rax, [lungimi]
					mov rcx, [rax+r8]
					mov rsi, [lungime_rand]
					sub rsi, rcx
					mov [lungime_rand], rsi
					
					

					mov rax, 1
					mov rdi, 1
					mov rsi, spatiu       ; afisam numarul de spatii necesare
					mov rdx, [lungime_rand]
					syscall

					mov rax, [temp_total]
					mov rdi, result_buffer     ; convertim consumul total la string
					call int_to_string

					cmp r15, 1       ; daca consumul este de o cifra, trebuie afisat un spatiu in plus (aliniere)
					je un_spatiu
					restull:


						mov rax, 1
						mov rdi, 1
						mov rsi, result_buffer      ; printam cat a costat o singura bautura ex pastis 2*2f        4f
						mov rdx, r15
						syscall
						
						mov rdi, f_char   
						call print_char    ; printam litera f 
											
						mov rdi, nl
						call print_char    ;  aerisire

						pop rcx        ;   adresa de memorie pe care se bazeaza iteratia 
		  
					

						add r8, 8  ; index urmator 
						jmp afisam_unde_nui_zeroo
			

		un_spatiu:                  ; afisarea acelui spatiu in plus
			mov rdi, space
			call print_char
			jmp restull

			
		
		consum_inexistent_bauturaa:
			add r8, 8                                       ;   label daca nu exista consum la o bautura respectiva
			jmp afisam_unde_nui_zeroo                   ; incremenetam offsetul cu 8 si sarim din nou in bucla mare

		spatiu_minus:
			push rcx    ; daca nu dam push la rcx, da seg fault. (avem nevoie de el mai departe in program)
			
			mov rcx, [lungime_rand]
			dec rcx 
			mov [lungime_rand], rcx
			
			pop rcx
			
			jmp restttt 

		
		doua_spati_minus:     ;  acelasi label ca si mai sus doar ca scoatem 2 s
			push rcx    	

			mov rcx, [lungime_rand]
			sub rcx, 2              
			mov [lungime_rand], rcx
			
			pop rcx
			
			jmp restttt 
			


		terminatt:
			
			mov rax, 1
			mov rdi, 1
			mov rsi, nlnl
			mov rdx, 2
			syscall

			mov rax, 1
			mov rdi, 1
			mov rsi, texte_total   ; [total] 
			mov rdx, 9
			syscall
			

			mov rdi, result_buffer
			mov rax, [total]
			mov [total_avant_remise], rax        ;    stocam o copie in buffer asta, va fi util pentru calcule 
			call int_to_string
			
			mov rax, 1
			mov rdi, 1
			mov rsi, spatiu   
			mov rdx, 22     ; 30-8 (lungimea totala banda egal) - nr_caractere_pret_total
			sub rdx, r15
			syscall

			mov rax, 1
			mov rdi, 1
			mov rsi, result_buffer    ; pretul 
			mov rdx, r15
			syscall
			
			mov rdi, f_char    ; f de la franci
			call print_char   

			
			mov rax, 1
			mov rdi, 1
			mov rsi, texte_pourcentage    ; "eventuelle remise: "
			mov rdx, 35
			syscall


			mov rax, 0
			mov rdi, 0
			mov rsi, temp                ; stocam in temp reducerea sub forma de INT momentan
			mov rdx, 5
			syscall

			
			mov byte [rsi+rax-1], 0   ; dam null terminate la string indiferent de lungimea lui, deci s-a dus o limitatie majora a programului
			

			push rax     ; aici avem lungimea de la reducere (1 sau 2 caractere)

			call str_to_int

			
			push rax    

			mov rsi, result_buffer
			call str_to_int
			
			pop rdi ;   aici avem procentajul de reducere INT 

			mov rcx, rax        ; in rcx avem pretul total INT

			mov rdx, 100     ; mutam in rdx INT 100 ca sa facem RDI/RDX * RCX  (X)
			
			movzx rax, dl    ; dam null extend la 100
			cvtsi2ss xmm0, rax    ; convertim la float

			movzx rax, dil    ; la fel pentru procentaj
			cvtsi2ss xmm1, rax     ; convertim la float 

			
			divss xmm1, xmm0    ; in xmm1 avem numarul cu virgula de inmultit cu totalul, care o sa ne dea ce trebuie scazut la pretul final
			movzx rax, cl    ; null extend la total 
			cvtsi2ss xmm0, rax    ; convertim la float 

			mulss xmm1, xmm0  ; partea a doua a operatiei (X)

			
			cvttss2si rax, xmm1     ; functie dubioasa pentru a converti single digit precision float la int
			
			mov [montant_remise], rax    ;     o sa-l folosim mai incolo

			sub rcx, rax ; TOTAL - MONTANT_REDUCTION, deci avem totalul nou in RCX 
					
			mov rax, rcx
			mov rdi, result_buffer

			call int_to_string
		
			mov [barman], r15


			; aici urmeaza niste manipulari ansi, sa curatam textul de reducere si sa afisam totalul dupa reducere 
				


			mov rax, 1
			mov rdi, 1
			mov rsi, ansi_lineup    ;   manipulare ansi sa mutam cursorul cu un rand mai sus
			mov rdx, 0x3
			syscall
			
			mov rax, 1
			mov rdi, 1
			mov rsi, prix_final      ; Remise de ...
			mov rdx, 10
			syscall

			mov rax, 1
			mov rdi, 1
			mov rsi, ansi_reverse   ; inversam sa dam highlight la procentaj
			mov rdx, 5
			syscall

			
			mov rax, 1
			mov rdi, 1
			mov rsi, temp      ; procentajul de reducere STRING
			pop rdx
			syscall

			mov rax, 1
			mov rdi, 1
			mov rsi, proc_char     ; %
			mov rdx, 1
			syscall

			call reset_visual
			call visual

			mov rax, 1
			mov rdi, 1
			mov rsi, dot_char    ; .
			mov rdx, 1
			syscall


			mov rax, [montant_remise]
			mov rdi, temp_aux
			call int_to_string

			mov rax, 1
			mov rdi, 1
			mov rsi, spatiu
			mov rdx, 15
			sub rdx, r15
			syscall

			mov rax, 1
			mov rdi, 1
			mov rsi, temp_aux   ; calcul spatiu necesqar 
			mov rdx, r15
			syscall

			mov rdi, f_char    ; f 
			call print_char 


			mov rax, 1
			mov rdi, 1
			mov rsi, spatiu     ; mai imprimam cateva space
			mov rdx, 10 
			syscall


			mov rax, 1
			mov rdi, 1
			mov rsi, nlnl
			mov rdx, 2
			syscall


			mov rax, 1
			mov rdi, 1
			mov rsi, definitif     ;  [Final] 
			mov rdx, 8
			syscall
		
			mov rax, 1
			mov rdi, 1
			mov rsi, spatiu
			mov rdx, 22
			
			sub rdx, [barman]
			syscall

			mov rax, 1
			mov rdi, 1
			mov rsi, ansi_reverse    ; inversam culorile ca sa dam highlight la pret bine
			mov rdx, 5
			syscall


			mov rax, 1
			mov rdi, 1
			mov rsi, result_buffer
			mov rdx, [barman]
			syscall

			mov rdi, f_char
			call print_char


			call reset_visual
			call visual


			mov rax, 1
			mov rdi, 1
			mov rsi, nlnl
			mov rdx, 0x2
			syscall


			; pentru banda de =, setam culorile la reverse 

			mov rax, 1
			mov rdi, 1
			mov rsi, ansi_reverse
			mov rdx, 5
			syscall
			
			xor rbx, rbx

			buclaaaa_afisare:  ; facem o bucla separata, altfel ne arunca un infinite loop din cauza la xor rbx 
				mov rdi, egal
				call print_char
				inc rbx 
				cmp rbx, 30 ; numarul de caractere egal pe care il vreau 
				jl buclaaaa_afisare

			
			call reset_visual

			mov rax, 1
			mov rdi, 1
			mov rsi, nlnl
			mov rdx, 0x2
			syscall

			jmp gata     


	master_loop:  ; bucla infinita 
		
		mov rax, 1
		mov rdi, 1
		mov rsi, main_prompt
		mov rdx, 12
		syscall

		mov rax, 0
		mov rdi, 0 ; input 
		mov rsi, temp
		mov rdx, 16
		syscall

		mov rbx, list
		mov rsi, temp
		lodsb 
		
		cmp al, [rbx]     
		je listt   ; label care sare la afisare_bauturi, cumva nu da seg fault !!
		mov rbx, quit  ; sarim la exit label 
		cmp al, byte [rbx]
		je gata
		mov rbx, addd
		cmp al, byte [rbx] 
		je adaugare    ; sarim la labelul de adaugare 
		mov rbx, h_char
		cmp al, byte [rbx]      
		je ajutor             ; sarim la label de ajutor (textul din ajutor se va scrie la sfarsit de tot)
		mov rbx, d_char
		cmp al, byte [rbx]    ;  sarim la labelul de afisare consum 
		je display
		mov rbx, f_char
		cmp al, byte [rbx]
		je facturation


		; aici vor urma comenzile de mai mult de un byte 


		jmp master_loop ;  intram din nou in bucla infinita

				
	
	_start:
		xor rdx, rdx
		mov [temp_total], rdx
		mov rdx, 18
		mov [lungime_rand], rdx        ;   pentru alinia consumul cum trebuie in factura

		call visual ; initializam setarile vizuale (coduri ANSI)
		
		call afisare_text_introductiv ; afisam in italic bunvenit

		call choix_barman  ; introducem numele barmanului
		
		
		call delay         ;   delay indus, simulare de incarcare  
		;   delay de decomentat cand va fi terminat programul
		
		jmp ajutor ; printeaza mesajul de ajutor si sare dupa in master_loop

