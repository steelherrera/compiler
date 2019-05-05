%{
#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<string.h>
char id[1000][256];
int varcount=0;
char errors[1000][256];
int errcount=0;
%}

digit [0-9]
digits digit+
var [a-zA-Z_][0-9a-zA-Z]*
num-int [-+]?[0-9]
num-float [-+]?[0-9]+"."[0-9]+([eE]?[-+]?[0-9]+)?
charerr ([^\d\sA-Za-z_!"#~<>+/*\-^()|&=;,\t \n]+)+
%%

"\#"" "*"include"" "*"<".*">" {fprintf(yyout,"incluye-libreria: %s", yytext);}

\".*\"|\'.*\'	{fprintf(yyout," Var-cadena: %s", yytext);}
"<--"|"="	{fprintf(yyout," Asignacion: %s", yytext);}
{num-float}	{fprintf(yyout," Num-real: %s", yytext);}
{num-int}	{fprintf(yyout," Num-entero: %s", yytext);}
{var}           {fprintf(yyout,"\nVariable: %s", yytext);
		int z;
		int found = 0;
		for(z = 0; id[z][0] != '\0'; z++){
                    if(strstr(id[z], yytext)){
			found = 1;
		    }
		}
		if (found == 0){
		    char newVar[] = "Id=";
		    strcat(newVar,yytext);
		    strcat(newVar,"; ");
                    strcat(id[varcount], newVar);
                    varcount = varcount+1;
                }}


{charerr}	{fprintf(yyout,"\nCaracter no reconocido: %s\n", yytext);
		int l;
                int found = 0;
		for(l = 0; errors[l][0] != '\0'; l++){ 
                    if(strstr(errors[l], yytext)){ 
                        found = 1;
                    }
                }
                if (found == 0){
		    char newError[] = "Error=";
		    strcat(newError, yytext);
		    strcat(newError, "; ");
                    strcat(errors[errcount], newError);
                    errcount = errcount+1;
                }
}

"("		{fprintf(yyout, " Parent-a: %s", yytext);}
")"		{fprintf(yyout, " Parent-c: %s", yytext);}

"*"		{fprintf(yyout, " Op-mult: %s", yytext);}
"+"		{fprintf(yyout, " Op-sum: %s", yytext);}
"-"		{fprintf(yyout, " Op-rest: %s", yytext);}
"/"		{fprintf(yyout, " Op-div: %s", yytext);}
"^"		{fprintf(yyout, " Op-exp: %s", yytext);}	
"&&"|"y"	{fprintf(yyout, " Op-y: %s", yytext);}
"||"|"o"	{fprintf(yyout, " Op-o: %s", yytext);}
"~"|"!"		{fprintf(yyout, " Op-neg: %s", yytext);}

"=="		{fprintf(yyout, " Comp-igual: %s", yytext);}
">"		{fprintf(yyout, " Comp-mayor: %s", yytext);}
"<"		{fprintf(yyout, " Comp-menor: %s", yytext);}
">="		{fprintf(yyout, " Comp-mayorigual: %s", yytext);}
"<="		{fprintf(yyout, " Comp-menorigual: %s", yytext);}
"<>"|"!="	{fprintf(yyout,"\nComp-diferente: %s", yytext);}

\t		{fprintf(yyout, "\t" );}
" "		{fprintf(yyout, " " );}	
\n		{fprintf(yyout, "\n");}
";"		{fprintf(yyout," Punto y coma: %s", yytext);}
","		{fprintf(yyout," Coma: %s",yytext );}

%%
int yywrap(){}
int main(int argc, char *argv[]){
	int i;
	printf("Archivo cargado: %s\n", argv[1]);
	FILE *in_file =fopen(argv[1], "r");
	FILE *out_file=fopen("salida.txt","w");
	yyin=in_file;
	yyout=out_file;
	yylex();
	fprintf(out_file, "\nTABLA DE IDENTIFICADORES\n");
	fprintf(out_file, "Hay %d identificadores\n", varcount);
	for (i=0; id[i][0] != '\0'; i++){
	    fprintf(out_file, "%s", id[i]);
	}
	fprintf(out_file, "\n\n----------------------------");
	fprintf(out_file, "\nTABLA DE ERRORES\n");
	fprintf(out_file, "Hay %d errores\n",errcount);
	for (i=0; errors[i][0] != '\0'; i++){
            fprintf(out_file, "%s", errors[i]);
        }
	fprintf(out_file, "\n\n");
	return (0);
}
