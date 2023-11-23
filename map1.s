.data 0x10002000
.ascii " ##0 ###"
.ascii "  $ @  *"
.ascii "      @#"
.ascii "1@###$ 2"
.ascii "        "
.ascii "  @#### "
.ascii "   3  $ "
.ascii "S ## ## "

.align 8
prompt: .asciiz "Player (S): w to go up, d to go left, s to go down, a to go left. Avoid the demons!(@), and find the exit gate!(*)"
.align 8
exit: .asciiz "\n\n\n\n\n\n---------------------------------------\nPlayer has succesfully exited the map!\n---------------------------------------"
.align 6
blocked_path: .asciiz "\nOut of bounds or blocked path try a different move"
.align 6
new_line: .asciiz "\n"
.align 6
bar: .asciiz "\n--------"
.align 6
coins_amount: .asciiz "\ncoins: "
.align 8
spacer: .asciiz "\n---------\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
.align 6
player_loc: .space 4
.align 6
coins: .space 4
.align 6
potion_loc: .space 4
.align 8
dynamic_map: .space 65

.text

main:
ori $2, $0, 4
la $4, spacer
syscall
## creates original static map
jal initial_map
or $0, $0, $0

jal initializer
or $0, $0, $0

#####################################
main_loop:
## Checks player's location ##
lbu $15, player_loc

##Checks if game is terminated ##
beq $14, $15, exit_map

## set up registers for looping 65 times to update map ##
ori $11, $0, 65
ori $12, $0, 8
add $8, $0, $0
## displays current map
jal design_map
or $0, $0, $0

## player's move ##
ori $2, $0, 12
syscall

#moves input to $5 in order to call spacer
or $5, $0, $2

ori $2, $0, 4
la $4, spacer
syscall

## $23 is '#' ##
ori $23, $0, 35

## $22 is '$' ##
ori $22, $0, 0x24

## action applied ##
## 0x77 = 'w' ##
ori $13, $0, 0x77
beq $5, $13, move_up

## 0x64 = 'd' ##
ori $13, $0, 0x64
beq $5, $13, move_right 

## 0x73 = 's' ##
ori $13, $0, 0x73
beq $5, $13, move_down

## 0x61 = 'a' ##
ori $13, $0, 0x61
beq $5, $13, move_left

###############################################
initializer:
## initial position of player ##
ori $15, $0, 56

## store byte to player_loc address ##
sb $15, player_loc
or $0, $0, $0

## position of exit gate ##
ori $14, $0, 15

## set coins = 0 ##
add $9, $0, $0
sb $9, coins

## tells the user how to play ##
ori $2, $0, 4
la $4, prompt
syscall

jr $31

###############################################
initial_map:
ori $11, $0, 65
lui $16, 0x1000
ori $16, $16, 0x2000 
add $17, $0, $0

store_dynamicMap:
lbu $8, 0($16) 
or $0, $0, $0

sb $8, dynamic_map($17)
or $0, $0, $0

addi $16, $16, 1
addi $17, $17, 1
addi $11, $11, -1

bne $11, $0, store_dynamicMap
or $0, $0, $0
jr $31
or $0, $0, $0
#############################################

move_up:
## $18 represents Row 0 ##
or $18, $0, $0    
## $24 is the offset location of player ##  
lbu $24, player_loc
or $0, $0, $0

## Calculate the Row position of player ##
div $24, $12
mflo $2

## Checks for borders/obstacles ##
beq $2, $18, wall

## moves player to up ##
addi $25, $24, -8

## Checks if there is an obstacles towards direction player wants to go to ##
lbu $10, dynamic_map($25)
or $0, $0, $0
beq $10, $23, wall
or $0, $0, $0

## Checks if there is a potion that the player will collect ##
beq $10, $22, coin
or $0, $0, $0

## replaces old position with ' ' ##
ori $10, $0, 32
sb $10, dynamic_map($24)
or $0, $0, $0

## sets player to new position ##
ori $10, $0, 83
sb $10, dynamic_map($25)
or $0, $0, $0

## saves new location ##
sb $25, player_loc
or $0, $0, $0

j main_loop

#############################################
wall:
ori $2, $0, 4
la $4, blocked_path
syscall

j main_loop
or $0, $0, $0

#############################################
coin:
addi $9, $9, 100

sb $9, coins
or $0, $0, $0

## replaces old position with ' ' ##
ori $10, $0, 32
sb $10, dynamic_map($24)
or $0, $0, $0


## sets player to new position ##
ori $10, $0, 83
sb $10, dynamic_map($25)
or $0, $0, $0

## saves new location ##
sb $25, player_loc
or $0, $0, $0

j main_loop

#############################################

move_right:
## $18 represents Column 7 ##
ori $18, $0, 7      
## $24 is the offset location of player ##  
lbu $24, player_loc
or $0, $0, $0


## Calculates the column position of player ##
div $24, $12
mfhi $2

## Checks if player is at the edge of a border ##
beq $2, $18, wall

## moves player to the right ##
addi $25, $24, 1


## Checks if there is an obstacles towards direction player wants to go to ##
lbu $10, dynamic_map($25)
or $0, $0, $0
beq $10, $23, wall
or $0, $0, $0

## Checks if there is a potion that the player will collect ##
beq $10, $22, coin
or $0, $0, $0

## replaces old position with ' ' ##
ori $10, $0, 32
sb $10, dynamic_map($24)
or $0, $0, $0


## sets player to new position ##
ori $10, $0, 83
sb $10, dynamic_map($25)
or $0, $0, $0

## saves new location ##
sb $25, player_loc
or $0, $0, $0

j main_loop

#############################################

move_down:
## $18 represents Row 7 ##
ori $18, $0, 7    
## $24 is the offset location of player ##  
lbu $24, player_loc
or $0, $0, $0

## Calculate the Row position of player ##
div $24, $12
mflo $2

## Checks for borders/obstacles ##
beq $2, $18, wall

## moves player to up ##
addi $25, $24, 8

## Checks if there is an obstacles towards direction player wants to go to ##
lbu $10, dynamic_map($25)
or $0, $0, $0
beq $10, $23, wall
or $0, $0, $0

## Checks if there is a potion that the player will collect ##
beq $10, $22, coin
or $0, $0, $0

## replaces old position with ' ' ##
ori $10, $0, 32
sb $10, dynamic_map($24)
or $0, $0, $0

## sets player to new position ##
ori $10, $0, 83
sb $10, dynamic_map($25)
or $0, $0, $0

## saves new location ##
sb $25, player_loc
or $0, $0, $0

j main_loop

#############################################

move_left:
## $18 represents Column 0 ##
or $18, $0, $0      
## $24 is the offset location of player ##  
lbu $24, player_loc
or $0, $0, $0


## Calculates the column position of player ##
div $24, $12
mfhi $2

## Checks if player is at the edge of a border ##
beq $2, $18, wall

## moves player to the left ##
addi $25, $24, -1


## Checks if there is an obstacles towards direction player wants to go to ##
lbu $10, dynamic_map($25)
or $0, $0, $0
beq $10, $23, wall
or $0, $0, $0

## Checks if there is a potion that the player will collect ##
beq $10, $22, coin
or $0, $0, $0

## replaces old position with ' ' ##
ori $10, $0, 32
sb $10, dynamic_map($24)
or $0, $0, $0


## sets player to new position ##
ori $10, $0, 83
sb $10, dynamic_map($25)
or $0, $0, $0

## saves new location ##
sb $25, player_loc
or $0, $0, $0

j main_loop

#############################################
design_map:
lbu $17, dynamic_map($8)
or $0, $0, $0

div $8, $12
mfhi $2

addi $11, $11, -1
addi $8, $8, 1
beq $11, $0, end_design_map
or $0, $0, $0

beq $2, $0, nLine
or $0, $0, $0

print_char:
ori $2, $0, 11
add $4, $0, $17
syscall

j design_map
or $0, $0, $0

nLine:
ori $2, $0, 4
la $4, new_line
syscall
j print_char
or $0, $0, $0

end_design_map:

ori $2, $0, 4
la $4, bar
syscall

ori $2, $0, 4
la $4, coins_amount
syscall

ori $2, $0, 1
add $4, $0, $9
syscall

ori $2, $0, 4
la $4, bar
syscall

jr $31
or $0, $0, $0
#############################################

exit_map:
## prompt player successfully left the map ##
ori $2, $0, 4
la $4, exit
syscall

ori $2, $0, 10
syscall