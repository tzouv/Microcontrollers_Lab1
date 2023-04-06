#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <uart.h>

extern int hash_function(char s[]);
extern int factorial_function(int x);

uint8_t lookup_table[26] = {10, 42, 12, 21, 7, 5, 67, 48, 69, 2, 36, 3, 19, 1, 14, 51, 71, 8, 26, 54, 75, 15, 6, 59, 13, 25};


  int main(){
	
		int hash = 0;
		int hash_2 = 0;
		
		char s[100];
		int fractional = 0;
		uart_init(115200);
		uart_enable();
	
	
		printf("Give me the string\n");
		scanf("%s",s);
		
		hash = hash_function(s);
		hash_2 = hash;
		printf("\nHash number: %d", hash);
		printf("\nHash number: %d", hash_2);
		char str2[10];	
		char str1[100] = "Hash number: ";
		sprintf(str2, "%d", hash_2);
		strcat(str1, str2);
		printf("%s",str1);	
		uart_print(str1);
		
		fractional = factorial_function(hash);
		char str4[10];
		char str3[100] =  "The fractional is : ";
		sprintf(str4, "%d", fractional);
		strcat(str3, str4);
		uart_print(str3);
		
		
		printf("\nThe fractional is : %d", fractional);

		return 0;
}

