# OverCG
Generate call graph of c program from its corresponding LLVM IR

# Usage
	python OverCG.py -h
	usage: OverCG.py [-h] [-i INPUT] [-o OUTPUT] [-e] [-s]
	
	optional arguments:
	  -h, --help            show this help message and exit
	  -i INPUT, --input INPUT
	                        the input file
	  -o OUTPUT, --output OUTPUT
	                        the output file
	  -e, --externalNode    make call graph with external node
	  -s, --show            show the call graph using xdot
	  
# example
If we want to get the call graph of the following c program,

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
	
we can use the opt tool in LLVM, like this,
>	opt --dot-callgraph test1.ll --disable-output
>	xdot callgraph.dot

The above command will output the following call graph,
![cg1](./test1.png  "call graph of test1.c")

it is not accurate, since the opt tool can noly process the directly call.
However, when using OverCG, we can get the following call graph,
![cg2](./test11.png  "call graph of test1.c")