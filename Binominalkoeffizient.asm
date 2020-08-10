#Binominalkoeffizient berechnen (n über k
#
# !!! Der größtmögliche Eingabewert ist 12! da alles andere 32bit Speicherstellen übersteigt !!!

.data
	promptMsgN:	.asciiz	"N eingeben: "
	promptMsgK:	.asciiz	"\nK eingeben: "
	promptSpce:	.asciiz	"\n---------------------------"
	resultMsg:	.asciiz	"\nErgebnis N über K: "
	
.text 
	main:
	li 		$v0,	4
	la		$a0,	promptMsgN
	syscall
	li		$v0,	5
	syscall
	move	$s0,	$v0				#$s0 = N
	
	li 		$v0,	4
	la		$a0,	promptMsgK
	syscall
	li		$v0,	5
	syscall
	move	$s1,	$v0				#$s1 = K

	#Abfrage Sonderfall 0 über 0 = 1
	li		$s7,	1
	bnez	$s0,	Rechnen
	beqz	$s1,	ErgebnisDarstellen
	
	
	Rechnen:	 
	#Zähler
	move	$a0,	$s0
	jal		factStart
	move	$s2,	$a0				#$s2 = Zähler
	
	#Nenner Teil 1
	sub		$s3,	$s0,	$s1		#$s3 = n-k
	move	$a0,	$s3
	jal		factStart
	move	$s4,	$a0				#$s4 = Nenner Teil 1
	
	#Nenner Teil 2
	move	$a0,	$s1
	jal		factStart
	move	$s5,	$a0				#$s5 = Nenner Teil 2
	
	mul		$s6,	$s4,	$s5		#$s6 = Nenner
	
	div		$s7,	$s2,	$s6		#Dividieren
	
	
	ErgebnisDarstellen:	
	li 		$v0,	4
	la		$a0,	promptSpce
	syscall
	
	li 		$v0,	4
	la		$a0,	resultMsg
	syscall
	
	li		$v0,	1	
	la		$a0,	($s7)
	syscall
	
	li 		$v0,	4
	la		$a0,	promptSpce
	syscall
	
	li		$v0,	10				#Terminate
	syscall
	
	
	#Input = $a0, Output = $a0
	factStart:
	add		$t0,	$zero,	$a0		

		whileFact:		
		beq		$t0,	1,	ende	
		subi	$t0,	$t0,	1
		mul 	$a0,	$a0,	$t0
		j		whileFact

		ende:
		jr		$ra
	

	
	
	
	
	
	
	
	
	
	

	
	
	
	
