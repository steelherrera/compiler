%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>


char* auxval;
char ide[100][5];
char err[100][5];
int cont = 0;
int auxnum = 0;
%}

letra [a-z]
digito [0-9]
numero {digito}+
cadena \".*\"
real {numero}\.({numero}(e(\+|\-)?{numero})?)
identificadores {letra}({letra}|{digito})*
comentario ((\/\/.*)|(\/\*.*\*\/))
identerror {numero}({letra})+   

%%
"main"	 fprintf(yyout,"MAIN ");
"void"   fprintf(yyout,"VOID ");
"if"     fprintf(yyout,"IF ");
"else"	 fprintf(yyout,"ELSE ");
"while"  fprintf(yyout, "WHILE ");
"for"    fprintf(yyout,"FOR ");
"do"    fprintf(yyout,"DO ");
"switch" fprintf(yyout,"SWITCH ");
"case"   fprintf(yyout,"CASE= %s ",yytext);	
"break"  fprintf(yyout,"BRAKE= %s ",yytext);			
"\("     fprintf(yyout,"Parent-a= %s ",yytext);
"\)"	 fprintf(yyout,"Parent-c= %s ",yytext);	
"\{"	 fprintf(yyout,"Inicio= %s ",yytext);
"\}" 	 fprintf(yyout,"Fin= %s ",yytext);
"\;" 	 fprintf(yyout,"Punto-coma= %s ",yytext);
"="	 	 fprintf(yyout,"Op-asig= %s ",yytext);
"<="	 fprintf(yyout,"Menor-igual= %s ",yytext);
">="	 fprintf(yyout,"Mayor-igual= %s ",yytext);
"<>"|"!="	 fprintf(yyout,"Diferente de= %s ",yytext);
"~"|"!"		 fprintf(yyout,"Op-no= %s ",yytext);
"=="		 fprintf(yyout,"Igual-que= %s ",yytext);
"&&"		 fprintf(yyout,"Op-y=",yytext);
"||"         fprintf(yyout,"Op-o",yytext);
"\>"	 fprintf(yyout,"Mayor= %s ",yytext);
"\<"	 fprintf(yyout,"Menor= %s ",yytext);
"\y"	 fprintf(yyout,"op-y= %s ",yytext);
"\o"	 fprintf(yyout,"Op-o= %s ",yytext);
"\+"	 fprintf(yyout,"Op-sum= %s ",yytext);
"\-"	 fprintf(yyout,"Op-sust= %s ",yytext);
"\*"	 fprintf(yyout,"Op-mult= %s ",yytext);
"\/"	 fprintf(yyout,"Op-div= %s ",yytext);
"\^"     fprintf(yyout,"Op-exp= %s ",yytext);
"\,"	 fprintf(yyout,"Coma= %s",yytext);
"\:"	 fprintf(yyout,"Dos-puntos %s",yytext);
"char"	 fprintf(yyout,"CHAR ");
"int"    fprintf(yyout,"INT ");
"float"	 fprintf(yyout,"FLOAT ");
"scanf"	 fprintf(yyout,"SCANF ");
"printf" fprintf(yyout,"PRINTF ");
{identificadores}  {	auxval=yytext;
			fprintf(yyout,"Id= %s ",yytext);	
			auxnum = 0;			
			for(int i = 0; i<100; i++){
				if(strcmp(ide[i],auxval)==0){
					auxnum = 1;
				}	
			}
			if(auxnum == 0){
			strcpy(ide[cont],auxval);
			cont = cont + 1;
			}
		   }	
{numero}	   fprintf(yyout,"Cte entera= %s ",yytext); 	
{cadena}	   fprintf(yyout,"Cte cadena= %s ",yytext); 	
{real}		   fprintf(yyout,"Cte real= %s ",yytext);
{comentario} fprintf(yyout,"Comentario= %s ",yytext);
" "			   	 fprintf(yyout," ",yytext);
"\t"        fprintf(yyout,"\t",yytext);
"\n"		   	 fprintf(yyout,"\n",yytext);
{identerror}   {auxval=yytext;
				fprintf(yyout,"ERROR= %s ",yytext);
				auxnum = 0;
				for(int i = 0; i<100; i++){
					if(strcmp(err[i],auxval)==0){
						auxnum = 1;
					}	
				}
				if(auxnum == 0){
					strcpy(err[cont],auxval);
					cont = cont + 1;
				}
		    }	
.		   {auxval=yytext;
			fprintf(yyout,"ERROR= %s ",yytext);
			auxnum = 0;
			for(int i = 0; i<100; i++){
				if(strcmp(err[i],auxval)==0){
					auxnum = 1;
				}	
			}
			if(auxnum == 0){
				strcpy(err[cont],auxval);
				cont = cont + 1;
			}
		    }

		   

%%
int main(int argc,char* argv[])
{
yyin=fopen(argv[1],"r");
yyout=fopen(argv[2],"w");
yylex();
fprintf(yyout,"\t\n ");
fprintf(yyout,"\t\n TABLA DE IDENTIFICADORES \n");
for(int i=0; i<100; i++){
		if(strcmp(ide[i],"")!=0){
			fprintf(yyout,"Id=");
			fprintf(yyout,"%s",ide[i]);
			fprintf(yyout,"; ");
		}
}
fprintf(yyout,"\t\n ");
fprintf(yyout,"\t\n TABLA DE ERRORES\n");
for(int i=0; i<100; i++){
		if(strcmp(err[i],"")!=0){
			fprintf(yyout,"Error=");
			fprintf(yyout,"%s",err[i]);
			fprintf(yyout," ");
		}
}

return 0;
}