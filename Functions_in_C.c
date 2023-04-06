/* Authors: Konstantinidis Paschalis, Tzouvaras Evangelos */
/* Aristotle University of Thessaloniki, April 2023 */
/* Microprocessors and Peripherals Course: 1st lab, ARM Assembly language */

/* This is the code in C for the first lab of microcontrollers cource in auth */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Look up table for for matching each letter (a-z) to a number
// Global array, all the functions have access here
// lookup_table[0] -> a, lookup_table[1] -> b etc.
int lookup_table[26] = {10, 42, 12, 21, 7, 5, 67, 48, 69, 2, 36, 3, 19, 1, 14, 51, 71, 8, 26, 54, 75, 15, 6, 59, 13, 25};

int main(){

    // An array to save the string that the user gives
	char s[100];

    // Message to the user to give the string
    printf("\n Give me the string: ");

    // Read the string and save it into the s variable
    scanf("%s", s);

    // Print the output of the function that calculates the hash number of a string
	printf("\nHash number: %d", hash(s));

    // Print the output of the function that calculates the one-digit hash of a string and its factorial
    printf("\nFactorial: %d", factorial_c(hash(s)));

	return 0;
}

// This function calculates the hash of a string based on the lookup table
int hash(char s[]){                                 // Argument: the string value
	int i = 0;                                      // Counter value for the while loop
	int hash = 0;                                   // The hash number that the function will return

	while(s[i] != '\0'){                            // Do this loop until you find the end character of the string s
        int temp = 0;                               // A temporary value to save the char value in ASCII
		temp = (int)(s[i]);                         // Typecast each char into integer to take the ASCII value
		if(temp >= 97 && temp <= 122){              // Check if the character value is between 97 and 122 (between a and z)
			hash += lookup_table[s[i] - 97];        // Then add on the hash, the value that is based on the lookup table (offset 97, to take the correct value form the array)
		}
		else if (temp >= 48 && temp <= 57){         // Check if the character value is between 48 and 57 (between 0-9)
			hash -= (temp-48);                      // Then sub this value from the hash (offset 48 to take a value between 0 and 9
		}
		else                                        // Else keep the hash as it is
			hash = hash;
        i++;                                        // Increase the i variable for the next iteration
	}

	return hash;                                    // After the loop, return the hash value
}

// This function calculates the one-digit hash of a given hash x, and then its factorial
int factorial_c(int x){                             // Argument: a hash number x
    int factorial = 1;                              // Initialize the factorial at value 1
    int new_hash = x;                               // Save the hash value at another variable, to be able to change it at the function

    if (new_hash <= 0)                              // In case of negative hash, return as factorial number the zero value
        factorial = 0;

    // Do this iteration until the new hash is one digit value (lower than 10)
    while (new_hash >= 10){
        new_hash = 0;                               // On each iteration make the new hash zero, we need to calculate the hash again based on the new number x
        int counter = 0;                            // Counter that counts the number of digits of each hash
        int j = 0;                                  // j helpful variable for the for loop

        int divider = 10;                           // This is the divider of the hash
        int num = x;                                // The num is another variable to save the number x, helpful variable for the step 3

        /* Example: 123-> 1+2+3, to find the 1 we need to divide the
         123/100 = 1 ,  123%100 = 23
         23/10 = 2 , 23%10 = 3
         3/1 = 3, 3%1 = 0
         Step 1: Find the number of the digits
         Step 2: Create the maximum divider (here the 100), based on the number of digits
         Step 3: Calculate the division and the modulo value on each iteration
         Step 4: Calculate the factorial of the new hash number
        */

        // Here the Step 1:
        // This while loop is for find the number of digits of the given number
        while(x >= 1){                              // While the x is grater than 1
            x = x/10;                               // Divide the x with 10
            counter ++;                             // Increase the counter that saves the number of digits
        }

        // Here the Step 2:
        // This for loop creates the maximum initial divider to divide the hash, ex: for 123 the 100
        for(j = 0; j < (counter - 2); j++)          // Because the first divider is 10, counter -1 and because of j = 0 on the first iteration, counter-2 totally
            divider *= 10;

        //Here the Step 3:
        // Divide the number with ..,100, 10, 1
        while(divider >= 1){
            new_hash += num / divider;              // Add on the hash the result of the division, between the num and the divider
            num = num % divider;                    // Now, the new num value is result of the modulo value
            divider /= 10;                          // The new divider will be one class lower than the previous value
        }
        x = new_hash;                               // The x variable (number that we will calculate its hash if it is grater than 10, is the new hash)
    }

    // Print the new hash (final hash), whose we will calculate the factorial
    printf("New hash: %d", new_hash);

    // Step 4: Calculate the factorial
    // Algorithm: n! = n*(n-1)*...*1
    while(new_hash >= 1){                           // While the new_hash is grater than 1
        factorial *= new_hash;                      // Factorial will be *= new _hash
        new_hash -= 1;                              // Decrease the new hash (-=1)

    }

    return factorial;                               // Finally, return the factorial
}
