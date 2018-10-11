import re
import argparse
import linecache
import subprocess

def generateCallGraph(programIR=None, withExternalNode=False):
    '''
    This function is used to generate the call graph of a c program from it's
    LLVM IR. The basic idea of this function is the pointer analysis of the identifiers.
    If an identifier in a function A points to a function B (directly or indirectly), I define 
    that this function A calls function B.
    programIR: the readabel LLVM IR, that is, the file ended with '.ll'.
    withExternalNode: if this is true, an external node will be added to the call graph, 
                     such that there is an edge from this external node to the node in 
                     the all graph.
    return: the call graph as a string using dot formate, so the user can use networkx  
            or pygraphviz to analysis it.
    '''
    lines = linecache.getlines(programIR)
    #first, get the  identifiers of functions
    #the functions defined by user are started with "define", while the functions
    #of other libraries are started with "declare"
    
    funcId = []      #the identifiers of functions
    globalIdRef = {} #the relationship among Ids    
    IdInFunc = {}    #identifiers in function
    
    #in LLVM IR, the identifer of a function is treated as a global identifer 
    #that can be recognised by the following regular expression
    globalIdPattern = re.compile(r'[@][-a-zA-Z$._][-a-zA-Z$._0-9]*')

    #get all identifiers and the identifiers in the function
    for lcount in range(len(lines)):
        line = lines[lcount]
        if line.startswith("define"):
            fId = globalIdPattern.search(line)
            fIdStr = fId.group()
            if not fIdStr.startswith("@llvm"):
                funcId.append(fIdStr)
            funcBody = ""
            while not line.startswith("}"):
                funcBody += line
                lcount += 1
                line = lines[lcount]
            funcBody += line

            allIds = globalIdPattern.findall(funcBody)
            Ids = []
            for item in allIds:
                if not item.startswith("@llvm"):
                    Ids.append(item)
            Ids.remove(fIdStr)
            IdInFunc[fIdStr] = Ids
        elif line.startswith("declare"):
            fId = globalIdPattern.search(line)
            fIdStr = fId.group()
            if not fIdStr.startswith("@llvm"):
                funcId.append(fIdStr)
        elif line.startswith("@"):
            line = line.split(" = ")
            lid = globalIdPattern.search(line[0]).group()
            rid = globalIdPattern.findall(line[1])
            globalIdRef[lid] = rid
        else:
            pass

    linecache.clearcache()
    #---------------------------------------------------------
    #analyze the reference relationship among identifiers to know
    #the call relationship
    funcCall = {}
    for func in IdInFunc.keys():
        call = []
        for Id in IdInFunc[func]:
            if Id in funcId:
                call.append(Id)
            elif Id in globalIdRef.keys():
                for _Id in globalIdRef[Id]:
                    if _Id in funcId:
                        call.append(_Id)

        funcCall[func] = call
    #------------------------------------------------------------
    #generate the dot graph
    dotgraph = "digraph \"Call Graph\"{\n"
    dotgraph += "label=\"Call Graph\";\n"
    callSet = []
    
    for func in funcCall.keys():
        if func not in callSet:
            callSet.append(func)
        for call in funcCall[func]:
            if call not in callSet:
                callSet.append(call)
                    
    for func in set(callSet):
        dotgraph += "Node" + func.replace("@","").replace(".","") + " [shape=record, label=\"{" + func.lstrip("@") + "}\"];\n"

    if withExternalNode:
        dotgraph += "Node" + "External" + " [shape=record, label=\"{" + "external node" + "}\"];\n"
        for func in set(callSet):
            dotgraph += "Node" + "External" + " -> " + "Node" + func.replace("@","").replace(".","") +";\n"

    for func in funcCall.keys():
        if func in callSet:
            for call in funcCall[func]:
                dotgraph += "Node" + func.replace("@","").replace(".","") + " -> " + "Node" + call.replace("@","").replace(".","") +";\n"

    dotgraph += "}\n"

    return dotgraph
  

if __name__ == '__main__':
    paraser = argparse.ArgumentParser()
    paraser.add_argument("-i", '--input', help='the input file')
    paraser.add_argument("-o", '--output', default="callgraph.dot",help='the output file')
    paraser.add_argument("-e", '--externalNode', action='store_true', default=False, help='make call graph with external node')
    paraser.add_argument("-s",'--show', action='store_true', default=False, help='show the call graph using xdot')
    args = paraser.parse_args()

    dotgraph = ""
    if not args.input:
        paraser.print_help()
    else:
        dotgraph = generateCallGraph(programIR=args.input, withExternalNode=args.externalNode)
  
    with open(args.output, "w") as fp:
          fp.write(dotgraph)

    if args.show:
        cmd = "xdot " + args.output
        subprocess.run(cmd, shell=True, stderr=subprocess.STDOUT)

    
