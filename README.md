# Microprocessors and Peripherals : 1st Lab.
**ARM assembly for the STM32 nulceo microcontroller**


Authors: Konstantinidis Paschalis, Tzouvaras Evangelos.

Team : 5 

### Lab Description: ###

  In the first lab of the course we got familiar with the use of assembly in ARM microcontrollers and we wrote some code at it using Keil's tools. More specifically, at first we've been told to implement a basic main() routine in C language in which we should provide with dynamical way the alpharithmetic which will be controlled with the help of UART. Next step was to implement an assembly routine which would compute a hash from a string of characters that the user has given based on some assumptions. After that we had to implement another assembly routine which would compute the onedigit of the hash and its factorial, while later it will store its value in memory and will return it in main.The hash will be calculated by the below ***lookup_table***.
  
### lookup_table ###

|  Char | Hash value |  Char | Hash value |  Char | Hash value |
| ------|:----------:|:-----:|:----------:|:-----:|:----------:|
|   a   |     10     |   j   |      2     |   s   |     26     |
|   b   |     42     |   k   |     36     |   t   |     54     |
|   c   |     12     |   l   |      3     |   u   |     75     |
|   d   |     21     |   m   |     19     |   v   |     15     |
|   e   |      7     |   n   |      1     |   w   |      6     |
|   f   |      5     |   o   |     14     |   x   |     59     |
|   g   |     67     |   p   |     51     |   y   |     13     |
|   h   |     48     |   q   |     71     |   z   |     25     |
|   i   |     69     |   r   |      8     |       |            |
  
 
 ### Assumptions ###
  * For each small letter of the alphabet the function will add its hash value to the hash.
  * For each number the function will substract the number from the hash.
  * The hash value does not get affected by a character that is not a small letter or a number.
  * We should add the digits of the hash until we get to a single digit number and then find the factional of the single digit hash.
  
  
### **C routine for uart use:** ###
  * First we put a : `printf("Give me the string\n");`command, ***line: 23***, in order to get the string from Keil.
  * After that we took the string with the `scanf("%s",s);` command, ***line: 24***, to store it.
  * Next after we compute the hash and convert it from an int to a string , we modify it and to store it to a variable in order to print out the hash with the `uart_print(str1);` command, ***line: 35***.
  * The same process is followed in order to print out the factional of the hash which is done by the `uart_print(str3);` command, ***line : 42***.


### Assebly routine for hash compute: ###
  In an .s file we built a hash_function which takes as an argument a `(char s[])`
 and stores the starting address of the string s in the `r0` register. We also 
 have import the lookup_table from the c.file using the command `.extern 
 lookup_table` and then we load to `r1` the address of the first lookup_table array 
 element. Then we load to the `r8` the `r0` value which is the first element of the string. Later we initiate the registers we want to use ( `r4 ,r3 ,r5` ).
 
 * In the assembly function we use a while loop to read each character of the string and if the ` s[i] == '\0' ` we break the loop and exit the funciton.
 * After that we check if the character of the string is between **a-z**. If yes we add to the hash its hash_value based on the **lookup_table**.
 * On the next step we check if the character of the string is a number between **0-9**. If yes we substract from the hash the number.
 * If the character is not between **a-z** neither **0-9** we check for the next char until we finish.



### Assembly routine for factorial compute: ###
  In the same .s file we built the factorial_function that takes as an argument the hash which was calculated before by the hash_function. The argument of the function is been stored in `r0`. We also save argument value in the temp register `r3`.Afte that we initialise the registers we want to use (`r2, r11, r12`).
  
 * 


