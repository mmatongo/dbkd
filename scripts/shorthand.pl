#!/usr/bin/perl

# Convert my shorthand to beamer

my $escaping = 0;
my $codeescape = 0;
my $in_frame = 0;
my @env = qw();
my @envd = qw();
my $subsecneeded = 0;
my $header = <<END;
\\documentclass{beamer}
\\usepackage{fontspec}
\\usepackage{graphicx, verbatim, array, xspace, booktabs, tikz, url, etoolbox,multirow,tabularx,minibox,tikz-qtree,minted}
\\usetheme{Frankfurt}
\\usecolortheme{beaver}
\\definecolor{beamer\@blendedblue}{rgb}{1,0,0}
\\colorlet{darkgreen}{green!50!black}
\\newcommand{\\imgp}[2]{
  \\begin{figure}
  \\begin{center}
  \\includegraphics[scale=#2]{#1.pdf}
  \\end{center}
  \\end{figure}
}
\\setbeamertemplate{navigation symbols}{}
\\makeatletter
\\newcommand{\\myitemarrow}{\$\\rightarrow\$}
\\setbeamertemplate{footline}
{%
  \\hfill \\insertframenumber/\\inserttotalframenumber \\hspace{0.2cm}
  \\vspace{0.2cm}
}%
\\makeatother
\\newenvironment{changemargin}[2]{%
  \\begin{list}{}{%
    \\setlength{\\topsep}{0pt}%
    \\setlength{\\leftmargin}{#1}%
    \\setlength{\\rightmargin}{#2}%
    \\setlength{\\listparindent}{\\parindent}%
    \\setlength{\\itemindent}{\\parindent}%
    \\setlength{\\parsep}{\\parskip}%
  }%
  \\item[]}{\\end{list}} 
END

sub reformat()
{
  my $ll = $_[0];
  $ll =~ s/\*([^*]+)\*/\\textcolor{red}{$1}/g;
  $ll =~ s/``/UNIQUEBLAH/g;
  $ll =~ s/\`([^`]+)\`/\\texttt{$1}/g;
  $ll =~ s/UNIQUEBLAH/``/g;
  $ll;
}

my $header2a = <<END;
\\AtBeginSection[]
{
END
my $header2b = <<END;
  \\ifnumcomp{\\value{section}}{=}{1}{}
    {
END
my $header2c = <<END;
  \\begin{frame}<beamer>
    \\frametitle{\\mytocname}
    \\tableofcontents[currentsection]
  \\end{frame}
END
my $header2d = <<END;
}
END
my $header2e = <<END;
}
END

my $header3a = <<END;
\\begin{document}
END

my $header3b1 = <<END;
\\begin{frame}
END

my $header3b2 = <<END;
\\begin{frame}[plain,noframenumbering]
END

my $header3c = <<END;
\\titlepage
END

my $header3d = <<END;
\\end{frame}
END

print $header;

my $defaultlang = "";
my $toc = 1;
my $nofirsttoc = 1;
my $titlenum = 1;
my $ontitle = "";

while (<>) {
  last if /^$/;
  if (/^\\usepackage\[[^]]*,([^\],]*)\]\{babel\}/) {
    $defaultlang = $1;
  }
  if (/NOTOC/) {
    $toc = 0;
    next;
  }
  if (/NOTITLENUM/) {
    $titlenum = 0;
    next;
  }
  if (/ALLTOC/) {
    $nofirsttoc = 0;
    next;
  }
  if (/^ONTITLE (.*)/) {
    $ontitle = $1;
    next;
  }
  print;
}

if ($toc) {
  print $header2a;
  print $header2b if $nofirsttoc;
  print $header2c;
  print $header2d if $nofirsttoc;
  print $header2e;
}
print $header3a;
if ($titlenum) {
  print $header3b1;
} else {
  print $header3b2;
}
print $header3c;
if (length($ontitle) > 0) {
  print "\\vfill ";
  print $ontitle;
}
print $header3d;

while (<>) {
  my $l = $_;
  if ($escaping) {
    if ($l =~ /^\?>$/) {
      $escaping = 0;
    } else {
      print $l;
    }
    next;
  }
  if ($codeescape) {
    if ($l =~ /^```$/) {
      $codeescape = 0;
      print "\\end{minted}\n";
      print "\\end{otherlanguage}\n" if length($defaultlang) > 0;
    } else {
      print $l;
    }
    next;
  }
  if ($l =~ /^<\?$/) {
    $escaping = 1;
    next;
  }
  if ($l =~ /^FORCEEND/) {
    print "\\end{frame}\n\n" if ($in_frame == 1);
    $in_frame = 0;
    next;
  }
  if ($l =~ /^(!f?) (.*)/) {
    print "\\end{frame}\n\n" if ($in_frame == 1);
    print "\\subsection\{\}\n" if ($subsecneeded == 1);
    $subsecneeded = 0;
    $tit = &reformat($2);
    if ($1 eq "!f") {
      # TODO: do this automatically
      print "\\begin{frame}[fragile]\{$tit\}\n";
    } else {
      print "\\begin{frame}\{$tit\}\n";
    }
    $in_frame = 1;
    next;
  }
  if ($l =~ /^(=+) (.*) (=+)(!?)(\*?)$/) {
    print "\\end{frame}\n\n" if ($in_frame == 1);
    $in_frame = 0;
    my $nest = length($1);
    my $level;
    if ($nest == 2) {
      $level = "section";
      $subsecneeded = 1 if ($4 eq "");
    }
    if ($nest == 3) {
      $level = "subsection";
      $subsecneeded = 0;
    }
    $level = "$level*" if $5 eq "*";
    if ($2 =~ /^ *\[([^]]*)\] (.*)/) {
      print "\\$level\[$1\]\{$2\}\n";
    } else {
      print "\\$level\{$2\}\n";
    }
    next;
  }
  if ($l =~ /^\.\.\.$/) {
    print "\\pause\n";
    next;
  }
  if ($l =~ /^```(.*)$/) {
    print "\\begin{otherlanguage}{english}\n" if length($defaultlang) > 0;
    print "\\begin{minted}{$1}\n";
    $codeescape = 1;
    next;
  }
  if ($l =~ /^$/) {
    while (@env > 0) {
      my $e = pop @env;
      my $ed = pop @envd;
      print "\\end{$e}\n\n";
    }
    print "\n";
    next;
  }
  if (/^( *)(-|\[|=>)(.*)/) {
    my $indent = length($1);
    while (@env > 0 and $envd[-1] > $indent) {
      my $e = pop @env;
      my $ed = pop @envd;
      print "\\end{$e}\n\n";
    }
    my $key = "";
    if ($2 eq "[") {
      if ($3 =~ /([^]]*)\](.*)/) {
        $l = "$2";
        $key = $1;
      }
    } else {
      if ($2 eq "=>") {
        $key = "\\textcolor{red}{\\myitemarrow}";
      }
      $l = "$3";
    }
    if (@envd == 0 or $indent > $envd[-1]) {
      my $symb = $2;
      if ($symb eq "[") {
        $e = "description";
      } else {
        $e = "itemize";
      }
      push (@env, $e);
      push (@envd, $indent);
      if ($l =~ /^ *$/ and $symb eq "[") {
        # TODO: do this automatically
        print "\\begin\{$e\}\[$key\]\n";
        next;
      } else {
        print "\\begin\{$e\}\n";
      }
    }
    $key = &reformat($key);
    if (length($key) > 0) {
      print "\\item[$key] ";
    } else {
      print "\\item ";
    }
    $l = "$l\n";
  }
  $l = &reformat($l);
  print $l;
}

print "\\end{frame}\n\n" if ($in_frame == 1);
print "\\end{document}\n";
