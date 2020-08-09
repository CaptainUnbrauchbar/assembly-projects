.data

.text
	
	li $a1, 1
	li $t1, 2
	div	$a1, $t1
	mfhi $t0				#Wenn t0 = 0 dann war b gerade
	jal	berechnen
	
	li	$v0,	10
	syscall
	
	berechnen:
	sub	$fp, $sp, 8
	sub	$sp, $sp, 8
	sw	$ra, ($sp)
	sw	$s0, 4($sp)
	jr	$ra
	
	beqz $t0, ende
	
	ende:
	