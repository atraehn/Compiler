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

Comment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"

Identifier = [_a-zA-Z] [_a-zA-Z0-9]*
IntegerLiteral = 0 | [1-9][0-9]*
BinaryOp = "&&" | "<" | "+" | "-" | "*"

%state STRING

%%


{WhiteSpace}		{	/*consume*/}

";"			{	string.append(";\n");
				for(int i =0; i<indent; i++){
					string.append("\t");
				}}

"{"			{	indent++;
				string.append(" {\n");
				for(int i =0; i<indent; i++){
                                        string.append("\t");
                                }}

"}"			{	indent--;
				if(string.charAt(string.length()-1) == '\t')
					string.deleteCharAt(string.length()-1);
				string.append("}\n");}


{InputCharacter}	{	string.append(yytext());}


 /* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }














