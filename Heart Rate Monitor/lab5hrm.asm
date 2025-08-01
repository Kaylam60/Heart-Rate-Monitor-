# lab5hrm.asm
# Copyright 2014, Skand Hurkat
#
# This program is offered in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#

# This file simply accepts BPI from IOB, which can be used to test
# modifications implemented in Lab 5 without reading in
# samples from IOC as in lab4hrm.asm. Your modifications can then be copied over
# to lab4hrm.asm and compiled if you wish to test on an FPGA board.

sub	r0, r0, r0

# this is needed give us a chance to set the IOB input in the real FPGA
# skipped by the simulator unless the --usehalt flag is set
halt

# read input BPI from IOB, ensure that BPI is capped to 29
lb	r2, -6(r0)
addi	r4, r2, -30
bltz	r4, 1
addi	r2, r0, 29

# Multiply BPI by two in order to access lookup tables in DRAM
sll	r2, r2

# Display the converted BPI -> BPM on IOF-IOG
lb	r3, 0(r2)
sb	r3, -2(r0)
lb	r3, 1(r2)
sb	r3, -1(r0)

# Insert your modifications below this line
# ----------------------------------------------------------------------
addi r3, r7, 0   #comparing current and previous directions
sub r6, r6, r6   #make sure IOE initializes to 00
sra r2,r2        # get IOB
bne r1, r0, 1    #check if IOA is present
lb r1, -7(r0)    # load IOA
bne r5, r0, 1    #check if r5 is empty
add r5, r2, r5   #save value of r2
beq r5, r2, 19   #check if r5=r2
sub r7, r5, r2   #difference
bltz r7,1        #is the difference less than 0, negative direction
bgez r7, 5       #is the difference greater than 0, positive direction
add r7, r7, r1   #if difference is negative, add threshold
bgez r7, 15      #if difference < threshold,
sub r7, r7, r7   #r7 is now being used for directions
beq r3, r7, 16   #are r3 and r7 equal? if so go to end
bne r3, r7, 4    #is r3 != r7? if so skip to IOE calculation
sub r7, r7, r1   #if difference is positive, subtract threshold
bltz r7, 12      #if r7<0 skip to end
addi r7, r0, 1   #change direction for r7
beq r3, r7, 7    #comparing current and previous directions
addi r6, r6, 25  #additions to obtain a value AA for IOE
addi r6, r6, 25  #additions to obtain a value AA for IOE
addi r6, r6, 25  #additions to obtain a value AA for IOE
addi r6, r6, 25  #additions to obtain a value AA for IOE
addi r6, r6, 25  #additions to obtain a value AA for IOE
addi r6, r6, 25  #additions to obtain a value AA for IOE
addi r6, r6, 20  #additions to obtain a value AA for IOE
bltz r6, 3       #checking whether r6 is AA or 00
sub r7, r7, r7   #initializing r7 for directions
beq r7, r0, 1    #is r7 0?
addi r7, r0, 1   #make r7=1
sb r6, -3(r0)    #store 00/AA in IOE
add r5, r2, r0   #set currentBPI as previousBPI
# Insert your modifications above this line
# ----------------------------------------------------------------------

# At this point, the program will eventually loop back to PC 0
