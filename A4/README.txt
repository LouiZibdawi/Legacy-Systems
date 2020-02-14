gcc -o sieve-c sieve.c -Wall
gfortran -o sieve-f95 sieve.f95 -Wall
python ./sieve.py
gnatmake -o sieve-adb sieve.adb -Wall
cobc -x -free -Wall sieve.cob
