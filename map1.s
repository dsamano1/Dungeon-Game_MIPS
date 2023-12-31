.data 0x10002000
.ascii " ##  ###"
.ascii "  $ @ @*"
.ascii "       #"
.ascii " @###$  "
.ascii "        "
.ascii "  @#### "
.ascii "      $ "
.ascii "S ## ## "


.align 16
main_console:
.ascii "\n<---------------------------------->\n"
.ascii "______                            \n"
.ascii "|  _  \                           \n"
.ascii "| | | |___ _ __ ___   ___  _ __   \n"
.ascii "| | | / _ \ '_ ` _ \ / _ \| '_ \  \n"
.ascii "| |/ /  __/ | | | | | (_) | | | | \n"
.ascii "|___/ \___|_| |_| |_|\___/|_| |_| \n"
.ascii "                                  \n"
.ascii "           ______                 \n"
.ascii "           | ___ \                \n"
.ascii "           | |_/ /   _ _ __       \n"
.ascii "           |    / | | | '_ \      \n"
.ascii "           | |\ \ |_| | | | |     \n"
.ascii "           \_| \_\__,_|_| |_|     \n"
.asciiz "<---------------------------------->\n"

.align 16
store:
.ascii "++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
.ascii "+Press the respected number [1] [2] [3] to buy a sword.+\n" 
.ascii "++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"
.ascii "++++++++++++++++++++++++++++++++\n"
.ascii "+        SWORD STORE           +\n"
.ascii "+ (1)dull-sword:    |$100|     +\n"
.ascii "+ (2)average-sword: |$200|     +\n"
.ascii "+ (3)GRAND-SWORD:   |$300|     +\n"
.ascii "+                              +\n"
.asciiz "++++++++++++++++++++++++++++++++\n"

.align 6
purchased: 
.ascii "++++++++++++++++++++++++++\n"
.ascii "+ Purchased Successfull! +\n"
.asciiz "++++++++++++++++++++++++++\n"

.align 8
prompt: .asciiz "Player (S): \n(w to go up) \n(d to go left) \n(s to go down) \n(a to go left) \nAvoid the demons!(@), and find the exit gate!(*) \n(press p to open up shop menu)"
.align 10
exit:
.ascii "\n\n\n\n\n\n---------------------------------------\nPlayer has succesfully exited the map!\n---------------------------------------"
.ascii "\n__   __\n"               
.ascii "\ \ / /\n"               
.ascii " \ V /___  _   _\n"      
.ascii "  \ // _ \| | | |\n"     
.ascii "  | | (_) | |_| |\n"     
.ascii "  \_/\___/ \__,_|\n"     
.ascii "                 \n" 
.ascii "                 \n"     
.ascii "   _    _ _         _\n"
.ascii "  | |  | (_)       | |\n"
.ascii "  | |  | |_ _ __   | |\n"
.ascii "  | |/\| | | '_ \  | |\n"
.ascii "  \  /\  / | | | | |_|\n"
.asciiz "   \/  \/|_|_| |_| (_)\n"

.align 6
blocked_path: .asciiz "\nOut of bounds or blocked path try a different move"
.align 6
demon_prompt: 
.ascii "+++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
.ascii "+          You have been killed by a demon            +\n"
.ascii "+ If only there was a sword we can buy to kill them...+\n"
.ascii "+               hint: (press p)                       +\n"
.asciiz "+++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
.align 8
low: 
.ascii "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
.ascii "+++++++++++++++++++++++++++++++++++++\n"
.ascii "+Insufficient Coins, collect more $!+\n"
.asciiz "+++++++++++++++++++++++++++++++++++++\n"
.align 6 
new_line: .asciiz "\n"
.align 6
bar: .asciiz "\n------------"
.align 6
coins_amount: .asciiz "\ncoins: "
.align 8
spacer: .asciiz "\n---------\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
.align 6
player_loc: .space 4
.align 6
coins: .space 4
.align 6
sword: .space 4
.align 6
sword_endurance: .space 4
.align 6
sword_string: .asciiz "\nSword Endurance: "
.align 6
equipment: .asciiz "\nEquipped: "
.align 6
null: .asciiz "none"
.align 6
dSword: .asciiz "dull-sword"
.align 6
aSword: .asciiz "average-sword"
.align 6
gSword: .asciiz "GRAND-SWORD"

.align 8
dynamic_map: .space 65

.text

main:
ori $2, $0, 4
lui $4, 4097
ori $4, $4, 2560
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
or $0, $0, $0   #NOP

##Checks if game is terminated ##
beq $14, $15, exit_map
or $0, $0, $0   #NOP

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

## $21 is '@' ##
ori $21, $0, 0x40

## action applied ##

## 0x70 = 'p' ##
ori $13, $0, 0x70
beq $5, $13, store_menu
or $0, $0, $0   #NOP

## 0x77 = 'w' ##
ori $13, $0, 0x77
beq $5, $13, move_up
or $0, $0, $0   #NOP

## 0x64 = 'd' ##
ori $13, $0, 0x64
beq $5, $13, move_right 
or $0, $0, $0   #NOP

## 0x73 = 's' ##
ori $13, $0, 0x73
beq $5, $13, move_down
or $0, $0, $0   #NOP

## 0x61 = 'a' ##
ori $13, $0, 0x61
beq $5, $13, move_left
or $0, $0, $0   #NOP

## 0x74  = 't' ##
ori $13, $0, 0x74
beq $5, $13, exit_map
or $0, $0, $0   #NOP

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
or $0, $0, $0   #NOP

## tells the user how to play ##
ori $2, $0, 4
la $4, prompt
syscall

## main prompt ##
ori $2, $0, 4
la $4, main_console
syscall

## Set $19 = 0
add $19, $0, $0
sb $19, sword
or $0, $0, $0   #NOP
sb $19, sword_endurance
or $0, $0, $0   #NOP

jr $31
or $0, $0, $0   #NOP

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
or $0, $0, $0   #NOP

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

## Checks if there is a demon that the player will run into ##
beq $10, $21, demon
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
or $0, $0, $0   #NOP

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
or $0, $0, $0   #NOP

#############################################
demon:
lbu $19, sword_endurance
or $0, $0, $0   #NOP
bne $19, $0, kill_demon
or $0, $0, $0   #NOP
ori $2, $0, 4
la $4, demon_prompt
syscall

## sets player to original position ##
ori $10, $0, 83
ori $25, $0, 56 

sb $10, dynamic_map($25)
or $0, $0, $0

## saves new location ##
sb $25, player_loc
or $0, $0, $0

## replaces old position with ' ' ##
ori $10, $0, 32
sb $10, dynamic_map($24)
or $0, $0, $0

j main_loop
or $0, $0, $0

#############################################

kill_demon:
lbu $19, sword_endurance
addi $19, $19, -1
sb $19, sword_endurance
or $0, $0, $0   #NOP
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

beq $19, $0, setNone
or $0, $0, $0   #NOP

j main_loop
or $0, $0, $0   #NOP

setNone:
sb $19, sword
or $0, $0, $0   #NOP

j main_loop
or $0, $0, $0   #NOP
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
or $0, $0, $0   #NOP

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

## Checks if there is a demon that the player will run into ##
beq $10, $21, demon
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
or $0, $0, $0   #NOP

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
or $0, $0, $0   #NOP

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

## Checks if there is a demon that the player will run into ##
beq $10, $21, demon
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
or $0, $0, $0   #NOP

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
or $0, $0, $0   #NOP

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

## Checks if there is a demon that the player will run into ##
beq $10, $21, demon
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
or $0, $0, $0   #NOP

#############################################
store_menu:
ori $2, $0, 4
la $4, store
syscall

ori $2, $0, 12
syscall

add $19, $2, $0
## Checks for purchasing sword ##
ori $6, $0, 49
beq $19, $6, one
or $0, $0, $0   #NOP
ori $6, $0, 50
beq $19, $6, two
or $0, $0, $0   #NOP
ori $6, $0, 51
beq $19, $6, three
or $0, $0, $0   #NOP

j main_loop
or $0, $0, $0   #NOP

one:
slti $10, $9, 100
bne $10, $0, insufficient
or $0, $0, $0   #NOP
sb $19, sword
or $0, $0, $0   #NOP
addi $9, $9, -100
addi $19, $0, 1
sb $19, sword_endurance
or $0, $0, $0   #NOP

ori $2, $0, 4
la $4, spacer
syscall

ori $2, $0, 4
la $4, purchased
syscall

j main_loop
or $0, $0, $0   #NOP

two:
slti $10, $9, 200
bne $10, $0, insufficient
or $0, $0, $0   #NOP
sb $19, sword
or $0, $0, $0   #NOP
addi $19, $0, 2
addi $9, $9, -200
sb $19, sword_endurance
or $0, $0, $0   #NOP

ori $2, $0, 4
la $4, spacer
syscall

ori $2, $0, 4
la $4, purchased
syscall
j main_loop
or $0, $0, $0   #NOP

three:
slti $10, $9, 300
bne $10, $0, insufficient
or $0, $0, $0   #NOP
sb $19, sword
or $0, $0, $0   #NOP
addi $19, $0, 3
addi $9, $9, -300
sb $19, sword_endurance
or $0, $0, $0   #NOP

ori $2, $0, 4
la $4, spacer
syscall

ori $2, $0, 4
la $4, purchased
syscall
j main_loop
or $0, $0, $0   #NOP

insufficient:
ori $2, $0, 4
la $4, low
syscall

j main_loop
or $0, $0, $0   #NOP

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

ori $2, $0, 4
la $4, sword_string
syscall

lbu $19, sword_endurance
or $0, $0, $0   #NOP
ori $2, $0, 1
add $4, $0, $19
syscall

ori $2, $0, 4
la $4, bar
syscall

ori $2, $0, 4
la $4, equipment
syscall


lbu $19, sword
or $0, $0, $0   #NOP
## Checks for equipped sword ##
ori $6, $0, 49
beq $19, $6, dull
or $0, $0, $0   #NOP
ori $6, $0, 50
beq $19, $6, average
or $0, $0, $0   #NOP
ori $6, $0, 51
beq $19, $6, grand
or $0, $0, $0   #NOP

ori $2, $0, 4
la $4, null
syscall

ori $2, $0, 4
la $4, bar
syscall

jr $31
or $0, $0, $0
#############################################
dull:
ori $2, $0, 4
la $4, dSword
syscall

ori $2, $0, 4
la $4, bar
syscall

jr $31
or $0, $0, $0
#############################################
average:
ori $2, $0, 4
la $4, aSword
syscall

ori $2, $0, 4
la $4, bar
syscall

jr $31
or $0, $0, $0
#############################################
grand:
ori $2, $0, 4
la $4, gSword
syscall

ori $2, $0, 4
la $4, bar
syscall

jr $31
or $0, $0, $0

###############################################
exit_map:
## prompt player successfully left the map ##
ori $2, $0, 4
la $4, exit
syscall

ori $2, $0, 10
syscall