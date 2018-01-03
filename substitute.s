#
# substitute.s - substitute one character for another in a string
#
    .data
string: .space 80
orig:   .space 1
new:    .space 1
sprompt: .asciiz    "Enter string: "
oprompt: .asciiz    "Enter character you want to replace: "
nprompt: .asciiz    "Enter replacement character: "
rprompt: .asciiz    "The string with replacements: "
cprompt: .asciiz    "Number of replacements: "

    .text
    .globl  main
main:
	addiu 	$sp, $sp, 20
	sw		$ra, 16($sp)

    # get string
	la		$a0,sprompt
	li		$v0,4
	syscall

    la      $a0,string
    li      $a1,80
    li      $v0,8
    syscall

    # get original character
    la      $a0,oprompt
	li		$v0,4
	syscall

    li      $v0,12
    syscall
	sb		$v0,orig
	
	# (clear newline)
    li      $v0,12
    syscall

	# get new character
    la      $a0,nprompt
    li		$v0,4
    syscall

	li      $v0,12
    syscall
	sb		$v0,new
	
	# (clear newline)
    li      $v0,12
    syscall
	
#
# now we are ready to do the real work of substituting every instance of
# 'orig' with 'new' in 'string'
# HINT: before you start, initialize the following registers:
# a0 = address of the string
# a1 = char to look for
# a2 = char to replace with
# a3 = count of replacements (initialize to zero)
# Have fun!
#
#
#    int i,count=0;
#    for (i=0;string[i]!=0;i++)
#        if (string[i] == orig) {
#            string[i]=new;
#            count++;
#        }
#
# INSERT YOUR CODE HERE.  Make sure the number of replacements
# gets stored in $a3.
#
    sb $a1, new
    sb $a2, orig
    sw $a0, string
   
    loop: 
    lb $t0, 0($a0) #load the next character to t0
    beqz $t0, found
    addi $a0, $a0, 1 #load increment string pointer
    addi $a3, $a3, 1 #increment count
    beqz $t0, end #end loop if null character is reached
    j loop # return to top of loop
    
    found:
    move $a1, $a0 
    j loop
    
    # this code will output the string.  now, it will be the string entered.
    # once you've added your code, you should see the string with replacements
    end:
    li   $v0,4
    la   $a0,rprompt
    syscall

    li   $v0, 4
    la   $a0,string
    syscall

    # this code will output the count of replacements,
    # which must be stored in $a3
    li   $v0, 4
    la   $a0,cprompt
    syscall

    li   $v0, 1
    move $a0, $a3
    syscall

	lw	$ra, 16($sp)
	addiu	$sp, $sp, 20
	jr	$ra
