#include<stdio.h>

void foo(){printf("hello foo!");}
void goo(){printf("hello goo!");}

void main(){
  int x = 1;
  void (*r)() = &foo;
  void (*s)() = &goo;
  void (*p)();
  if(x)
    p = r;
  else
    p = s;
  p(); // print the called function name
}
