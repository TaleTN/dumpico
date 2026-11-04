# Dump ICO file

A collection of simple Perl scripts that print an ICO file's entries,
extract a PNG file from an ICO file, and replace a PNG file inside an ICO
file.

## Dump ICO file

```
perl dumpico.pl input.ico
```

This will list the icon entries inside `input.ico`, e.g.:

```
Width  | Height | Colors | Planes | Bits   | Size       | Offset
-------+--------+--------+--------+--------+------------+-----------
48     | 48     | 16     | 1      | 4      | 1640       | 166
32     | 32     | 16     | 1      | 4      | 744        | 1806
16     | 16     | 16     | 1      | 4      | 296        | 2550
48     | 48     | 256    | 1      | 8      | 3752       | 2846
32     | 32     | 256    | 1      | 8      | 2216       | 6598
16     | 16     | 256    | 1      | 8      | 1384       | 8814
256    | 256    | 0      | 1      | 32     | 10347      | 10198
48     | 48     | 0      | 1      | 32     | 9640       | 20545
32     | 32     | 0      | 1      | 32     | 4264       | 30185
16     | 16     | 0      | 1      | 32     | 1128       | 34449
```

## Extract PNG from ICO file

```
perl expngico.pl input.ico output.png
```

This will extract the (first) PNG file inside `input.ico`, and save it as
`output.png`.

## Replace PNG in ICO file

```
perl repngico.pl replace.ico input.png
```

This will replace the PNG file inside `replace.ico` with the contents of
`input.png`.

## License

Copyright &copy; 2023-2026 Theo Niessink &lt;theo@taletn.com&gt;  
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
