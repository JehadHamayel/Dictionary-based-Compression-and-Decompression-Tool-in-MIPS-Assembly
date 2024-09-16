#Jehad Hamayel 1200348
#Adam Nassan 1202076

################# D ata segment #####################
.data
fileDict: .asciiz "dictionary.txt" # name of file to read from
FirstQu: .asciiz "Does the dictionary.txt file exist? If the answer is yes, enter 1, and if the answer is no, enter 0 \n"
yesAnser: .asciiz "Enter the dicPath of dictionary.txt Please\n"


dicPath: .space 1024     #Label for storing the path of the dictionary file
dicFile: .space 65535	 #A label to store the content of the dictionary file
beCompPath: .space 1024	 #Label for storing the path of the file to be compressed
beCompFile: .space 65535 #A label to store the content of the file to be compressed

beDeCompPath: .space 1024	#Label for storing the path of the file to be decompressed
beDeCompFile: .space 65535	#A label to store the content of the file to be decompressed

sprint1: .asciiz "\nThe uncompressed file size = Number of characters x 16 (size of the Unicode)\n= "
sprint12: .asciiz "The compressed file size = Number of binary codes x 16 (code size)\n= "
sprint13: .asciiz "File Compression Ratio = uncompressed file size / compressed file size\n= "
sprint2:  .asciiz " x "
sprint3:  .asciiz " = "
sprint4:  .asciiz " bits "
sprint5:  .asciiz " bytes \n"
sprint6:  .asciiz ","
sprint7:  .asciiz "\nThis means that the compressed file is smaller than the corresponding uncompressed file by "
sprint8:  .asciiz " times\n"
sprint9:  .asciiz "File Compression Ratio = uncompressed file size / compressed file size\n= "
sprint10:  .asciiz " / "

code: .space 4	#A special label for the storage location of the code for the word "Dictionary File"

compPath:  .asciiz "C:\\Users\\hp\\Desktop\\Mars\\Project1\\compressed.txt" #path of the compressed file
compFile: .space 65535		#A label to store the content of the compressed file 

deCompPath: .asciiz "C:\\Users\\hp\\Desktop\\Mars\\Project1\\uncompressed.txt" #path of the decompressed file
deCompFile: .space 65535	#A label to store the content of the decompressed file 

timp1: .space 1024 #A label is a place to temporarily store something to compare words to aid in the compression process
timp2: .space 1024 #A label is a place to temporarily store something to compare words to aid in the compression process
newDictionaryFile: .asciiz "C:\\Users\\hp\\Desktop\\Mars\\Project1\\dictionary.txt"
statment0: .asciiz "\nDo you want to compress or decompress a specific file? \n"
statment1: .asciiz "c: Compress File\n"
statment2: .asciiz "d: Decompress File\n"
statment3: .asciiz "q: quit the program\n"
statment4: .asciiz "Choose one of the options: "
statment5: .asciiz "Enter the path of the file to be compressed:\n"
statment6: .asciiz "Enter the path of the file to be decompressed:\n"
newLine: .asciiz "\n\n"
option1: .byte 'c'   # first option
option2: .byte 'd'   # second option
option3: .byte 'q'   # thirs option
ErrorMessage1: .asciiz "\nPlease choose one of the options\n"
ErrorMessage2: .asciiz "\nPlease choose just 1 or 0 \n"
ErrorMessage3: .asciiz "\nWord isn't in the dictionary or the dictionary is empty\n"
################# Code segment #####################
.text
.globl main
main: # main program entry
	li $v0, 4         #The process of printing a sentence that asks whether there is a directory file or not 
  	la $a0, FirstQu       
   	syscall
	li $v0, 5     #The process of reading an integer number from the user.    
   	syscall
   	li $t1, 1	#Check if one has been entered, meaning the dictionary file exists
   	beq $v0, $t1, yes
   	li $t1, 0 	#Check if one is entered, meaning the file does not exist
   	beq $v0, $t1, no
   	j Error2	#Otherwise, it prints an error statement that no one of the allowed options was entered
yes:	
	#In the event that the answer is that yes, the file exists, we read the directory file and store it after we take the path of the dictionary file
	li $v0, 4          
  	la $a0, yesAnser       #The question about the Path of the Dictionary File
   	syscall
   	
   	li $v0, 8
   	la $a0,dicPath 	# Read the file's path from the user in the form of a string
   	li $a1, 1024
   	syscall
   	
      	
  	 la    $s0, dicPath    # $s0 contains base address of string
 	 add    $s2, $0, $0    # $s2 = 0
         addi    $s3, $0, '\n'    # $s3 = '\n'
loop:
         lb    $s1, 0($s0)    # load character into $s0
         beq    $s1, $s3, end    # Break if byte is newline
         addi    $s2, $s2, 1    # increment counter
         addi    $s0, $s0, 1    # increment str address
         j    loop
end:
         sb    $0, 0($s0)    #replace newline with 0 
          	
      	li $v0, 13
   	la $a0, dicPath	#Open Dictionary File
   	li $a1, 0	#read-only mode
   	syscall
   	move $s0, $v0
   	
   	li $v0, 14 #Read from Dictionary File
   	move $a0, $s0
   	la $a1,dicFile
   	li $a2, 65536
   	syscall
   	 li $v0 4
   	 la $a0,dicFile #Print the content of the directory file
   	 syscall 
   	 
   	 li $v0, 16 #Close the file
   	 move $a0,$s0
   	 syscall  
 	 			
	j menuLoop #Jump to the main menu
			
no:	#If the file does not exist, we will create the file
	
         # creating new file for dictionary.txt
	li $v0, 13          # system call code for "open"
  	la $a0, newDictionaryFile    # load the filename into $a0
 	li $a1, 1        # write-only mode
 	syscall             # call the system to open the file

	move $s0, $v0     # save the file descriptor in $s0
	
	# Close the file
	li $v0, 16        # system call code for "close"
	move $a0, $s0     # load the file descriptor into $a0
	syscall           # call the system to close the file
	

	
menuLoop:
	# Show the main menu
	li $v0, 4          
  	la $a0, statment0       #Do you want to compress or decompress a specific file?
   	syscall	
   	
	li $v0, 4          
  	la $a0, statment1       #c: Compress File
   	syscall
   	
	li $v0, 4          
  	la $a0, statment2       #d: Decompress File
   	syscall
   	
	li $v0, 4          
  	la $a0, statment3       #q: quit the program
   	syscall
   	
  	li $v0, 4          
  	la $a0, statment4       #Choose one of the options:
   	syscall
   	
	li $v0, 12         # system call number for reading a character
   	syscall
   	
        move $t0, $v0
 	li $v0, 4          #Print a new line
  	la $a0, newLine       
   	syscall
   	lb $t1, option1	#Check if compress is selected
   	beq $t0, $t1, compress
   	lb $t1, option2#Check if decompress is selected
   	beq $t0, $t1, deCompress
   	lb $t1, option3 #Check if quit is selected
   	beq $t0, $t1, exit
   	j Error1 #Print an error sentence if one of the options is not selected
   	
compress: 
 	li $v0, 4          
  	la $a0, statment5       
   	syscall	
   	
   	li $v0, 8 	# read the path of the file that we want to compress
   	la $a0,beCompPath
   	li $a1, 1024
   	syscall
   	
      	
  	 la    $s0, beCompPath    # $s0 contains base address of str
 	 add    $s2, $0, $0    # $s2 = 0
         addi    $s3, $0, '\n'    # $s3 = '\n'
loop2:
         lb    $s1, 0($s0)    # load character into $s0
         beq    $s1, $s3, end2    # Break if byte is newline
         addi    $s2, $s2, 1    # increment counter
         addi    $s0, $s0, 1    # increment str address
         j    loop2
end2:
         sb    $0, 0($s0)    #replace newline with 0 
          	
      	li $v0, 13 #open the file
   	la $a0, beCompPath
   	li $a1, 0	# for read only
   	syscall
   	move $s0, $v0
   	
   	li $v0, 14	# read the content
   	move $a0, $s0
   	la $a1,beCompFile
   	li $a2, 65536
   	syscall
   	 li $v0 4 #print the content
   	 la $a0,beCompFile
   	 syscall 
   	 
   	 li $v0, 16	#close the file
   	 move $a0,$s0
   	 syscall 
   	 la $t8, compFile 
   	 li $s4,0 # flag 
   	 li $s6,0 # flag
   	 la $t0,beCompFile # base address for the file that we want to compress it 
 
   	 la $t4,timp1 #taking the address of the timp memory to compare it with dictionary to compress it
   	 
loop3:    #Starting comparing

	 lb $t2,0($t0)#taking the first character
#We can support the program in taking any special character just by adding one line like the following and putting the special character	 
	 beq $t2,' ',special 
	 beq $t2,',',special	 
	 beq $t2,'.',special
	 beq $t2,'!',special
	 beq $t2,'?',special
	 beq $t2,'"',special
	 beq $t2,':',special 
	 beq $t2,'#',special 
	 beq $t2,'$',special 
	 beq $t2,'\r',newline # because the new line stors \r\n
	 beq $t2,'\0',stop
	 li $s6,1 #string 
	 sb $t2,0($t4)
	 addi $t0, $t0, 1 
	 addi $t4, $t4, 1
	 j loop3
stop:
	beq $s6,1,special
	j finishComp 	 	   	 
special:
	beq $s6,0,compChar 
	li $t1,'\0'
        sb $t1,0($t4) #store the special character in temp memory
        li $s6,0
        j compare
        
newline: 
	# in case of newline store the asci code of the new line in temp
	la $t4,timp1
	li $t2,0x5C # means \
	sb $t2,0($t4)
	li $t2,0x6E# means \n
	addi $t4, $t4, 1
	sb $t2,0($t4)
	addi $t0, $t0, 2 
	addi $t4, $t4, 1
	li $t1,'\0'	 #store \0 at the end
	sb $t1,0($t4)
	j compare
compChar: 
	#keep storing the decomp file in timp to compare
	la $t4,timp1
	lb $t2,0($t0)
	sb $t2,0($t4)
	addi $t0, $t0, 1 
	addi $t4, $t4, 1
	li $t1,'\0'
	sb $t1,0($t4)
	j compare
	
storeNewDic:
	la $t2,code
	addi $t2,$t2,3 #0x
	li $s2,4
	move $s3,$s7
	
loopStore:
	#The goal of this code is to create the new code for a new word
	andi $t1,$s3,0x0000000f
	beq $t1,0x00000000,zero
	beq $t1,0x00000001,one
	beq $t1,0x00000002,two
	beq $t1,0x00000003,three
	beq $t1,0x00000004,four
	beq $t1,0x00000005,five
	beq $t1,0x00000006,six
	beq $t1,0x00000007,Seven
	beq $t1,0x00000008,eight
	beq $t1,0x00000009,nine
	beq $t1,0x0000000a,A
	beq $t1,0x0000000b,B
	beq $t1,0x0000000c,C
	beq $t1,0x0000000d,D
	beq $t1,0x0000000e,E
	beq $t1,0x0000000f,F
contee: srl $s3,$s3,4
        sb $t5,0($t2)
	subi $t2,$t2,1
	subi $s2,$s2,1
	beq $s2,$zero,dict #Go to store the new code

	j loopStore
zero:	li $t5,0x30 #zero in the ascii code
	j contee
one: 	li $t5,0x31 #one in the ascii code
	j contee
two:	li $t5,0x32 #two in the ascii code
	j contee
three:  li $t5,0x33 #three in the ascii code
	j contee
four:	li $t5,0x34 #four in the ascii code
	j contee
five:	li $t5,0x35 #five in the ascii code
	j contee
six:	li $t5,0x36 #six in the ascii code
	j contee
Seven:	li $t5,0x37 #Seven in the ascii code
	j contee
eight:	li $t5,0x38 #eight in the ascii code
	j contee
nine:	li $t5,0x39 #nine in the ascii code
	j contee
A:	li $t5,0x61 #A in the ascii code
	j contee
B:	li $t5,0x62 #B in the ascii code
	j contee
C:	li $t5,0x63 #C in the ascii code
	j contee
D:	li $t5,0x64 #D in the ascii code
	j contee
E:	li $t5,0x65 #E in the ascii code
	j contee
F:	li $t5,0x66 #F in the ascii code
	j contee
				
dict: 
      la $t9,code	#Store the address of where the code is stored
      li $t5,4
loopDic:

      lb $t1,0($t9)  # Store the code on the directory
      sb $t1,0($t3)
      addi $t3,$t3,1
      addi $t9,$t9,1
      subi $t5,$t5,1
      beq $t5,$zero,complet
      j loopDic

complet: li $t1,0x20 #Space 
	 sb $t1,0($t3)	#Store the code in the directory
         addi $t3,$t3,1
         la $t9,timp1
loopNew: 	
         lb $t1,0($t9)
         beq $t1,$zero,endloop
         sb $t1,0($t3)	#Store new word in the directory
         addi $t3,$t3,1
         addi $t9,$t9,1
	 j loopNew
endloop: li $t1,'\r'	#Store \r and \n at the end of the new word in the directory
         sb $t1,0($t3)
         addi $t3,$t3,1
         li $t1,'\n'
         sb $t1,0($t3)
         addi $t3,$t3,1
	 j equal		
compare: 
	#Start comparing words for stress
	la $t3,dicFile
	li $s7,0
	la $t9,code
	
	lb $s1,0($t3)
	beq $s1,'\0',storeNewDic #In the event that the dictionary starts empty, we start by creating a new code in the dictionary
	li $t2,4
loopCode:
#Store the code if the words are the same, we store it in the file designated for the result of the compression	
	lb $t1,0($t3)
	sb $t1,0($t9)	
 	subi,$t2,$t2,1
 	addi $t3, $t3, 1
 	addi $t9, $t9, 1
 	beq $t2,0,cont
 	j loopCode
 	
 	
cont: 	addi $t3, $t3, 1#skip the space between the code and the word like: 0000 we\r\n
	la $t5,timp2
 	lb $t2,0($t3)
loopComp:
#Store the word for comparison
	sb $t2,0($t5)
	addi $t3, $t3, 1 
	addi $t5, $t5, 1
	lb $t2,0($t3)
	beq $t2,'\r',ToCommp
	j loopComp
ToCommp: addi $t3, $t3, 2
	 li $t1,'\0'	#You put null at the end of a word to let us know when to stop in the comparison
	 sb $t1,0($t5)
	 j CompareStraing

CompareStraing:
	#Load the addresses of the strings into $a0 and $a1 to comparing
	la $a0, timp1 
	la $a1, timp2 
	
loopStr:
	lb $t6, ($a0)
 	lb $t7, ($a1)
 	  #Compare the characters
  	bne $t6, $t7, not_equal

 	 #Check if the end of the string has been reached
  	beq $t6, $zero, equal
  	addi $a0, $a0, 1
 	addi $a1, $a1, 1
 	j loopStr
 	
not_equal: 
	#In case it is not equal, we search for the next word in the dictionary file
	la $t5,timp2 
	addi $s7,$s7,1
	la $t9,code
	li $t6,4
	
	lb $t7,0($t3)
	beq $t7,'\0',storeNewDic #In the event that there are no words left in the code, we create a new code in the dictionary File
loopCode2:
	# In the event that there are more words, we store the code so that we can store the code in the file to be compressed
	lb $t7,0($t3)
	sb $t7,0($t9)	
 	subi,$t6,$t6,1
 	addi $t3, $t3, 1
 	addi $t9, $t9, 1
 	beq $t6,0,cont2
 	j loopCode2
 	
cont2:	   addi $t3, $t3, 1#skip the space between the code and the word like: 0000 we\r\n
	   lb $t2,0($t3)
	   j loopComp #Back for the next word comparison
equal:	#In the event that the word is equal to the definition to be compressed, we store the code in a place in the memory until we store it in the compressed file
	la $t9,code 
	#Store the first number in hexadecimal from the left
	lb $t1,0($t9)
	sb $t1,0($t8)
	addi $t8, $t8, 1
	addi $t9, $t9, 1
	#Store the second number in hexadecimal from the left
	lb $t1,0($t9)
	sb $t1,0($t8)
	addi $t8, $t8, 1
	addi $t9, $t9, 1
	#Store the third number in hexadecimals from the left
	lb $t1,0($t9)
	sb $t1,0($t8)
	addi $t8, $t8, 1
	addi $t9, $t9, 1
	#Store a quarter and the last number in hexadecimal from the left
	lb $t1,0($t9)
	sb $t1,0($t8)
	addi $t8, $t8, 1
	addi $t9, $t9, 1
	#Store enter to separate codes in the compressed file
	li $t1,'\r'
	sb $t1,0($t8)
	addi $t8, $t8, 1
	addi $t9, $t9, 1
	li $t1,'\n'
	sb $t1,0($t8)
	addi $t8, $t8, 1
	la $t4,timp1
	j loop3 # to check the spetial character

   	 
    	 
finishComp: 
	 la $t0,beCompFile
	 li $s0,0 #wee\0
loopUnCompressed:
	#Count the number of characters in the file to be compressed
	lb $t2,0($t0)
	addi $t0,$t0,1
	beq $t2,'\0', next 	# if we reached the end of file go to size calculation
	beq $t2,'\r',skip 	# else keep uncompressing
	addi $s0,$s0,1
skip:	j loopUnCompressed
next:
	move $s6,$s0
	li $s1,16	# The uncompressed file size = Number of characters x 16 (size of the Unicode)
	mul $s2,$s0,$s1 	#Number of characters x 16 (size of the Unicode)
	
	#Various print sentences
	 li $v0 4
   	 la $a0,sprint1 
   	 syscall
	move $a0,$s0
	 li $v0 1
   	 syscall
   	 
   	 li $v0 4
   	 la $a0,sprint2
   	 syscall
   	 
   	  move $a0,$s1
   	 li $v0 1
   	 syscall
   	 
   	 li $v0 4
   	 la $a0,sprint3
   	 syscall
   	 
   	 li $v0, 1       
	move $a0,$s2  
	syscall
	
	li $v0 4
   	 la $a0,sprint4
   	 syscall
   	 
   	 li $v0 4
   	 la $a0,sprint3
   	 syscall
   	 move $s3,$s2
   	 li $t3,0  
   	 
loopByt: blt $s3,8,printByte
	 subi $s3,$s3,8
	 addi $t3,$t3,1
	  j loopByt 	 
printByte:  
	move $a0,$t3
   	li $v0 1
   	syscall 
   	li $v0 4
   	 la $a0,sprint5
   	 syscall

	 la $t1, compFile 
	 li $s0,0
loopCompressed:
	#Count the number of characters in the compressed file
	lb $t2,0($t1)
	addi $t1,$t1,1
	beq $t2,'\0', next2	# if end of file go to calculations
	beq $t2,'\r',addone	#if \r (newLine) add 1 to the address and keep compressing
	beq $t2,'\n',skip2	#if \n (newLine)  add 1 to the address and keep compressing
skip2:	j loopCompressed
addone:addi $s0,$s0,1
	j loopCompressed
next2:
  	li $s1,16
   
  	mul $s3,$s0,$s1 # Number of binary codes x 16 (code size)
  	 li $v0 4
   	 la $a0,sprint12	#The compressed file size = Number of binary codes x 16 (code size)
   	 syscall
	move $a0,$s0
	 li $v0 1
   	 syscall
   	 #Various print sentences
   	 li $v0 4
   	 la $a0,sprint2
   	 syscall
   	 
   	  move $a0,$s1
   	 li $v0 1
   	 syscall
   	 
   	 li $v0 4
   	 la $a0,sprint3
   	 syscall
   	 
   	 move $a0,$s3
   	 li $v0 1
   	 syscall
   	 
   	 li $v0 4
   	 la $a0,sprint4
   	 syscall
   	 
   	 li $v0 4
   	 la $a0,sprint3
   	 syscall
   	 
   	 move $s1,$s3
   	 li $t3,0  
loopByt2: blt $s1,8,printByte2
	 subi $s1,$s1,8
	 addi $t3,$t3,1
	  j loopByt2 	 
printByte2:  
	move $a0,$t3
   	li $v0 1
   	syscall 
   	li $v0 4
   	 la $a0,sprint5
   	 syscall
   	 mtc1 $s0,$f0
   	 mtc1 $s6,$f1
   	 div.s $f12, $f1,$f0	#File Compression Ratio = uncompressed file size / compressed file size
   	
   	  
   	  li $v0 4
   	 la $a0,sprint9
   	 syscall
   	 move $a0,$s6
   	 li $v0 1
   	  syscall
   	    li $v0 4
   	 la $a0,sprint10
   	 syscall
   	 move $a0,$s0
   	 li $v0 1
   	  syscall
   	 li $v0 4
   	 la $a0,sprint3
   	 syscall 
   	  li $v0, 2       # Load the system call number for printing a float (2)
         syscall         # Trigger the system call to print the float 
   	 
  	  # Print floating-point result
  	li $v0 4
   	 la $a0,sprint7
   	 syscall
         li $v0, 2       # Load the system call number for printing a float (2)
         syscall         # Trigger the system call to print the float         
	li $v0 4
   	 la $a0,sprint8
   	 syscall
  	  
  	  li $v0, 13	#open the file that we want to write the compressed in
   	la $a0, compPath
   	li $a1, 1	#make it for write only
   	syscall
   	move $s0, $v0
   	
   	li $v0, 15	# wrtie to our compressed string to the file
   	move $a0, $s0
   	la $a1,compFile
   	li $a2, 65536
   	syscall 
   	 
   	 li $v0, 16	#close the file
   	 move $a0,$s0
   	 syscall 
   	 
   	 li $v0, 13	#open the dictionary file
   	la $a0, newDictionaryFile
   	li $a1, 1	#make it for write only
   	syscall
   	move $s0, $v0
   	
   	li $v0, 15	# wrtie to our new dictionary string to the file
   	move $a0, $s0
   	la $a1,dicFile
   	li $a2, 65536
   	syscall 
   	 
   	 li $v0, 16	#close the file
   	 move $a0,$s0
   	 syscall 
    	 j menuLoop
    	 

   	  j exit    	 
deCompress:  
	
      	li $v0, 13	#open the dictionary file
   	la $a0, newDictionaryFile
   	li $a1, 0	#make it for read only
   	syscall
   	move $s0, $v0
   	
   	li $v0, 14	# read our dictionary file
   	move $a0, $s0
   	la $a1,dicFile
   	li $a2, 65536
   	syscall
   	 li $v0 4
   	 la $a0,dicFile	#close the file
   	 syscall 
   	 
   	 li $v0, 16
   	 move $a0,$s0
   	 syscall 
   	 
    	li $v0, 4          
  	la $a0, statment6       
   	syscall	
   	 
   	li $v0, 8	#enter the path of the file we want to decompress
   	la $a0,beDeCompPath
   	li $a1, 1024
   	syscall
 
  	 la    $s0, beDeCompPath    # $s0 contains base address of str
 	 add    $s2, $0, $0    # $s2 = 0
         addi    $s3, $0, '\n'    # $s3 = '\n'
loop22:
         lb    $s1, 0($s0)    # load character into $s0
         beq    $s1, $s3, end22    # Break if byte is newline
         addi    $s2, $s2, 1    # increment counter
         addi    $s0, $s0, 1    # increment str address
         j    loop22
end22:
         sb    $0, 0($s0)    #replace newline with 0 
  	
      	li $v0, 13	#read the path
   	la $a0, beDeCompPath
   	li $a1, 0
   	syscall
   	move $s0, $v0
   	
   	li $v0, 14	#open the   file
   	move $a0, $s0
   	la $a1,beDeCompFile
   	li $a2, 65536
   	syscall
   	 li $v0 4
   	 la $a0,beDeCompFile
   	 syscall 
   	 
   	 li $v0, 16	#close the file
   	 move $a0,$s0
   	 syscall
   	li $t4,0
   	li $t5,0
   	 la $t0,beDeCompFile # base address for the file that we want to decompress it 
 	 la $t1,dicFile	# base address for the file that we want to dictionary it
	 la $t7,deCompFile 
loop33:
	lb $t2,0($t0) #address of decommpressed file
	lb $t3,0($t1) #address of dictionary file
	beq $t3,'\0', errordecomp #check if the word is not in the dictionary file
	addi $t0,$t0,1 #go to next address in compressed file
	addi $t1,$t1,1 #go to next address in dictionary file
	addi $t4,$t4,1 #counter to check equality
	addi $t5,$t5,1 #counter to count number of letters back
	beq $t4,5,equal1
	beq $t2,'\0',print_in_file 
	bne $t2,$t3, not_equal1
        j loop33
not_equal1:
	
	li $t4,0 #counter back to zero
	lb $t3,0($t1)
	addi $t1,$t1,1
	bne $t3,'\n',check_end_file #keep moving until next line in the dictionary
	
       #subi $t5,$t5,1 
	sub $t0,$t0,$t5 #back to the beggining of the word
	li $t5,0 #counter back to zero
	
	j loop33
equal1:
	li $t5,0 #counter back to zero
	li $t4,0 #counter back to zero
	lb $t3,0($t1)
	beq $t3,'\r', space1	# if the code is for space
	beq $t3,0x5C newLine1	# check if the code is for newline
	
equal_loop:	
	lb $t3,0($t1)	# load the addres of the chcarter we want to store
	sb $t3,0($t7)  # store character in the decompressed file
	addi $t1,$t1,1	# go to the next character
	addi $t7,$t7,1	# move to the next address of the compressed file 
	lb $t3,0($t1)
	bne $t3,'\r', check0	#check for new line	
	
continueCompare:
	la $t1,dicFile #return the dictionary file back to the beggining
	addi $t0,$t0,1 #skip for \n newLine
	
	j loop33
	
space1:
	sub $t1,$t1,1	# go back by 1 to store space
	j equal_loop
check0:
	bne $t3,'\0',equal_loop		#check if the dictionary file ended
	j continueCompare
newLine1:
	#store new line in the file
	li $t2,'\r'
	sb $t2,0($t7)
	li $t2,'\n'
	addi $t7, $t7, 1
	sb $t2,0($t7)
	addi $t1, $t1, 2 	# go to next word in dictionary
	addi $t7, $t7, 1
	sb $t2,0($t7)
	la $t1,dicFile #return the dictionary file back to the beggining
	addi $t0,$t0,1 #skip for \n newLine
j loop33

check_end_file:
	bne $t3,'\0',not_equal1
	j errordecomp
						
errordecomp:	#print error message if word not found
	li $t5,0 #counter back to zero
	li $t4,0 #counter back to zero
	li $v0,4
	la $a0,ErrorMessage3
	syscall
	
	la $t1,dicFile #return the dictionary file back to the beggining
	addi $t0,$t0,2 #skip for \r\n newLine
	
j menuLoop #back to menu after error happens

  print_in_file:
        li $v0, 13	#open the file that we want to print decompressed data in
   	la $a0, deCompPath
   	li $a1, 1	#make it for write only
   	syscall
   	move $s0, $v0
   	
   	li $v0, 15	#write to the file
   	move $a0, $s0
   	la $a1,deCompFile	
   	li $a2, 65536
   	syscall 
   	 
   	 li $v0, 16	#close the file
   	 move $a0,$s0
   	 syscall 
   	 
j menuLoop    	 #back to menu after finishing
	
Error1: 
	li $v0, 4          
  	la $a0, ErrorMessage1       
   	syscall
   		
	j menuLoop	
Error2: 
	li $v0, 4          
  	la $a0, ErrorMessage2       
   	syscall	
   	j main
   	
	j menuLoop
exit:	li $v0, 10 # Exit program
	syscall
