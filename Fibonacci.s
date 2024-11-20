.data

out_string: .asciiz "Enter the value of n: " # message to input n
mat:  .word 1, 1, 1, 0 # declare basic matrix to make pibonacci
temp: .space 16 # declare the empty 2*2 matrix

.text

main:

  # print "Enter the value of n: "
	li  $v0, 4
	la  $a0, out_string
	syscall		
  
  # input n
  li  $v0, 5
  syscall
  move  $s0, $v0
  addi  $s0, $s0, -1 # we want to have first index of n-1 times basic matrix

  # input n equal zero, finish the program with print 0
  slt $a1, $s0, $zero
  bne $a1, $zero, finish

  # load the matrix address
  la  $s1, mat
  la  $s2, temp

  # we will store remainder at $s3, set zero at $s3
  li  $s3, 0

  # jump to fibonacci function and save next statement address at $ra
  jal fibonacci

  # load the matrix's first index value(=nth fibonacci number) and print
  lw  $t0, 0($s1)
  move  $a0, $t0
  li  $v0, 1
  syscall

  # finish the program  
  li  $v0, 10
  syscall


# finish the program with print zero
finish:

  li  $a0, 0
  li  $v0, 1
  syscall

  li  $v0, 10
  syscall


fibonacci:
  
  # store return address, remainder, changed n at stack
  addi  $sp, $sp, -8
  sw  $ra, 4($sp)
  sw  $s3, 0($sp)

  # copy the matrix s1 and paste to matrix s2 
  lw  $t6, 0($s1)
  lw  $t7, 4($s1)
  lw  $t8, 8($s1)
  lw  $t9, 12($s1)

  sw  $t6, 0($s2)
  sw  $t7, 4($s2)
  sw  $t8, 8($s2)
  sw  $t9, 12($s2)

  # when n>1 jump to matirxpower function, when n<=1 jump to next state
  slti  $t1, $s0, 2 
  beq $t1, $zero, matrixpower
  jr  $ra


matrixpower:

  # divide n(store at $s0) by 2, store quotient and remainder 
  li  $t3, 2
  div $s0, $t3
  mflo $s0
  mfhi $s3

  jal fibonacci # go back to fibonacci and save next statement address at $ra
  jal multiply_power # go to multiply_power function and save next statement address at $ra
  
  lw  $s3, 0($sp) # load the remainder from stack
  addi  $sp, $sp, 8 # pop 3 items form stack
  lw  $ra, 4($sp) # load return address from stack
  
  bne $s3, $zero, multiply_basic # if remaider(store at $s3) is not zero, go to multiply_basic function
  jr $ra # else(remaider is zero) jump to return address



# square the matrix s1 
multiply_power: 
  
  # load the matrix value
  lw  $t0, 0($s1)
  lw  $t1, 4($s1)
  lw  $t2, 8($s1)
  lw  $t3, 12($s1)

  # calculate the matrix's (1,1) value and store
  mul  $t4, $t0, $t0
  mul  $t5, $t1, $t2  

  add  $t6, $t4, $t5
  sw  $t6, 0($s1)

  # calculate the matrix's (1,2) value and store
  mul  $t4, $t0, $t1
  mul  $t5, $t1, $t3

  add  $t6, $t4, $t5
  sw  $t6, 4($s1)

  # calculate the matrix's (2,1) value and store
  mul  $t4, $t2, $t0     
  mul  $t5, $t3, $t2

  add  $t6, $t4, $t5
  sw  $t6, 8($s1)

  # calculate the matrix's (2,2) value and store
  mul  $t4, $t2, $t1
  mul  $t5, $t3, $t3

  add  $t6, $t4, $t5
  sw  $t6, 12($s1)
  
  jr  $ra # jump to return address

# multifly original mtrix(=s1) with basic matrix(=[1, 1, 1, 0])
multiply_basic:

  # load the original matrix value
  lw  $t0, 0($s1)
  lw  $t1, 4($s1)
  lw  $t2, 8($s1)
  lw  $t3, 12($s1)

  # load the basic matrix value
  lw  $t4, 0($s2)
  lw  $t5, 4($s2)
  lw  $t6, 8($s2)
  lw  $t7, 12($s2)
  
  # calculate the matrix's (1,1) value and store
  mul  $t8, $t0, $t4
  mul  $t9, $t1, $t6  

  add  $t8, $t8, $t9
  sw  $t8, 0($s1)

  # calculate the matrix's (1,2) value and store
  mul  $t8, $t0, $t5
  mul  $t9, $t1, $t7

  add  $t8, $t8, $t9
  sw  $t8, 4($s1)

  # calculate the matrix's (2,1) value and store
  mul  $t8, $t2, $t4   
  mul  $t9, $t3, $t6

  add  $t8, $t8, $t9
  sw  $t8, 8($s1)

  # calculate the matrix's (2,2) value and store
  mul  $t8, $t2, $t5
  mul  $t9, $t3, $t7

  add  $t8, $t8, $t9
  sw  $t8, 12($s1)

  jr  $ra # jump to return address





  
