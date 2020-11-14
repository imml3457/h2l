%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int list_type;
%}

%option       noyywrap nounput yylineno
%x            COMMENT PARA PRE OL UL LI

%%

"<h1>"[^<]*"</h1>" {
    /**************************************************************************
     * Matched an HTML H1 header so print it out as a LateX section title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\section{%s}", yytext+4 );
}

"<h2>"[^<]*"</h2>" {
    /**************************************************************************
     * Matched an HTML H2 header so print it out as a LateX section title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\subsection{%s}", yytext+4 );
}

"<h3>"[^<]*"</h3>" {
    /**************************************************************************
     * Matched an HTML H2 header so print it out as a LateX section title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\subsection{%s}", yytext+4 );
}

"<!--" {
    /**************************************************************************
     * Matched an HTML comment so print it out as a LateX comment. The
     * beginning and ending tags are stripped off before the LateX comment
     * is emitted.
     *************************************************************************/
    printf( "%% " );
    BEGIN COMMENT;
}


[ \t\n\r]+ {
}

. {
    fprintf( stderr, "Unexpected input at line %d: '%s'\n", yylineno, yytext );
    exit( 1 );
}

<COMMENT>"-->" {
    printf( "\n" );
    BEGIN 0;
}

<COMMENT>[\n](\r)? {
    printf( "\n%% " );
}

<COMMENT>[ \t] {
    printf( "%s", yytext );
}

<COMMENT>. {
    printf( "%s", yytext );
}

"<p>" {
    /*begin the paragraph section*/
    BEGIN PARA;
}


<PARA>"</p>" {
    printf( "\n\n" );
    BEGIN 0;
}

<PARA>"<big>"[^<]*"</big>" {
/*subsections for paragraph
  each time it found another tag remove the ending and beginning tags*/
    yytext[yyleng-6] = 0;
    printf( "{\\large %s}", yytext+5 );
}

<PARA>"<small>"[^<]*"</small>" {
    yytext[yyleng-8] = 0;
    printf( "{\\scriptsize %s}", yytext+7 );
}

<PARA>"<b>"[^<]*"</b>" {
    yytext[yyleng-4] = 0;
    printf( "\\textbf{%s}", yytext+3 );
}

<PARA>"<i>"[^<]*"</i>" {
    yytext[yyleng-4] = 0;
    printf( "\\textit{%s}", yytext+3 );
}

<PARA>"<strong>"[^<]*"</strong>" {
    yytext[yyleng-9] = 0;
    printf( "\\textmd{%s}", yytext+8 );
}
<PARA>"<em>"[^<]*"</em>" {
    yytext[yyleng-5] = 0;
    printf( "\\emph{%s}", yytext+4 );
}
<PARA>"<sup>"[^<]*"</sup>" {
    yytext[yyleng-6] = 0;
    printf( "\\textsuperscript{%s}", yytext+5 );
}
<PARA>"<sub>"[^<]*"</sub>" {
    yytext[yyleng-6] = 0;
    printf( "\\textsubscript{%s}", yytext+5 );
}

<PARA>[\n](\r)? {
    printf( "\n " );
}

<PARA>[ \t] {
    printf( "%s", yytext );
}

<PARA>. {

    printf( "%s", yytext );
}

"<pre>" {
/*very simple pre formatted paragraph section*/
    printf("\\begin{verbatim}");
    BEGIN PRE;
}



<PRE>"</pre>" {
    printf( "\\end{verbatim}\n" );
    BEGIN 0;
}

<PRE>[\n](\r)? {
    printf( "\n" );
}

<PRE>[ \t] {
    printf( "%s", yytext );
}

<PRE>. {
    printf( "%s", yytext );
}

"<ul>" {
    /*unordered list section*/
    printf("\\begin{itemize}");
    list_type = 0;
    BEGIN UL;
}
<UL>"<li>" {
    printf("\\item ");
    /*you want to go to the individual list tag after starting the list*/
    BEGIN LI;
}

<UL>"</ul>" {
    printf( "\\end{itemize}\n" );
    BEGIN 0;
}

"<ol>" {
    /*begin the ordered list section*/
    printf("\\begin{enumerate}");
    list_type = 1;
    BEGIN OL;
}
<OL>"<li>" {
    printf("\\item ");
    /*you want to go to the individual list tag after starting the list*/
    BEGIN LI;
}
<OL>"</ol>" {
    printf( "\\end{enumerate}\n" );
    BEGIN 0;
}



<LI>"<big>"[^<]*"</big>" {
    /*subsection for individual list tag*/
    yytext[yyleng-6] = 0;
    printf( "{\\large %s}", yytext+5 );
}

<LI>"<small>"[^<]*"</small>" {
    yytext[yyleng-8] = 0;
    printf( "{\\scriptsize %s}", yytext+7 );
}

<LI>"<b>"[^<]*"</b>" {
    yytext[yyleng-4] = 0;
    printf( "\\textbf{%s}", yytext+3 );
}

<LI>"<i>"[^<]*"</i>" {
    yytext[yyleng-4] = 0;
    printf( "\\textit{%s}", yytext+3 );
}

<LI>"<strong>"[^<]*"</strong>" {
    yytext[yyleng-9] = 0;
    printf( "\\textmd{%s}", yytext+8 );
}
<LI>"<em>"[^<]*"</em>" {
    yytext[yyleng-5] = 0;
    printf( "\\emph{%s}", yytext+4 );
}
<LI>"<sup>"[^<]*"</sup>" {
    yytext[yyleng-6] = 0;
    printf( "\\textsuperscript{%s}", yytext+5 );
}
<LI>"<sub>"[^<]*"</sub>" {
    yytext[yyleng-6] = 0;
    printf( "\\textsubscript{%s}", yytext+5 );
}

<LI>[\n](\r)? {
    printf( "\n " );
}

<LI>[ \t] {

    printf( "%s", yytext );
}

<LI>. {
    printf( "%s", yytext );
}

<LI>"</li>" {
    /*simple rule to check which list type it is so it can loop back to the beginning*/
    printf( "\n" );
    if(list_type == 0){
        BEGIN UL;
    }
    if(list_type == 1){
        BEGIN OL;
    }
}

%%

/**************************************************************************
 * The main function for the HTML to LateX converter. Here we do three
 * things:
 *  1. Print out the LateX document header.
 *  2. Invoke the lexer to print out the LateX document
 *  3. Print out the LateX footer.
 *************************************************************************/
int main( int argc, const char *argv[] ) {
    printf( "\\documentclass[12pt]{article}\n" );
    printf( "\\usepackage{fixltx2e}\n" );
    printf( "\n" );
    printf( "\\setlength{\\parindent}{0.0in}\n" );
    printf( "\\setlength{\\parskip}{0.125in}\n" );
    printf( "\n\n" );
    printf( "\\begin{document}\n" );
    yylex();
    printf( "\\end{document}\n" );
    return 0;
}
