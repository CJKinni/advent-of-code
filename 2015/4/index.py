# Create an md5 hash of string
import hashlib

string = 'yzbqklnj'
value = '123'
number = 1
print(str(hashlib.md5(f"{string}{number}".encode())))
while str(hashlib.md5(f"{string}{number}".encode()))[0:2] == '00':
    number += 1

print(number)
print(value)
print(hashlib.md5(f"{string}{number}".encode()))