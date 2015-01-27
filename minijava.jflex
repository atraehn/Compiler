/* JFlex example: part of Java language lexer specification */
import java_cup.runtime.*;

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

Comment   = "/*" [^*] ~"*/" | "/*" "*"+ "/" | "//" {InputCharacter}* {LineTerminator}?

Identifier = [_a-zA-Z] [_a-zA-Z0-9]*
IntegerLiteral = 0 | [1-9][0-9]*
BinaryOp = "&&" | "<" | "+" | "-" | "*"
Keyword = "class" | "public" | "static" | "void" | "main" | "extends" | "return" |
		"if" | "int" | "boolean" | "while" | "System.out.println" | "length"
		"true" | "false" | "this" | "new" | "String"

%%

{Comment}		{	/*consume*/}
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

"else" / {WhiteSpace}* !"{" {	string.append("else\n");
				for(int i =0; i<indent+1; i++){
                                        string.append("\t");
                                }}

"="			{	string.append(yytext()+" ");}
{IntegerLiteral}	{	string.append(yytext()+" ");}
{BinaryOp}		{	string.append(yytext()+" ");}
{Keyword}		{	string.append(yytext()+" ");}
{Identifier}		{	string.append(yytext()+" ");}
{InputCharacter}	{	string.append(yytext());}


 /* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }














