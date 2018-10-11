#include<stdio.h>

void foo(){}
void goo(){}
void (*m)() = &foo;
void (*n)() = &goo;


void main(){
  int x = 1;
  void (*r)() = m;
  void (*s)() = n;
  void (*p)();
  if(x)
    p = r;
  else
    p = s;
  p(); // print the called function name
}
