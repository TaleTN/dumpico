#!/usr/bin/perl

# Copyright (C) 2023-2026 Theo Niessink <theo@taletn.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.

# Print ICO file entries.

use strict;
use warnings;

if ($#ARGV != 0 or $ARGV[0] =~ /^(?:\/\?|-h|--help)$/) {
  $_ = $0; s/^.*[\\\/](.*)$/$1/;
  print "Usage: $_ <ICO file>\n";
  exit 1;
}

open(ICO, $ARGV[0]) or die "Can't read $ARGV[0]";
binmode ICO;

my $ico = join('', <ICO>);
close ICO;

my @hdr = unpack('v3', $ico);
my $n = $#hdr == 2 ? $hdr[2] : 0;
$n >= 1 and $hdr[0] == 0 and $hdr[1] == 1 or die "Invalid ICO file";

print "Width  | Height | Colors | Planes | Bits   | Size       | Offset\n" .
      "-------+--------+--------+--------+--------+------------+-----------\n";

for (my $i = 0; $i < $n; $i++) {
  my @img = unpack('C4v2V2', substr($ico, 6 + $i * 16));

  $img[3] == 0 or die sprintf("Invalid ICO entry [%d]", $i);

  printf("%-6d | %-6d | %-6d | %-6d | %-6d | %-10d | %d\n",
    $img[0] ? $img[0] : 256,
    $img[1] ? $img[1] : 256,
    $img[2] ? $img[2] : $img[5] == 8 ? 256 : 0,
    $img[4], $img[5], $img[6], $img[7]);
}
