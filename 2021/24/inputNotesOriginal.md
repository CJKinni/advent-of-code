inp w   # w = D14
eql x 0 # x = 1
add y w # y = D14
add y 2 # y = D14 + 2
add z y # z = D14 + 2
inp w   # w = D13
mul x 0 # x = 0
add x z # x = D14 + 2
-- mod x 26
-- div z 1
add x 15 # x = D14 + 17
-- eql x w
-- eql x 0
mul y 0 # y = 0
add y 25 # y = 25
mul y x # y = (25 * D14) + 425
add y 1 # y = (25 * D14) + 426
mul z y # z = (50 * D14^2) + 852 [ERROR PRONE]
mul y 0 # y = 0
add y w # y = D13
add y 16 # y = D13 + 16
mul y x # y = (D14 + 17) * (D13 + 16)
add z y # z = (50 * D14^2) + 852 + ((D14 + 17) * (D13 + 16))
inp w   # w = D12
mul x 0 # x = 0
add x z # x = (50 * D14^2) + 852 + ((D14 + 17) * (D13 + 16))
mod x 26 # x = ((50 * D14^2) + 852 + ((D14 + 17) * (D13 + 16))) % 26
-- div z 1
add x 14 # x = (((50 * D14^2) + 852 + ((D14 + 17) * (D13 + 16))) % 26) + 14
eql x w 
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 9
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 15
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 0
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -8
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 1
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 12
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -16
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 6
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -4
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 6
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 11
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 3
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -3
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 5
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 9
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -7
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 3
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -15
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -7
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 3
mul y x
add z y