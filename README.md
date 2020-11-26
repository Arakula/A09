# A09 - 6800/6801/6809/6301/6309/68HC11 Assembler

Copyright (c) 1993,1994 L.C. Benschop  
Parts Copyright (c) 2001-2020 Hermann Seib


Based on Lennart Benschop's C core that can be found somewhere on the 'net 
(last address known to me was
[http://koti.mbnet.fi/~atjs/mc6809/Assembler/A09.c](http://koti.mbnet.fi/~atjs/mc6809/Assembler/A09.c)),
I built a complete Macro Assembler that is functionally better than the 
TSC Flex9 Assembler (no wonder, I got multimegabytes to play with, whereas this 
excellent piece of software works within 50K or so!). It can deliver binary, 
Intel Hex, Motorola S1, and Flex9 binary output files, plus Flex9 
RELASMB-compatible relocatable object modules.


I taylored the original to my taste by working through the source code; since 
A09 has reached a level of complexity that doesn't really lend itself to following the "Use 
the Source, Luke!" principle if you just want to hack a little 6809 assembly 
program, I've added this documentation. Have fun!


Hermann Seib, 2020

## Syntax

<pre>a09 [-{b|r|s|x|f}[filename]]|[-c] [-l[filename]] [-ooption]* [-dsym=value]* sourcefile*</pre>

### Command Line Parameters

<dl>
  <dt><b>-c</b></dt>
  <dd>suppresses code output (corresponds to ASMB's <b>B</b> command line option)</dd>
  <dt><b>-b<i>filename</i></b> (default output mode)</dt>
  <dd>create a binary output file<br>
  if no file name is given, the extension <b>.bin</b> is used (<b>.b</b> on 
  Unix)</dd>
  <dt><b>-r<i>filename</i></b></dt>
  <dd>create a Flex9 RELASMB-compatible output file name<br>
  if no file name is given, the extension <b>.rel</b> is used</dd>
  <dd><b>Attention:</b> this file format is undocumented; my solution has been 
  derived from some bits of information gathered on the Flex User Group mailing 
  list and a bit of playing with the original. In my tests, the output was 
  identical to RELASMB's; nevertheless, A09 <i>might</i> create modules that are 
  incompatible with the original under circumstances that I don't know or 
  haven't tested.</dd>
  <dt><b>-s<i>filename</i></b></dt>
  <dd>create a Motorola S-record output file name<br>
  if no file name is given, the extension <b>.s09</b> is used</dd>
  <dt><b>-x<i>filename</i></b></dt>
  <dd>create an Intel hex output file name<br>
  if no file name is given, the extension <b>.hex</b> is used</dd>
  <dt><b>-f<i>filename</i></b></dt>
  <dd>create Flex9 ASMB-compatible output file<br>
  if no file name is given, the extension <b>.bin</b> is used</dd>
  <dt><b>-l<i>filename</i></b></dt>
  <dd>create a list file (default no listing)<br>
  if no file name is given, the extension <b>.lst</b> is used</dd>
  <dt><b>-d<i>sym</i>[=<i>value</i>]</b></dt>
  <dd>define a symbol (see <b>TEXT</b> directive below) <br>
  (roughly corresponds to ASMB's command line parameters 1-3)</dd>
  <dt><b>-o<i>opt</i></b></dt>
  <dd>defines an option (see below)</dd>
  <dt><b>sourcefile</b></dt>
  <dd>the assembler source file(s) to be processed.<br>
      At least one source file must be given; the first one also defines
	  the default output and listing file names.</dd>
</dl>

## Options

Over the years, A09 has learned quite a lot, and it can handle source files / 
list files in various formats. To allow their selection, I have expanded the 
scope of the <b>OPT</b> directive (see the FLEX9 Assembler Manual that can be 
found in the Documentation section on [www.flexusergroup.com](http://www.flexusergroup.com)
for details). Here's the list of additional options 
available in A09 (* denotes the default value for a mutually exclusive set):


<table border="0" cellspacing="1" width="100%" id="AutoNumber1">
  <tbody><tr>
    <td valign="top" width="10%"><b>SYM *</b></td>
    <td>print a symbol table</td>
  </tr>
  <tr>
    <td valign="top"><b>NOS</b></td>
    <td>suppress symbol table printing (corresponds to ASMB's <b>S</b> command 
    line option)</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>MUL *</b></td>
    <td>print multiple object code lines</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>NMU</b></td>
    <td>suppress printing of multiple object code lines (corresponds to ASMB's
    <b>G</b> command line option)</td>
  </tr>
  <tr>
    <td height="8" colspan="2" valign="top"></td>
  </tr>
  <tr>
    <td valign="top"><b>LP1</b></td>
    <td>print a Pass 1 listing</td>
  </tr>
  <tr>
    <td valign="top"><b>NO1 *</b></td>
    <td>print Pass 2 listing only</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>DAT</b> *</td>
    <td>print current date on formatted pages</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>NOD</b></td>
    <td>do not print the current date (corresponds to ASMB's <b>D</b> command 
    line option)</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr>
    <td valign="top"><b>NUM</b></td>
    <td>print line numbers (corresponds to ASMB's <b>N</b> command line option)</td>
  </tr>
  <tr>
    <td valign="top"><b>NON *</b></td>
    <td>do not print line numbers</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>INV</b></td>
    <td>print invisible lines</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>NOI *</b></td>
    <td>do not print invisible lines</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr>
    <td valign="top"><b>TSC</b></td>
    <td>strict TSC Assembler compatibility</td>
  </tr>
  <tr>
    <td valign="top"><b>NOT *</b></td>
    <td>accept source code in a much more relaxed format</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>WAR *</b></td>
    <td>print warnings</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>NOW</b></td>
    <td>only print errors, suppress warnings (corresponds to ASMB's <b>W</b> 
    command line option)</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr>
    <td valign="top"><b>CLL *</b></td>
    <td>check line length (see the <b>SETLI</b> directive on that)</td>
  </tr>
  <tr>
    <td valign="top"><b>NCL</b></td>
    <td>do not check line length</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>LFN</b></td>
    <td>print long file names; on Win32 systems, this causes the file names 
    displayed in warning and error messages to contain the full path name of the 
    corresponding source file.</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>NLF *</b></td>
    <td>do not print long file names</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr>
    <td valign="top"><b>LLL *</b></td>
    <td>list library file lines</td>
  </tr>
  <tr>
    <td valign="top"><b>NLL</b></td>
    <td>suppress listing of library file lines</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>GAS</b></td>
    <td>accept Gnu AS-compatible source code
      
This isn't fully implemented yet. At the moment, the only significant 
    difference is that A09 accepts constants in the form <b>0xXXXX</b> (hex), <b>
    0bXXXX</b> (binary), <b>0NNN</b> (octal) in addition to the "standard" <b>$</b>,<b>%</b>, 
    or <b>@</b> notation.</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>NOG *</b></td>
    <td>don't accept Gnu AS-compatible source code</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr>
    <td valign="top"><b>REL *</b></td>
    <td>print the relocation table if in Relocating Assembler mode</td>
  </tr>
  <tr>
    <td valign="top"><b>NOR</b></td>
    <td>suppress printing of the relocation table</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>M68|M09 *</b></td>
    <td>both forms accept Motorola 6809 mnemonics</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>H63|H09</b></td>
    <td>accept Hitachi 6309 mnemonics (still slightly experimental)</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>M00|M02|M08</b></td>
    <td>accept Motorola 6800 mnemonics</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>M01|M03</b></td>
    <td>accept Motorola 6801 mnemonics</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>H01|H03</b></td>
    <td>accept Hitachi 6301 mnemonics (slightly experimental)</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>H11</b></td>
    <td>accept Motorola 68HC11 mnemonics (very experimental)</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr>
    <td valign="top"><b>TXT</b></td>
    <td>print the text table if text symbols are defined (see <b>TEXT</b> directive)</td>
  </tr>
  <tr>
    <td valign="top"><b>NTX *</b></td>
    <td>do not print the text table</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>LPA</b></td>
    <td>print listing in f9dasm patch format  

This option makes it easier to create complex patches to be embedded in images processed by f9dasm</td>
  </tr>
  <tr bgcolor="#f0f0f0">
    <td valign="top"><b>NLP *</b></td>
    <td>don't print listing in f9dasm patch format</td>
  </tr>
  <tr>
    <td colspan="2" height="8" valign="top"></td>
  </tr>
  <tr>
    <td valign="top"><b>DLM</b></td>
    <td>define label on macro expansion; see
<a href="https://github.com/Arakula/A09/issues/1">Issue #1</a>
        for details.
    </td>
  </tr>
  <tr>
    <td valign="top"><b>NDL *</b></td>
    <td>do not define labels on macro expansion</td>
  </tr>
</tbody></table>


Each of the above options has a corresponding text symbol that is set to <b>0</b>
or <b>1</b>, corresponding to the state of the option. This allows for conditional
assembly, for example:

<pre>  IF &amp;H63
    LDW  Data
    SUBW #12
    STW  Data
  ELSE
    PSHS D
    LDD  Data
    SUBD #12
    STD  Data
    PULS D
  ENDIF</pre>

## Directives

A09 handles the full set of directives available in the FLEX9 ASMB and 
RELASMB programs (see the excellent Documentation section on
[www.flexusergroup.com](http://www.flexusergroup.com) for the manuals 
of these programs). Apart from these, it knows the following directives:


<table border="0" cellspacing="1" id="AutoNumber1">
  <tbody><tr>
    <td valign="top" width="25%"><b><i>[label]</i> BIN <i>filename</i></b> or  
<b><i>[label]</i> BINARY <i>filename</i></b></td>
    <td valign="top">loads the binary contents of the file given in <i>filename</i>
    at the current position</td>
  </tr>
  <tr>
    <td valign="top"><b>EXTERN <i>label</i></b></td>
    <td valign="top">is implemented as an alias to the <b>EXT</b> directive (see 
    RELASMB documentation)</td>
  </tr>
  <tr>
    <td valign="top"><b>FILL <i>value</i>,<i>bytecount</i></b></td>
	<td valign="top">writes the 8-bit value <b><i>value</i></b> into <b><i>bytecount</i></b> consecutive memory locations  

<b>Note:</b> if <b><i>bytecount</i></b> exceeds 255 and <b>OPT MUL</b> (see above) is set, only the first 255 bytes are shown
	in the listing.</td>
  </tr>
  <tr>
    <td valign="top"><b>IFD, IFND <i>symbol</i>[,<i>skipcount</i>]</b></td>
	<td valign="top">assembles the block up to the next <b>ELSE</b> or <b>ENDIF</b>
	directive if the symbol is (not) defined.  

<b>Attention:</b> this directive is a little bit dangerous - if the symbol is defined
	<i>after</i> the <b>IF(N)D</b> directive, phasing errors can occur!</td>
  </tr>
  <tr>
    <td valign="top"><b>PHASE <i>addr</i>  
DEPHASE</b></td>
    <td valign="top">tells the assembler that the following code shall be executed at
    the specified address. This "shifting" is switched off by the instruction
	<b>DEPHASE</b>.  

This can be useful for generation of EPROM contents which contain overlayed code banks
	where code has to be stored at an address in the EPROM (governed by <b>ORG</b>), but is
	<i>executed</i> at a different address (governed by <b>PHASE</b>).</td>
  </tr>
  <tr>
    <td valign="top"><b>REP</b>, <b>REPEAT<i> count</i></b></td>
    <td valign="top">are implemented as aliases to the <b>RPT directive</b> (see ASMB 
    documentation)</td>
  </tr>
  <tr>
    <td valign="top"><b>RZB</b>, <b>BSZ</b>, <b>ZMB <i>nnn</i></b></td>
    <td valign="top">works like the <b>RMB</b> directive (see ASMB documentation), but
    it doesn't only reserve memory, but also zeroes the reserved bytes  

<b>Note:</b> if <b><i>nnn</i></b> exceeds 255 and <b>OPT MUL</b> (see above) is set, only the first 255 bytes are shown
	in the listing.</td>
  </tr>
  <tr>
    <td valign="top"><b>SETLI <i>nnn</i></b></td>
    <td valign="top">sets the line length for listings (see the <b>CLL</b> option above); <b>
    <i>nnn</i></b> is the number of columns that can be printed in a line 
    (40-2000). If the <b>NCL</b> option is selected, A09 ignores the line width (default 
    is 80).</td>
  </tr>
    <tr><td valign="top"><b>SETPG <i>nnn</i></b></td>
    <td valign="top">sets the page length for paginated listings (see the <b>PAG</b> option 
    in the ASMB documentation); <b><i>nnn</i></b> is the number of lines that 
    fit on a page (10-1000, default is 66).</td>
  </tr>
  <tr>
    <td valign="top"><b>SYMLEN <i>nnn</i></b></td>
    <td valign="top">sets the maximum number of significant symbol characters;
	<b><i>nnn</i></b> is the number (6-32). For implications, see <b>Symbols</b> below.</td>
  </tr>
  <tr>
    <td valign="top"><b><i>label</i> TEXT <i>text</i></b></td>
    <td valign="top">this corresponds to the <b>-d<i>sym</i>[=<i>value</i>]</b> command line 
    option (see above).The FLEX9 ASMB and RELASMB programs can accept up to 3 
    replacement strings from the command line; these can be used in the source 
    file as "dummy parameters" &amp;A, &amp;B, and &amp;C (see section "COMMAND LINE 
    PARAMETERS" in the ASMB manual on page 50).
    A09 can do more than that. The <b>-d</b> command line option and the <b>
    TEXT</b> directive (which can, for example be given in a library file) allow 
    the definition of any number of text replacements (well... not really "any", 
    but 4000 should be no problem :-) which can then be used in the assembler 
    source as <b>&amp;<i>label</i></b>.
    In addition to all options (see above), the following constants are predefined:
    <table border="0" cellspacing="1" width="100%" id="AutoNumber2">
      <tbody><tr>
        <td valign="top"><b>&amp;ASM</b></td>
        <td>Name of the Assembler; contains <b>A09</b></td>
      </tr>
      <tr>
        <td valign="top"><b>&amp;VERSION</b></td>
        <td>contains the A09 version number as a hex constant ($<i>vvss</i>, 
        vv being the main version and ss being the subversion; at the time of writing,
		the version is <b>$0128</b>).</td>
      </tr>
      <tr>
        <td valign="top"><b>&amp;PASS</b></td>
        <td>current pass; contains <b>1</b> or <b>2</b></td>
      </tr>
      <tr>
        <td valign="top"><b>&amp;FILCHR</b></td>
        <td>filler character used for RMB areas in binary output files; defaults to <b>$00</b></td>
      </tr>
    </tbody></table>
    </td>
  </tr>
  <tr>
    <td valign="top"><b>TITLE <i>text</i></b></td>
    <td valign="top">is implemented as an alias to the <b>NAM</b>, <b>TTL</b> directive (see 
    ASMB documentation)</td>
  </tr>
</tbody></table>

## Symbol Table Contents

The symbol table produced by A09 is a bit more verbose than the original. For 
each symbol, it lists the symbol<i> name</i>,<i> type</i>, and <i>value</i>. The 
following symbol types can occur:


<table border="0" cellspacing="1" width="100%" id="AutoNumber3">
  <tbody><tr>
    <td><b>00</b></td>
    <td>constant value (from EQU)</td>
  </tr>
  <tr>
    <td><b>01</b></td>
    <td>variable value (from SET)</td>
  </tr>
  <tr>
    <td><b>02</b></td>
    <td>address within module (LABEL)</td>
  </tr>
  <tr>
    <td><b>03</b></td>
    <td>variable containing address</td>
  </tr>
  <tr>
    <td><b>04</b></td>
    <td>external label</td>
  </tr>
  <tr>
    <td><b>05</b></td>
    <td>variable containing external address</td>
  </tr>
  <tr>
    <td><b>06</b></td>
    <td>unresolved address</td>
  </tr>
  <tr>
    <td><b>07</b></td>
    <td>variable containing unresolved address</td>
  </tr>
  <tr>
    <td><b>08</b></td>
    <td>public label</td>
  </tr>
  <tr>
    <td><b>09</b></td>
    <td>macro definition</td>
  </tr>
  <tr>
    <td><b>10</b></td>
    <td>unresolved public label</td>
  </tr>
  <tr>
    <td><b>11</b></td>
    <td>parameter name</td>
  </tr>
  <tr>
    <td><b>13</b></td>
    <td>empty; should never occur</td>
  </tr>
  <tr>
    <td><b>14</b></td>
    <td>REG directive</td>
  </tr>
  <tr>
    <td><b>15</b></td>
    <td>TEXT directive (value is the index into the text table; if you want to
	    see the last used replacement text for this label, set the <b>TXT</b> option)
	</td>
  </tr>
  <tr>
    <td><b>18</b></td>
    <td>Common data block name (value is the length of the common data block in 
    this case)</td>
  </tr>
  <tr>
    <td><b>20</b></td>
    <td>Common data RMB label (value is the offset in the common data block)</td>
  </tr>
  <tr>
    <td><b>34</b></td>
    <td>local label (multiple definitions are sorted based on their address)</td>
  </tr>
  <tr>
    <td><b>38</b></td>
    <td>unresolved local label</td>
  </tr>
</tbody></table>

## Relocation Table Contents

The Relocation Table is something which doesn't exist in the original. When 
in Relocating mode, A09 creates this table to show where a relocation is to be 
applied. For each entry, A09 lists the <i>symbol name</i>, <i>type</i>, and the
<i>relocation address</i>. There can be a '-' prepended to the symbol name to 
indicate that the symbol is to be <i>subtracted</i> from the value at the 
relocation address (normally, the symbol is added). The relocation table uses 
the same set of types as the symbol table.

## Things that are.. and things that aren't

My version of A09 aims to reproduce the behaviour of the Flex9 
ASMB and RELASMB products. As of now, it reproduces about 99% of the originals' 
functionality, and surpasses them in some areas.
Some things still work slightly different or aren't implemented, however.

#### Expression Operators

In ASMB and RELASMB, ! denotes a "logical NOT operator"; "logical" in this
context means that each bit is inverted.
&#10;A09's original core came with a slightly different syntax for that, which
obviously has its roots in the "C" language the assembler is written in;
there, ! denotes a logical NOT (meaning that everything that's not 0
results in 0, and zero results in 1) and ~ denotes a binary inversion, which
corresponds to the ! in TSC's assemblers.
&#10;I decided to keep A09's syntax, as it is more versatile -
so ! has a slightly different meaning in A09 than in ASMB/RELASMB.

#### Symbols

A09 normally handles symbols with up to 32 significant characters.
This is far more than the 6 (ASMB) or 8 (RELASMB) places in the predecessors
and normally quite convenient, but it can cause problems when
  
- dealing with old sources that rely on the old maximum to work
  
- creating RELASMB-compatible relocatable modules

When creating RELASMB-compatible relocatable modules, the number of significant places
is automatically reduced to 8. To resolve issues with old sources, the <b>SYMLEN</b> directive
has been added in V1.10 (see above). The symbol table always shows the symbols reduced to the
number of significant places, since that's how they are treated internally.

#### Local Labels

This nice feature of RELASMB has been added to A09, too.
Due to the completely different implementation, and since A09 doesn't have to
work in the extremely limited address space available to a 6809,
A09 isn't restricted to 100 local labels; you can define as many local labels as you want to.
The only restriction is that the length of the all-numeric symbol must be less than the number
of significant symbol characters (see above) so that the <b>B</b> and <b>F</b> character can
be appended in references to the local label.

#### External Expressions

When in Relocating Assembler mode, you can define <i>external labels</i> (i.e., 
labels that refer to a location in another module, that are resolved by the 
Linker/Loader at a later time). These labels can be used in expressions, but in 
a more restricted way than in RELASMB, due to the way the parser works. If there 
is a mixture of relocatable and external elements in the expression, the 
relocatable elements have to be in pairs so that they effectively cancel each 
other's effect, just like in the original - but, additionally, the external 
label has to be either the last element in the expression or the paired 
relocatable elements have to be parenthesized. As an example,
<pre>rel1-rel2+ext1-rel2+rel1</pre>
 would be flagged as an error while
<pre>rel1-rel2-rel2+rel1+ext1
(rel1-rel2)+ext1-(rel2-rel1)</pre>
 would work.

The command line switch 
that instructs RELASMB to treat all undefined labels as external labels isn't 
implemented.

#### Fix Mode

RELASMB's Fix Mode is not implemented. While that may be a nifty feature, it 
can easily be replaced by a combination of <b>TEXT</b> and <b>IF</b> directives, 
which offer a better control over what gets assembled and what doesn't.

#### Macros

In RELASMB, nested macro definitions are allowed; in A09, they are not.
Nested macro calls, however, are possible; A09 allows up to 31 levels of macro call nesting.

Like in RELASMB, macros can be used to redefine mnemonics, but with a little twist
that is either missing in the original or undocumented: if the need arises to use the
original mnemonic in certain places, it can be prefixed with a backslash (\\);
in this case, A09 doesn't check for macros but uses the original mnemonic.
&#10;Prefixing a macro name that doesn't overload a mnemonic with \ leads to an error.

