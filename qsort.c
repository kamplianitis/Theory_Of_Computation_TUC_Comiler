#include "pilib.h"


/* program */ 

void swap(int* a , int i , int j)
{
int temp; 
temp = a[i];
a[i] = a[j];
a[j] = temp;
}
void quickSort(int* a , int low , int high)
{
int pivot, i, j; 
if (low < high)
{
pivot = low;
i = low;
j = high;
while(i < j) 
{
while(a[i] <= a[pivot] && i < high)
 i = i + 1;
while(a[j] > a[pivot])
 j = j -1;
if (i < j) 
 swap (a , i , j);
}
swap (a , pivot , j);
quickSort (a , low , j -1);
quickSort (a , j + 1 , high);
}
}
void printArray(int* a , int size)
{
int i; 
for (i = 0; i < size; i = i + 1) 
 	{
writeInt (a[i]);
if (i == size -1) 
 continue;
writeString (", ");
	}
writeString ("\n");
}

int main() {
const int aSize = 10, bSize = 100;
int b[100], i; 
for (i = 0; i < bSize; i = i + 1) 
 b[i] = bSize -i;
quickSort (b , 0 , bSize -1);
printArray (b , bSize);
} 
