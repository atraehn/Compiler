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
  StringBuffer string = new StringBuffer("hi");
%}
%eof{
  System.out.println(string);
%eof}
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

Comment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"

Identifier = [:jletter:] [:jletterdigit:]*
IntegerLiteral = 0 | [1-9][0-9]*
BinaryOp = "&&" | "<" | "+" | "-" | "*"

%state STRING

%%
{WhiteSpace}		{string.append(yytext());}
{InputCharacter}	{string.append(yytext());}
  /*
<YYINITIAL> {
  {InputCharacter}		{string.append(yytext());} 
  /* keywords */
  
  /* identifiers */ 
  {Identifier}                   { return symbol(sym.IDENTIFIER); }
 
  /* literals */
  {IntegerLiteral}            { return symbol(sym.INTEGER_LITERAL); }
  \"                             { string.setLength(0); yybegin(STRING); }

  /* operators */
  "="                            { return symbol(sym.EQ); }
  "=="                           { return symbol(sym.EQEQ); }
  "+"                            { return symbol(sym.PLUS); }

  /* comments */
  {Comment}                      { /* ignore */ }
 
  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }
}
  */
 /* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }














