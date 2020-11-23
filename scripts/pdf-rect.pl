#!/usr/bin/env perl

# TODO: use instead, e.g.:
#   pdftocairo -pdf -x 50 -y 50 -W 640 -H 950 -paperw 640 -paperh 950 test.pdf test2.pdf

# crop pdf pages to a rectangle
# requires libpdf-api2-perl
# see http://stackoverflow.com/a/8986981
# usage: ./pdf-rect.pl INFILE OUTFILE X1 X2 Y1 Y2 NUMPAGES
# crop to [X1,X2] times [Y1,Y2] of original page dimensions
# process up to NUMPAGES (all pages if =0)

use strict; use warnings;
use PDF::API2;
use POSIX;

my $filename = shift;
my $ofilename = shift;
my $x1 = 1.*(shift);
my $y1 = 1.*(shift);
my $x2 = 1.*(shift);
my $y2 = 1.*(shift);
my $mypage = int(shift);
my $oldpdf = PDF::API2->open($filename);
my $newpdf = PDF::API2->new;
my $limit;
$limit = $oldpdf->pages if $mypage < 1;
$limit = $mypage if $mypage > 0;
for my $page_nb (1..($limit)) {
  my ($page, @cropdata);
  $page = $newpdf->importpage($oldpdf, $page_nb);
  @cropdata = $page->get_mediabox;
  print "$page_nb\n";
  print "$cropdata[0] $cropdata[1] $cropdata[2] $cropdata[3]\n";
  $cropdata[0] += $cropdata[2] * $x1;
  $cropdata[1] += $cropdata[3] * $y1;
  $cropdata[2] *= $x2;
  $cropdata[3] *= $y2;
  print "$cropdata[0] $cropdata[1] $cropdata[2] $cropdata[3]\n";
  $page->cropbox(@cropdata);
  $page->trimbox(@cropdata);
  $page->mediabox(@cropdata);
}
$newpdf->saveas($ofilename);

