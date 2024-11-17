#include "pilib.h"


/* program */ 

int check(int* a)
{
a[2] = 1821;
return a[2];
}

int main() {
int numbers[3];
numbers[0] = 0;
numbers[1] = 1;
numbers[2] = numbers[1];
writeInt (numbers[2]);
writeString ("\n");
numbers[0] = check (numbers);
writeInt (numbers[2]);
writeString ("\n");
} 
