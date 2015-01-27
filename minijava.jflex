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


"{"			{	string.append(" {\n");
				indent++;}

{LineTerminator}	{	for(int i =0; i<indent; i++){
				string.append("\t");
				}}


{InputCharacter}	{string.append(yytext());}


 /* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }














