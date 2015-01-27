JC = javac
JFLAGS = -g


.SUFFIXES: .java .class .jflex


default: Lexer.class Driver.class

Lexer.class: Lexer.java
	$(JC) $(JFLAGS) Lexer.java

Lexer.java: minijava.jflex
	jflex minijava.jflex

Driver.class: Driver.java
	$(JC) $(JFLAGS) Driver.java









