.data
	
.text
main:
	li		$s5,	88
	li		$t1,	3					#Testschleife Anfangszahl
	beq		$s5,	1,		keinePrim	#Fall Zahl = 1, wenn 1 dann abbruch
	beq		$s5,	2, 		istPrim		#Primzahl 2 test
	and		$t0,	$s5,	1			#Verknüpfen mit 1 (gerade/ungerade)
	beqz	$t0,	keinePrim			#Wenn gerade dann abbruch
	srl		$t0,	$s5,	1			#/2, Algorithmus
		
	loop4:
	sltu	$t2,	$t1,	$t0
	beq		$t2,	$zero,	istPrim
	div		$s5,	$t1
	mfhi	$t2
	beq		$t2,	$zero,	keinePrim
	addi	$t1,	$t1,	2
	j		loop4
		
	keinePrim:								#Wenn keine Primzahl dann Rückgabewert 0
	li		$s5,	0
	j		drucken
	istPrim:								#Wenn Primzahl dann Rückgabewert 1
	li		$s5,	1
	j		drucken

	drucken:
	li		$v0,	1
	la		$a0,	($s5)
	syscall