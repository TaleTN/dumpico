#!perl

use strict;
use warnings;

if ($#ARGV != 0) {
  $_ = $0; s/^.*[\\\/](.*)$/$1/;
  print "Usage: $_ <ICO file>\n";
  exit 1;
}

open(ICO, $ARGV[0]) or die;
binmode ICO;

my $_ = join('', <ICO>);
close ICO;

my @hdr = unpack('v3', $_);
$hdr[0] == 0 and $hdr[1] == 1 or die;

my $n = $hdr[2];
$n >= 1 or die;

print "Width  | Height | Colors | Planes | Bits   | Size       | Offset\n" .
      "-------+--------+--------+--------+--------+------------+-----------\n";

for (my $i = 0; $i < $n; $i++) {
  my @img = unpack('C4v2V2', substr($_, 6 + $i*16));

  my $w = $img[0];
  my $h = $img[1];

  for (my $j = 0; $j < 2; $j++) {
    my $val = $img[$j];
    if ($val > 0) {
      printf("%-6d", $val);
    } else {
      print "256+  ";
    }
    print " | ";
  }

  printf("%-6d | %-6d | %-6d | %-10d | %d\n", $img[2], $img[4], $img[5], $img[6], $img[7]);

  my $type = substr($_, $img[7], 8) eq "\x89PNG\x0D\x0A\x1A\x0A" ? 'png' : 'bmp';
  my $fn = '_image_' . sprintf("%d", $i + 1) . ".$type";

  $type eq 'png' or next;

  open(IMG, '>' . $fn) or die;
  binmode IMG;

  # $type eq 'bmp' and print IMG 'BM' . pack('V', 14 + $img[6]) . pack('v2', 0, 0) . pack('V', 54);
  print IMG substr($_, $img[7], $img[6]);

  close IMG;
}
