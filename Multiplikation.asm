#			----------------------------------
#			 Aegyptische Multiplikation von 2
#					 Zahlen a und b!
#			
#				  Rekursive Umsetzung
#					   Gruppe 47
#			----------------------------------

.data

	msgStart:	.asciiz	"�gyptische Multiplikation a * b!"
	msgInputA:	.asciiz	"\na eingeben: "
	msgInputB:	.asciiz	"\nb eingeben: "
	msgOutput:	.asciiz	"\nErgebnis: "
	msgMal:		.asciiz " x "
	msgGleich:	.asciiz " = "
	neueZeile:	.asciiz	"\n"

.text

main:							#Programm beginnt
	li 		$v0, 4
	la 		$a0, msgStart
	syscall						#Ausgabe Startnachticht

	li 		$v0, 4
	la		$a0, neueZeile
	syscall						#Neue Zeile (nur Formatierung)

	li		$v0, 4
	la 		$a0, msgInputA
	syscall		

	li		$v0, 5
	syscall
	move 	$s0, $v0			#a in S0 gespeichert (Zahl)

	li 		$v0, 4
	la 		$a0, msgInputB
	syscall		

	li 		$v0, 5
	syscall
	move 	$s1, $v0			#b in S1 gespeichert (Multiplikator)

#			----------------------------------
#			--- Eigentliches Hauptprogramm ---
#			----------------------------------
	
	beqz	$s0, fallNull		#Fall eingabe = 0
	beqz	$s1, fallNull
	
	move 	$a0, $s0			#a0 = a �bergabewert
	move 	$a1, $s1			#a1 = b �bergabewert
	li		$v0, 0	
	jal	berechnen
	move 	$s2, $v0			#Ergebnis in s2
	
ausgabe:						#Ausgabe des Ergebnisses		
	li		$v0, 4
	la		$a0, msgOutput		
	syscall						#Ausgabe String
	
	li		$v0, 1				#A darstellen (nur kosmetisch)
	la		$a0, ($s0)
	syscall
	
	li		$v0, 4				#x darstellen (nur kosmetisch)
	la		$a0, msgMal
	syscall
	
	li		$v0, 1				#b darstellen (nur kosmetisch)
	la		$a0, ($s1)
	syscall
	
	li		$v0, 4				#= darstellen (nur kosmetisch)
	la		$a0, msgGleich
	syscall
	
	li		$v0, 1				#Ergebnis darstellen!
	la		$a0, ($s2)			
	syscall						#Ausgabe der Zahl
	
	li		$v0, 10
	syscall						#Programm beenden

fallNull:						#Fall eingabe = 0	
	li		$v0, 0				#Ergebnis = 0
	j		ausgabe				#Springe zu Ausgabe

#			----------------------------------
#			----	 Unterprogramme       ----
#			----------------------------------

berechnen:						#Multiplikation bis b = 1	
	subiu 	$sp, $sp, 4	
	sw 		$ra, 4($sp)    		#R�cksprungaddresse zu main speichern 
	
	li 		$t1, 2				
	div		$a1, $t1			#b durch 2 teilen aber nicht �berschreiben
	mfhi 	$t0					#Wenn t0 = 0 dann war b gerade
	beqz 	$t0, marke			#Wenn b gerade dann nicht speichern und weiter rechnen
	add		$v0, $v0, $a0		#a speichern
marke:	
	beq 	$a1, 1, ende		#Abbruchbedingung		
	mul		$a0, $a0, 2			#a x 2
	div		$a1, $a1, 2			#b / 2		
	jal		berechnen
		
ende:							
	lw 		$ra, 4($sp)    		#R�cksprungaddresse zu main wiederherstellen
	addiu 	$sp, $sp, 4
	jr		$ra

