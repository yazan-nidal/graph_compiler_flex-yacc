/* scanner for a toy Pascal-like language */

%{
/* need this for the call to atof() below */
#include<stdio.h>
#include <math.h>
#include<string.h>

#define R 300

void ns(char *gg)
{
    int j=0;
    char c[R];
    for(int i=0;gg[i];i++)if(gg[i]!=' ' &&  gg[i]!= '\t')c[j++]=gg[i];
    c[j]=NULL;
    strcpy(gg,c);
    
}

struct graph
{

char name[R];
int l;
char node[R][R];
int list[R][R];

};

void clear(struct graph* nt)
{
  (*nt).l=0;
  for(int i=0;i<R;i++)(*nt).node[i][0]=NULL;
  for(int i=0;i<R;i++)for(int j=0;j<R;j++)(*nt).list[i][j]=0;
}

int match(struct graph nt,char * x)
{

for(int i=0;i<nt.l;i++)if(strcmp(x,nt.node[i])==0)return i;
return -1;

}

int add(struct graph* nt,char *x)
{
    if(match((*nt),x)!=-1)return 0;
    strcpy((*nt).node[(*nt).l],x); (*nt).l++;
    return 1;
}

int ade(struct graph* nt,char *x,char *y ,float c)
{
    int i=match((*nt),x);
    int j=match((*nt),y);
    if((i==-1)||(j==-1))return 0;
    if(i==j)return -1;
    if((*nt).list[i][j] != 0)return 2;
    (*nt).list[i][j]=c;
    return 1;
}

int fp(struct graph* nt,char *x,char *y)
{
    int i=match((*nt),x);
    int j=match((*nt),y);
    if((i==-1)||(j==-1))return 0;
    if(i==j)return -1;
    if((*nt).list[i][j] == 0)return 2;
    return 1;
}


int r=0;
char gn[R][R];
struct graph g[R];



int matchg(char * x)
{
for(int i=0;i<r;i++)if(strcmp(x,gn[i])==0)return i;
return -1;
}

int addg(char *x)
{
    if(matchg(x)!=-1){return 0;}
    strcpy(gn[r],x); clear(g+r); r++;
    return 1;
}

void createGraph_(char *gg)
{ 

ns(gg);
char c[R];
int i=11;
int j=0;
for(;gg[i]!=';';i++)c[j++]=gg[i];
    c[j]=NULL;

    if(addg(c)==0)printf("!!!graph : '%s' is exist.\n",c); 
    else printf("add graph : '%s' done.\n",c);
}

void addNodeTo_(char *gg)
{

ns(gg);
char c[R];
int i=9;
int j=0;
for(;gg[i]!='(';i++)c[j++]=gg[i];
    c[j]=NULL;

int s=matchg(c);

if(s==-1){
    printf("!!!graph : %s is not exist.\n",c);  return;
}

    char cc[R];
    strcpy(cc,c);
j=0;
i++;
for(;gg[i]!=')';i++)c[j++]=gg[i];
    c[j]=NULL;
    
    int ss=add(g+s,c);
    if(ss==1)printf("add node : (%s) to graph'%s' done.\n",c,cc);
    else printf("!!!node : (%s) is exist. in graph'%s'  \n",c,cc); 

}

void addEdgeTo_(char *gg)
{

ns(gg);
char c[R];
int i=9;
int j=0;
for(;gg[i]!='(';i++)c[j++]=gg[i];
    c[j]=NULL;

int s=matchg(c);

if(s==-1){
    printf("!!!graph : %s is not exist.\n",c);  return;
}

char cc[R];
strcpy(cc,c); 

j=0;
i++;
for(;gg[i]!=',';i++)c[j++]=gg[i];
    c[j]=NULL;

char c2[R];
j=0;
i++;
for(;gg[i]!=')';i++)c2[j++]=gg[i];
    c2[j]=NULL;

char c3[R];
j=0;
i+=2;
for(;gg[i]!=';';i++)c3[j++]=gg[i];
    c3[j]=NULL;

    float er=atof(c3);

    
    int ss=ade(g+s,c,c2,er);
    if(ss==1)printf("add edge -> (%s,%s):%s to graph'%s' done.\n",c,c2,c3,cc);
    else if(ss==2) printf("!!!the edge (%s,%s) is exist \n",c,c2);
    else if(ss==-1) printf("!!!the both node is the same (%s) \n",c);
    else printf("!!! one or both node  (%s,%s) is not exist. in graph'%s'  \n",c,c2,cc);
    
}

void findPath_(char *gg)
{

ns(gg);
char c[R];
int i=8;
int j=0;
for(;gg[i]!='(';i++)c[j++]=gg[i];
    c[j]=NULL;

int s=matchg(c);

if(s==-1){
    printf("!!!graph : %s is not exist.\n",c);  return;
}

char cc[R];
strcpy(cc,c); 

j=0;
i++;
for(;gg[i]!=',';i++)c[j++]=gg[i];
    c[j]=NULL;

char c2[R];
j=0;
i++;
for(;gg[i]!=')';i++)c2[j++]=gg[i];
    c2[j]=NULL;

    int ss=fp(g+s,c,c2);
    if(ss==-1) printf("!!!the both node is the same (%s) \n",c);
    else
    if(ss==1) printf("path -> (%s,%s) is exist  to graph '%s'.\n",c,c2,cc);
    else if(ss==2) printf("path -> (%s,%s) is not exist  to graph '%s'.\n",c,c2,cc);
    else printf("!!! one or both node  (%s,%s) is not exist. in graph'%s'  \n",c,c2,cc);
    
    
}


%}

DIGIT    [0-9]

ID       [a-z][a-z0-9]*

NUMBER  {DIGIT}+(\.{DIGIT}+)?(E[+-]?{DIGIT}+)?

createGraph (create[ ]graph([ ]){ID};)
addNodeTo (add[ ]node[ ]to[ ]{ID}([ ]*)(\()([ ]*){ID}(\));)
addEdgeTo (add[ ]edge[ ]to[ ]{ID}([ ]*)(\()([ ]*){ID}([ ]*)(,)([ ]*){ID}(\))([ ]*)(:)([ ]*){NUMBER};)
findPath  (find[ ]path[ ]{ID}([ ]*)(\()([ ]*){ID}([ ]*)(,)([ ]*){ID}(\));)


%%
{DIGIT} {}
{ID} {}
{NUMBER} {}

{createGraph} {createGraph_(yytext);}
{addNodeTo} {addNodeTo_(yytext);}
{addEdgeTo} {addEdgeTo_(yytext);}
{findPath}  {findPath_(yytext);}

%%

int yywrap(){ return 1; 
} 
int main( argc, argv )
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
