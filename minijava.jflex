/* JFlex example: part of Java language lexer specification */
import java_cup.runtime.*;
import java.util.*;
/**
 * This class is a simple example lexer.
 */
%%
%public
%class Lexer
%type Void
%unicode
%line
%column
%{
  int indent = 0;
  StringBuffer string = new StringBuffer();
%}
%eof{
  System.out.println(string);
%eof}
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

BlockComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
LineComment = "//" {InputCharacter}* {LineTerminator}?
Comment   = {BlockComment} | {LineComment}

If = "if" {WhiteSpace}* "(" ~")"
Identifier = [_a-zA-Z] [_a-zA-Z0-9]*
IntegerLiteral = 0 | [1-9][0-9]*
BinaryOp = "&&" | "<" | "+" | "-" | "*"
Keyword = "class" | "public" | "static" | "void" | "main" | "extends" | "return" |
		"int" | "boolean" | "while" | "System.out.println" | "length"
		"true" | "false" | "this" | "new" | "String"

%%


{BlockComment}		{	/* \t == 8 cols but jflex reads as 1 col
				   I'm going to calculate as 8 cols to
				   keep max width at 80 cols		*/
				int maxcols = 80-indent*8;
				int remainder = yytext().length()%maxcols;
				for(int i=0; i<=yytext().length()/maxcols; i++){
					String s = "";
					if(i<yytext().length()/maxcols)
						s = yytext().substring(i*maxcols,i*maxcols+maxcols);
					else
						s = yytext().substring(i*maxcols,i*maxcols+remainder);
					string.append(s+"\n");
					for(int j =0; j<indent; j++){
                                        	string.append("\t");
                                	}
				}
				//string.append(maxcols+"\n"+remainder+"\n");
				}
{LineComment}		{	/*consume*/}
{WhiteSpace}		{	/*consume*/}
";"			{	if(string.charAt(string.length()-1) == ' ')
                                        string.deleteCharAt(string.length()-1);
				string.append(";\n");
				for(int i =0; i<indent; i++){
					string.append("\t");
				}}

"{"			{	indent++;
				if(string.charAt(string.length()-1) == ' ')
                                        string.deleteCharAt(string.length()-1);
				string.append(" {\n");
				for(int i =0; i<indent; i++){
                                        string.append("\t");
                                }}

"}"			{	indent--;
				if(string.charAt(string.length()-1) == '\t')
					string.deleteCharAt(string.length()-1);
				string.append("}\n");}

"["			{	if(string.charAt(string.length()-1) == ' ')
                                        string.deleteCharAt(string.length()-1);
				string.append("[ ");}

"]"                     {       if(string.charAt(string.length()-1) == ' ')
                                        string.deleteCharAt(string.length()-1);
                                if(string.charAt(string.length()-1) == '[')
					string.append("]");
				else
					string.append(" ]");}

"("			{	if(string.charAt(string.length()-1) == ' ')
                                        string.deleteCharAt(string.length()-1);
				if(string.charAt(string.length()-1) == '&' ||
				   string.charAt(string.length()-1) == '<' ||
				   string.charAt(string.length()-1) == '+' ||
                                   string.charAt(string.length()-1) == '-' ||
                                   string.charAt(string.length()-1) == '*')
					string.append(" ( ");
				else
					string.append("( ");}

")"                     {       if(string.charAt(string.length()-1) == ' ')
                                        string.deleteCharAt(string.length()-1);
                                if(string.charAt(string.length()-1) == '(')
                                        string.append(")");
				else
					string.append(" )");}
"."			{	if(string.charAt(string.length()-1) == ' ')
                                        string.deleteCharAt(string.length()-1);
				string.append(".");}
{If} / {WhiteSpace}* !"{" 	{	string.append(yytext()+"\n");
					for(int i =0; i<indent+1; i++){
                                                string.append("\t");
                                        }}
"else" / {WhiteSpace}* !"{"	{	string.append("else\n");
					for(int i =0; i<indent+1; i++){
                                        	string.append("\t");
                                	}}
"="			{	string.append(yytext()+" ");}
{IntegerLiteral}	{	string.append(yytext()+" ");}
{BinaryOp}		{	string.append(yytext()+" ");}
{Keyword}		{	string.append(yytext()+" ");}
{Identifier}            {       if(string.charAt(string.length()-1) != ' ')
					string.append(" ");
				string.append(yytext()+" ");}
{InputCharacter}	{	string.append(yytext());}


 /* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }














