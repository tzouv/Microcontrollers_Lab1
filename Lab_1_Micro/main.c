/* Authors: Konstantinidis Paschalis, Tzouvaras Evangelos */
/* Aristotle University of Thessaloniki, April 2023 */
/* Microprocessors and Peripherals Course: 1st lab, ARM Assembly language */

/* This is the code in keil uVision*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <uart.h>

// Declare the assembly functions that the C will use
extern int hash_function(char s[]);
extern int factorial_function(int x);

// A global lookup table array
uint8_t lookup_table[26] = {10, 42, 12, 21, 7, 5, 67, 48, 69, 2, 36, 3, 19, 1, 14, 51, 71, 8, 26, 54, 75, 15, 6, 59, 13, 25};


	// The main function that calls the two assembly functions and controls the communication with nucleo board via UART
  int main(){
	
		int hash = 0;																						// The hash variable that the assembly function will return
		int factorial = 0;																				// The factorial that the second function will return
		char s[100];																							// An array to save the string that the user will give
		
		// Set up the UART communication
		uart_init(115200);																			// Baud rate at 115200
		uart_enable();																					// Enable the UART
	
		printf("Give me the string\n");										// A message to user to give the string
		scanf("%s",s);																					// Save the string that the user gives
		
		hash = hash_function(s);													// Call the hash function and save the value into the hash variable
		printf("\nHash number: %d", hash);						// Print the Hash number at the console

		char str2[10];																						// A string to save the output of the hash function
		char str1[100] = "Hash number: ";							// A string to print
		sprintf(str2, "%d", hash);													// Convert the integer hash into string
		strcat(str1, str2);																			// String 1 and string 2 union																		
		uart_print(str1);																				// Print the final string via UART communication
		
		factorial = factorial_function(hash);						// Call the factorial function and save the value into the factorial variable
		printf("\nThe fractional is : %d", factorial);		//  Print the Hash number at the console
		
		char str4[10];																						// A string to save the output of the factorial function
		char str3[100] =  "The fractional is : ";				// A string to print
		sprintf(str4, "%d", factorial);											// Convert the integer factorial into string
		strcat(str3, str4);																			// String 3 and string 4 union				
		uart_print(str3);																				// Print the final string via UART communication

		return 0;
}

