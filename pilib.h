#ifndef PILIB_H
#define PILIB_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void writeString(const char* s) {printf("%s", s);}
void writeReal(double n) { printf("%0.3lf",n); } 
void writeInt(int n) { printf("%d",n); } 

char* strdup(const char*);

#define BUFSIZE 1024

char* readString() {
  char buffer[BUFSIZE];
  buffer[0] = '\0';
  fgets(buffer, BUFSIZE, stdin);
  
  /* strip newline from the end */
  int blen = strlen(buffer);
  if (blen > 0 && buffer[blen-1] == '\n')
    buffer[blen-1] = '\0';

  return strdup(buffer);
}
#undef BUFSIZE

double readReal() { return atof(readString()); }
int readInt() { return atoi(readString()); }

#endif 
