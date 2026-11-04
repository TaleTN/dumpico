#!/usr/bin/perl

# Copyright (C) 2026 Theo Niessink <theo@taletn.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

# Replace PNG file inside ICO file.

use strict;
use warnings;

if ($#ARGV != 1) {
  $_ = $0; s/^.*[\\\/](.*)$/$1/;
  print "Usage: $_ <ICO file> <PNG file>\n";
  exit 1;
}

open(ICO, $ARGV[0]) or die "Can't read $ARGV[0]";
binmode ICO;

my $ico = join('', <ICO>);
close ICO;

my @hdr = unpack('v3', $ico);
my $n = $#hdr == 2 ? $hdr[2] : 0;
$n >= 1 and $hdr[0] == 0 and $hdr[1] == 1 or die "Invalid ICO file";

open(PNG, $ARGV[1]) or die "Can't read $ARGV[1]";
binmode PNG;

my $png = join('', <PNG>);
close PNG;

my $magic = "\x89PNG\r\n\x1A\n";
substr($png, 0, 8) eq $magic or die "Invalid PNG file";

my $hdr = substr($ico, 0, 6);
my $ofs = 6 + $n * 16;
my $data = '';

for (my $i = 0; $i < $n; $i++) {
  my @img = unpack('C4v2V2', substr($ico, 6 + $i * 16));

  $img[3] == 0 or die sprintf("Invalid ICO entry [%d]", $i);

  if ($img[0] == 0 and $img[1] == 0 and $img[2] == 0 and $img[4] == 1 and $img[5] == 32 and substr($ico, $img[7], 8) eq $magic) {
    $png or die;
    $data .= $png;

    $img[6] = length($png);
    $png = undef;
  } else {
    $data .= substr($ico, $img[7], $img[6]);
  }

  $img[7] = $ofs;

  $hdr .= pack('C4v2V2', @img);
  $ofs += $img[6];
}

$png and die "PNG file not found in ICO file";

open(ICO, ">$ARGV[0]") or die "Can't write $ARGV[0]";
binmode ICO;

print ICO $hdr . $data;
close ICO;
