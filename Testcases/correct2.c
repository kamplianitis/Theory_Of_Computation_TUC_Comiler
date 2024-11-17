#include "pilib.h"


/* program */ 

int checkPrime(int n)
{
int i, isPrime = 1;
for (i = 2; i <= n / 2; i = i + 1) 
 	{
if (n % i == 0)
{
isPrime = 0;
break;
}
	}
return isPrime;
}

int main() {
int n, i, flag = 0;
writeString ("Enter a positive integer: ");
n = readInt ();
for (i = 2; i <= n / 2; i = i + 1) 
 	{
if (checkPrime (i) == 1)
{
if (checkPrime (n -i) == 1)
{
printf ("%d = %d + %d\n" , n , i , n -i);
flag = 1;
}
}
	}
if (flag == 0) 
 printf ("%d cannot be expressed as the sum of two prime numbers." , n);
return 0;
} 
