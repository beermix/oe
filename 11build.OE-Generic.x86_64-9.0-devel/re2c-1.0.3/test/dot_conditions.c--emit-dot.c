/* Generated by re2c */
digraph re2c {
0 -> state1 [label="state=state1"]
0 -> state2 [label="state=state2"]
state1 -> 2
2 -> 3 [label="[0x00-`][b-e][g-0xFF]"]
2 -> 4 [label="[a]"]
2 -> 5 [label="[f]"]
4 -> 3 [label="[0x00-a][c-0xFF]"]
4 -> 6 [label="[b]"]
5 -> 3 [label="[0x00-n][p-0xFF]"]
5 -> 7 [label="[o]"]
6 -> 3 [label="[0x00-b][d-0xFF]"]
6 -> 8 [label="[c]"]
7 -> 3 [label="[0x00-n][p-0xFF]"]
7 -> 10 [label="[o]"]
8 -> 9
9 [label="dot_conditions.c--emit-dot.re:6"]
10 -> 11
11 [label="dot_conditions.c--emit-dot.re:8"]
state2 -> 13
13 -> 14 [label="[0x00-`][b-0xFF]"]
13 -> 15 [label="[a]"]
15 -> 14 [label="[0x00-a][c-0xFF]"]
15 -> 16 [label="[b]"]
16 -> 14 [label="[0x00-b][d-0xFF]"]
16 -> 17 [label="[c]"]
17 -> 18
18 [label="dot_conditions.c--emit-dot.re:7"]
}
re2c: warning: line 10: control flow in condition 'state1' is undefined for strings that match 
	'[\x0-\x60\x62-\x65\x67-\xFF]'
	'\x61 [\x0-\x61\x63-\xFF]'
	'\x66 [\x0-\x6E\x70-\xFF]'
	'\x61 \x62 [\x0-\x62\x64-\xFF]'
	'\x66 \x6F [\x0-\x6E\x70-\xFF]'
, use default rule '*' [-Wundefined-control-flow]
re2c: warning: line 10: control flow in condition 'state2' is undefined for strings that match 
	'[\x0-\x60\x62-\xFF]'
	'\x61 [\x0-\x61\x63-\xFF]'
	'\x61 \x62 [\x0-\x62\x64-\xFF]'
, use default rule '*' [-Wundefined-control-flow]
