.data

	msgStart:	.asciiz	"Ägyptische Multiplikation a * b!"
	msgInputA:	.asciiz	"\na eingeben: "
	msgInputB:	.asciiz	"\nb eingeben: "
	neueZeile:	.asciiz	"\n"

.text

main:

	li $v0,	4
	la $a0,	msgStart
	syscall				#Startnachticht

	li $v0,	4
	la $a0,	neueZeile
	syscall				#Neue Zeile (nur Formatierung)

	li $v0,	4
	la $a0,	msgInputA
	syscall		

	li $v0,	5
	syscall
	move $s0, $v0		#a in S0 gespeichert (Zahl)

	li $v0,	4
	la $a0,	msgInputB
	syscall		

	li $v0,	5
	syscall
	move $s1, $v0		#b in S1 gespeichert (Multiplikator)

#	----------------------------------
#	----	Berechnen beginnt     ----
#	----------------------------------
	
	move $a0, $s0		#a0 = a Übergabewert
	move $a1, $s1		#a1 = b Übergabewert	
	jal	berechnen
	move $s2, $v0

	
	li $v0, 10
	syscall	

#	----------------------------------
#	----	 Unterprogramme       ----
#	----------------------------------

berechnen:					#Multiplikation bis b = 1
	
	beq $a1, 1, ende		#Abbruchbedingung
	li $t1, 2
	div	$a1, $t1
	mfhi $t0				#Wenn t0 = 0 dann war b gerade
	beqz $t0, berechnen		#Wenn b gerade dann nicht speichern und weiter rechnen
	
	# --- Save to Stack ---
	subu $sp, $sp, 4
	
	
	mul	$a0, $a0, 2			#a x 2
	div	$a1, $a1, 2			#b / 2
		

ende:						#Nimm Rücksprung aus Stack und geh ins Hauptprogramm
	

auslesen:					#Ergebnisse aus Stack holen und addieren

