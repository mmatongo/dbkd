#!/usr/bin/env perl

# Demotivator generator by Antoine Amarilli (2011)
# License: public domain.

if ($#ARGV != 3)
{
  print "mkdemotiv -- automatical demotivator generation\n";
  print "usage: mkdemotiv input text1 text2 output\n";
  print "input and output are paths to image input/output files\n";
  print "requires imagemagick and inkscape\n";
  exit 1;
}

my ($image, $text1, $text2, $output) = @ARGV;
my ($owidth, $oheight) = split('x', (split(' ', `identify $image`))[2]);

my $width = 800.;
my $height = 800. * (1. * $oheight / $owidth);

my $w = 110 + 110 + $width;
my $wrect = 10 + 10 + $width;
my $hrect = 10 + 10 + $height;
my $wtext = 20 + 20 + $width;
my $ytext1 = 70 + $height + 10;
my $ytext2 = $ytext1 + 100;
my $h = $ytext2 + 60;


#TODO add big first and last letter, bar underneath, multiline
$svg = <<END;
<?xml version="1.0" encoding="UTF-8" standalone="no"?>

<svg
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:xlink="http://www.w3.org/1999/xlink"
   version="1.2"
   width="$w"
   height="$h"
   id="svg2">
  <g id="layer">
    <rect
       width="$w"
       height="$h"
       ry="0"
       x="0"
       y="0"
       id="background"
       style="fill:#000000" />
    <rect
       width="$wrect"
       height="$hrect"
       x="100"
       y="60"
       id="white"
       style="fill:#ffffff" />
    <image
       xlink:href="$image"
       id="image"
       width="$width"
       height="$height"
       y="70"
       x="110" />
    <flowRoot id="root1" xml:space="preserve" style="font-family:FreeSerif; text-align:center">
      <flowRegion id="region1">
        <rect
           width="$wtext"
           height="240"
           x="70"
           y="$ytext1"
           id="rect1" />
      </flowRegion>
      <flowPara id="para1" style="font-size:90px;fill:#ffffff">$text1</flowPara>
    </flowRoot>
    <flowRoot id="root2" xml:space="preserve" style="font-family:FreeSerif; text-align:center">
      <flowRegion id="region2">
        <rect
           width="$wtext"
           height="110"
           x="70"
           y="$ytext2"
           id="rect2" />
      </flowRegion>
      <flowPara id="para2" style="font-size:32px;fill:#ffffff">$text2</flowPara>
    </flowRoot>
  </g>
</svg>
END

my $tmp1 = `mktemp`;
chop $tmp1;
#TODO ugly
open(F, "| inkscape /dev/stdin --export-png=/dev/stdout > $tmp1.png");
print F $svg;
close (F);
`convert $tmp1.png $output`

