#!/usr/bin/env perl

# convert to a custom shorthand for poems to HTML

my $toTxt = 0;
my $inDedication = 0;
(my $toTxt = 1 && shift) if $ARGV[0] eq "-txt";

while (<STDIN>) {
  chop;
  exit if (/^###/);
  next if (/^#/);

  if (!$title and !$seen) {
    $title = "$_";
    next;
  }

  if (/^  /) {
    print "<p class=\"dedication\">\n" if not $inDedication;
    $inDedication = 1;
    print;
    print "<br />\n";
    next;
  } else {
    print "</p>\n" if $inDedication;
    $inDedication = 0;
  }
  print "<h3 class=\"ref\">$1</h3>\n" and next if (/^==\* (.*)$/);
  print "<h3>$1</h3>\n" and next if (/^== (.*)$/);
  if (/^$/) {
    if (!$seen) {
      print "<h2 id=\"$ARGV[0]\">$title</h2>\n" if (!$toTxt);
    } else {
      print "</div>\n" if ($in);
    }
    $in = 0;
    $seen = 1;
    next;
  }

  print "<div class=\"stanza\">\n" if (!$in && !$toTxt);
  if (!$seen) {
    print "<p class=\"line\">$title</p>\n";
    $seen = 1;
  }

  my $class = "line";
  if ($_ =~ /^> /) {
    $class = "line indent";
    $_ =~ s/^> //;
  }
  if ($toTxt) {
    print "$_\n";
    next;
  }
  $_ =~ s!\*(.*?)\*!<em>$1</em>!g;
  print "<p class=\"$class\">\n$_\n</p>\n";
  $in = 1;
}


