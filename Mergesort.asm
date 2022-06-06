
# kuan yang
# kxy200010 
# this program takes user input of integers and merge sort in ascending order. Mergesort was calld repeatedly to sort the array.

.data 
    input: .asciiz "How many integers do you want in the array: "  #pompt for input
    
    list: .space 200  #  allocate space for myArray
    
    listLength: .asciiz "Enter the integers to be sorted one at a time: "
    
    nextLine: .asciiz "\n"
    
    feedback: .asciiz "You have entered: "
    
    result: .asciiz "Sorted list after merge sort: "  #print input label
    
    Space:  .asciiz    " "   #space 

     
     
.text

main:      
     li $v0, 4       #to prin out input prompt 
     
     la $a0, input
     
     syscall 

                      
    li $v0, 5         #read how many integers to be sorted 
    
    syscall
    
    addi $t0, $v0, 0  #save user inpu o $t0
    
    move $s5, $t0     # save user input o $s5 for later use 
    

        
    addi $t7, $t0, 0  #save user inpu o $t7 for later use
    
    li $t4, 4
       
    li $v0, 4
    
    la $a0, listLength   #ask user to input numbers of the arrayToBeSorted
    
    syscall

    li $t6, 0   #used to index array at insertion
   
    j loop0
    

               #read the numbers 
loop0:         #loop  in n integers and stores them in a list

            
     beq $t7, 0, next     #check if input is 0 
            
     li $v0, 5            #take in user input
        
     syscall
            
     sb $v0, list($t6)   #store user input into list, used save byte instead of sw . it does no rquird word alignd
       
     addi $t6, $t6, 4       #add 4 to the index of the list
            
     addi $t7, $t7, -1      # decrement the number of int to be entered 
            #loop
     j loop0

next: #success print
        
     move $t0, $t6
        
     li $v0, 4
        
     la $a0, feedback
        
     syscall
        
     j while 


 while: #printer success

        #print new line
     li $v0, 4
        
     la $a0, Space
        
     syscall

     beq $t6, $zero, begin  #dif i is 0 then exit
           
     lb $t1, list($t3)  #load in my array at index i
           
        
       #printing int at myArray[i]
      li $v0, 1
       
      move $a0, $t1
       
      syscall  

      addi $t3, $t3, 4
       
      addi $t6, $t6, -4

      j while 

begin:

     la   $a0, list       # Load the start address of the array
   
     addi   $t0, $s5,0   # Load the array length
   
     sll   $t0, $t0, 2       # Multiple the array length by 4 (the size of the elements)
   
     add   $a1, $a0, $t0   # Calculate the array end address
   
     jal   mergesort       # Call the merge sort function
   
      b   sortend       # We are finished sorting
  

# mergesort function
#
# $a0 is first address of the array
# $a1 is last address of the array
#

mergesort:

   addi   $sp, $sp, -16   # Adjust stack pointer
   
   sw   $ra, 0($sp)       # Store the return address on the stack
   
   sw   $a0, 4($sp)       # Store the array start address on the stack
   
   sw   $a1, 8($sp)       # Store the array end address on the stack
  
   sub    $t0, $a1, $a0   # Calculate the difference between the start and end address (i.e. number of elements * 4)

   ble   $t0, 4, mergesortend   # If the array only contains a single element, just return
  
   srl   $t0, $t0, 3       # Divide the array size by 8 to half the number of elements (shift right 3 bits)
   
   sll   $t0, $t0, 2       # Multiple that number by 4 to get half of the array size (shift left 2 bits)
   
   add   $a1, $a0, $t0   # Calculate the midpoint address of the array
   
   sw   $a1, 12($sp)   # Store the array midpoint address on the stack
  
   jal   mergesort       # Call recursively on the first half of the array
  
   lw   $a0, 12($sp)   # Load the midpoint address of the array from the stack
   
   lw   $a1, 8($sp)       # Load the end address of the array from the stack
  
   jal   mergesort       # Call recursively on the second half of the array
  
   lw   $a0, 4($sp)       # Load the array start address from the stack
   
   lw   $a1, 12($sp)   # Load the array midpoint address from the stack
   
   lw   $a2, 8($sp)       # Load the array end address from the stack
  
   jal merge  # Merge the two array halves
  
mergesortend:              

   lw   $ra, 0($sp)       # Load the return address from the stack
   
   addi   $sp, $sp, 16   # Adjust the stack pointer
   
   jr   $ra       # Return
  
#
# Merge  sorted arrays into one
#
# $a0 First address of first array
# $a1 First address of second array
# $a2 Last address of second array
#

merge:

   addi   $sp, $sp, -16   # Adjust the stack pointer
   
   sw   $ra, 0($sp)       # Store the return address on the stack
   
   sw   $a0, 4($sp)       # Store the start address on the stack
   
   sw   $a1, 8($sp)       # Store the midpoint address on the stack
   
   sw   $a2, 12($sp)   # Store the end address on the stack
  
   move   $s0, $a0       # Create a working copy of the first half address
   
   move   $s1, $a1       # Create a working copy of the second half address
  
  
mergeloop:

   lb   $t0, 0($s0)       # Load the first half position pointer
   
   lb   $t1, 0($s1)       # Load the second half position pointer
   #lw   $t0, 0($t0)       # Load the first half position value
   #lw   $t1, 0($t1)       # Load the second half position value
  
   bgt   $t1, $t0, noshift   # If the lower value is already first, don't shift
  
   move   $a0, $s1       # Load the argument for the element to move
   
   move   $a1, $s0       # Load the argument for the address to move it to
   
   jal   shift       # Shift the element to the new position
  
   addi   $s1, $s1, 4       # Increment the second half index
   
noshift:
   addi   $s0, $s0, 4       # Increment the first half index
  
   lw   $a2, 12($sp)       # Reload the end address
   
   bge   $s0, $a2, mergeloopend   # End the loop when both halves are empty
   
   bge   $s1, $a2, mergeloopend   # End the loop when both halves are empty
   
   b   mergeloop
  
mergeloopend:
  
   lw   $ra, 0($sp)       # Load the return address
   
   addi   $sp, $sp, 16   # Adjust the stack pointer
   
   jr    $ra       # Return

#
# Shift an array element to another position, at a lower address
#
#  $a0 address of element to shift
#  $a1 destination address of element
#

shift:

   addi   $t0, $s5,0 
   
   ble   $a0, $a1, shiftend   # If we are at the location, stop shifting
   
   addi   $t6, $a0, -4       # Find the previous address in the array
   
   lb   $t7, 0($a0)       # Get the current pointer
   
   lb   $t8, 0($t6)       # Get the previous pointer
   
   sb   $t7, 0($t6)       # Save the current pointer to the previous address
   
   sb   $t8, 0($a0)       # Save the previous pointer to the current address
  
    move   $a0, $t6       # Shift the current position back
   
   b    shift           # Loop again
   
shiftend:

   jr   $ra           # Return
  
sortend:               # Point to jump to when sorting is complete


# Print out the indirect array
   
  li  $t0, 0              # Initialize the current index
  
  la	$a0, nextLine	# Set the value to print to the newline
  
  li	$v0,4				
   
  syscall
   
  la $a0, result  #print the result prompt
   
  li $v0, 4 
   
  syscall
   
  
   
    
printloop:
  
   
   addi   $t1, $s5,0           # Load the array length
   
   bge   $t0,$t1,printdone      # If reach the sizeof the array, print over
   
   sll   $t2,$t0,2           # Multiply the index by 4 (2^2)
   
   la   $t3,list($t2)      # Get the address of item to be printed 
   
   lb   $a0,0($t3)           # Get the value pointed to and store it for printing
   
   li   $v0,1              
   
   syscall                   # Print the value
   
   la   $a0, Space            # print space
   
   li   $v0,4              
   
   syscall                   # Print the value
   
   addi   $t0,$t0,1           # Increment the current index
   
   b   printloop               # loop print

printdone:                     # finishd the program 
   
   li   $v0,10
   
   syscall
  


