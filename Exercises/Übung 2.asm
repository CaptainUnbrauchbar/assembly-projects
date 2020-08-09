.data	
	promptMsg1:	.asciiz	"Intervall erste Zahl: "
	promptMsg2:	.asciiz	"Intervall zweite Zahl: "
	promptAusg:	.asciiz	"MIRP Zahlen im Intervall: "
	neueZeile:	.asciiz	"\n"
	Feld:		.data 	40
	
.text
	main:
	li 		$v0,	4
	la		$a0,	promptMsg1
	syscall
	
	li		$v0,	5
	syscall
	move	$s6,	$v0					#$s6 = Eingabe 1
	
	li 		$v0,	4
	la		$a0,	promptMsg2
	syscall
	
	li		$v0,	5
	syscall
	move	$s7,	$v0					#$s7 = Eingabe 2
	
	li		$v0,	4					#Ausgabetext
	la		$a0,	promptAusg
	syscall
	
	#	---	Berechnen beginnt --- #
	
	subi		$s6,	$s6,	1
	
	intervall:
	addi		$s6,	$s6,	1
	bgt			$s6,	$s7,	programmEnde	#Abbruch weil Intervall fertig
	move		$s5,	$s6
	jal			testPrim
	
	beqz		$s5,	intervall		#Rückgabe keine Primzahl -> nächste Zahl
	
	jal			zahlUmdrehen			#Zahl umdrehen
	
	beq			$s2,	$s6,	intervall	#Test ob Palindrom -> wenn ja nächste Zahl
	
	move		$s5,	$s2				#Umgredrehte Zahl auf Primzahl prüfen
	jal			testPrim				
	
	beqz		$s5,	intervall
	
	li			$v0,	4				#Neue Zeile nach Mirpzahl
	la			$a0,	neueZeile
	syscall
	
	li			$v0,	1				#Umgredrehte Primzahl ausgeben!
	la			$a0,	($s2)
	syscall
	
	j			intervall
	
	programmEnde:
	
	li		$v0,	10					#Terminate
	syscall
	
	
	
	#	--------------------------------------------------------------------------------
	#	Unterprogramme
	#	--------------------------------------------------------------------------------
	
	zahlUmdrehen:		
	li		$t1,	10					#Konstante 10
	li		$t2,	1					#Zähler
	li		$s2,	0					#Ergebnis der umgedrehten Zahl
	li		$t3,	0
	li		$t4,	0
	li		$t5,	0
	li		$t6,	0

	move	$s1,	$s6
	anzahlStellen:						#Anzahl der Stellen der Primzahl berechnen
	div		$s1,	$t1
	mflo	$s1
	beqz	$s1,	zerlegen
	addi	$t2,	$t2,	1
	j		anzahlStellen
	#T2 = Anzahl Stellen
	
	zerlegen:							#Jede Stelle in Speicher schreiben (Feld)
	move	$s1,	$s6
	move	$t0,	$t2
	loop1:
	beqz	$t0,	exp
	div		$s1,	$t1
	mfhi	$t3
	mflo	$s1

	mul		$t4,	$t0,	4
	subi	$t4,	$t4,	4
	sw		$t3,	Feld($t4)			#Zahl wird rückwärts abgespeichert
	subi	$t0,	$t0,	1
	j		loop1

	exp:								#Multiplikator berechnen um bspw. einer Stelle in hunderter zu konvertieren
	move	$t0,	$t2
	li		$t5,	1
	loop2:
	subi	$t0,	$t0,	1
	beqz	$t0,	multi				
	mul		$t5,	$t5,	10
	j		loop2
	#T5 = Multiplikator Basis
	
	multi:								#Zahlen abrufen und korrekt multiplizieren um Zahl umzudrehen
	move	$t0,	$t2
	loop3:	
	mul		$t3,	$t0,	4			#Berechnung des Index
	subi	$t3,	$t3,	4
	lw		$t4,	Feld($t3)			#Zahl aus Feld holen in T4		
	
	mul		$t6,	$t4,	$t5			#Zwischenergebnis
	add		$s2,	$s2,	$t6			#Ergebnis = Ergebnis + Zwischenergebnis
	
	div		$t5,	$t5,	$t1			#Exponent = Exponent / Konstante 10
	subi	$t0,	$t0,	1
	beqz	$t0,	umdrehenEnde
	j		loop3
		
	umdrehenEnde:
	jr		$ra							#Ergebnis ist in S2
		
	testPrim:
	li		$t1,	3					#Testschleife Anfangszahl
	beq		$s5,	1,	keinePrim		#Fall Zahl = 1, wenn 1 dann abbruch
	beq		$s5,	2, 	istPrim			#Primzahl 2 test
	and		$t0,	$s5,	1			#Verknüpfen mit 1 (gerade/ungerade)
	beqz	$t0,	keinePrim			#Wenn gerade dann abbruch
	srl		$t0,	$s5,	1			#/2, Algorithmus
		
	loop4:								#Teilertests
	sltu	$t2,	$t1,	$t0			
	beq		$t2,	$zero,	istPrim		#Primzahl erreicht, Rest ungleich 0
	div		$s5,	$t1
	mfhi	$t2
	beq		$t2,	$zero,	keinePrim	#Rest = 0 also Division erfolgreich und keine Primzahl
	addi	$t1,	$t1,	2
	j		loop4
		
	keinePrim:							#Wenn keine Primzahl dann Rückgabewert 0
	li		$s5,	0
	jr		$ra
	
	istPrim:							#Wenn Primzahl dann Rückgabewert 1
	li		$s5,	1
	jr		$ra