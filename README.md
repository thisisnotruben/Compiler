# CSCV-453 Project 1

## Authors

* Ruben Alvarez Reyes
	* rubenreyes@email.arizona.edu

* Samuel Glenn Bryant
	* sbryant1@email.arizona.edu

## Description

* Flex 2.6.4.
* Bison 3.0.4.

## Test Usage for Flex

Switch `DEBUG_LEX` to `1` in [parse.l](parse.l)

```bash
# to run specific test in 'testcases/'
./test.sh $TEST_NUMBER

# to run all tests and output to 'resultS.txt'
./test.sh s
```

## Test Usage for Bison

Switch `DEBUG_LEX` to `0` in [parse.l](parse.l)

Switch `YDEBUG` to `1` in [parse.y](parse.y) for debug output or `0` to cease all output

```bash
# to run all tests and output to 'resultP.txt'
./test.sh p
```

## Test Usage

```bash
# Makefile targets: parse, scanner, clean, $testFile
make $TEST_FILE
```
