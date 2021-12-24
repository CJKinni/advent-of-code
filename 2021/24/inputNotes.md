This was mostly solved by hand.

I might come back and clean this up a bit, but the
main.rb file was mostly used for stepping through rules
and getting a sense of how it should work.

REPA D14
div z 1
add x 10
REPB
add y 2
REPA D13
div z 1
add x 15
REPB
add y 16
REPA D12
div z 1
add x 14
REPB
add y 9
REPA D11
div z 1
add x 15
REPB
add y 0
REPA D10
div z 26
add x -8
REPB
add y 1
REPA D9
div z 1
add x 10
REPB
add y 12
REPA D8
div z 26
add x -16
REPB
add y 6
REPA D7
div z 26
add x -4
REPB
add y 6
REPA D6
div z 1
add x 11
REPB
add y 3
REPA D5
div z 26
add x -3
REPB
add y 5
REPA D4
div z 1
add x 12
REPB
add y 9
REPA D3
div z 26
add x -7
REPB
add y 3
REPA D2
div z 26
add x -15
REPB
add y 2
REPA
div z 26
add x -7
REPB
add y 3
mul y x
add z y 


-- REP A:
Y = Y * X
Z = Z + Y
W = D1
X = Z % 26

-- REP B:
X = W[D] != X
Z = Z * 25 * (W[D] != X) + 1
Y = W[D]

- Each cycle Z either stays at 0 or goes up by 26