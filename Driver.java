/*
 * Anthony Raehn
 * CS1622 Compiler Driver File
 */

import java.io.*;

public class Driver{
  /**
   * Creates a new scanner
   *
   * @param   in  the java.io.Reader to read input from.
   
  Lexer(java.io.Reader in) {
    this.zzReader = in;
  }
   */
	public static void main(String[] args) throws Exception{
		File file = new File(args[0]);
		FileReader reader = new FileReader(file);
		Lexer lexer = new Lexer(reader);
		lexer.yylex();
	}
}
