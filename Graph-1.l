%{
#include <stdio.h>
#include <string.h>


#undef yywrap
#define yywrap() 1
#define NUMBER_OF_NODES 30


struct Graph
{
	
	int adjacencyMatrix[NUMBER_OF_NODES][NUMBER_OF_NODES];
	char* nodeList[NUMBER_OF_NODES];
	char graphName[50];
	int top;

} graph;
	
	
	struct Graph createGraph(char* graphName)
	{
	  struct Graph graph;
	  graph.top = 0;
	  strcpy(graph.graphName, graphName);
	  return graph;
	}



	void addNode(char* node)
	{
		printf("%d" , graph.top);
		if(graph.top < NUMBER_OF_NODES)
		{
		   graph.nodeList[graph.top++] = strdup(node);
		   printf("\nnode %s was added successfully to the graph %s.", node, graph.graphName);
		}
		else
		   printf("\nThere is no enough room for another node in the graph.");
	}
	
	
	void printNodes()
	{
		for(int i =0; i < NUMBER_OF_NODES; i++)
		   printf("%s, ", graph.nodeList[i]);
	}


	void addEdge(char* node1, char* node2, float weight)
	{
	
	}


	int findEdge(char* node1, char* node2)
	{
		return graph.adjacencyMatrix[0][0] != 0;
	}


	void printAdjacencyMatrix()
	{
		printf("\n");
		for (int i = 0; i < NUMBER_OF_NODES; i++)
		{
			
			for (int j = 0; j < NUMBER_OF_NODES; j++)
				printf(" %-5d", graph.adjacencyMatrix[i][j]);
			printf("\n\n");
		}
	}

	
	int getLeftParanthesisIndex(char* str)
	{	
		int i=0;
		while(str[i] != '(')
		{
		   i++;
		}

		return i;
	}


	void setNodes(char* str, char node1[50], char node2[50])
	{
		int i = getLeftParanthesisIndex(str) + 1;
		int n = 0;
		while(str[i] != ',')
		{
		node1[n++] = str[i++];
		}
		node1[n] = '\0';

		n = 0;
		i++;
		while(str[i] != ')')
		{
		 node2[n++] = str[i++];
		}

		node2[n] = '\0';
	}


%}

CREATE			^create[ ]graph[ ][a-zA-z][a-zA-Z0-9]*;
ADD_NODE		^add[ ]node[ ]to[ ]graph\([a-zA-z][a-zA-Z0-9]*\);
ADD_EDGE		^add[ ]edge[ ]to[ ]graph\([a-zA-z][a-zA-Z0-9]*,[a-zA-z][a-zA-Z0-9]*\);
FIND_PATH		^find[ ]path[]\([a-zA-z][a-zA-Z0-9]*,[a-zA-z][a-zA-Z0-9]*\);
PRINT_GRAPH		^print[ ]graph;


%%

{CREATE}	{

		  int s = 0;
		  char graphName[50];
		  for(int i = 0; i < yyleng; i++)
		  {
			if(yytext[i] == ' ')
			  s = i;
		  }
						
			strcpy(graphName, yytext + s + 1);
			graphName[strlen(graphName) - 1] = '\0';
			graph = createGraph(graphName);
			printf("\ngraph %s has successfully created.", graphName);		  
		}

{ADD_NODE}	{
			char node[50];

			int i = getLeftParanthesisIndex(yytext) + 1;
			int n = 0;
			while(yytext[i] != ')')
			{
			  node[n++] = yytext[i++];
			}

			node[n] = '\0';

			addNode(node);
			printNodes();
		}



{ADD_EDGE}	{	
			char node1[50], node2[50];
			setNodes(yytext, node1, node2);
			addEdge(node1, node2, 12);
		}

{FIND_PATH} 	{
		 	
		}


{PRINT_GRAPH}	{
			printAdjacencyMatrix(graph);
		}

"{"[^}\n]*"}"     /* eat up one-line comments */

[ \t\n]+          /* eat up whitespace */

.      /* consume */

%%

int main(argc, argv)
int argc;
char **argv;
    {
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
            yyin = fopen( argv[0], "r" );
    else
            yyin = stdin;

    yylex();
       
    return 0;
    }
