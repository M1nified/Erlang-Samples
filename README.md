# Erlang-Samples

[![Build Status](https://travis-ci.org/M1nified/Erlang-Samples.svg?branch=master)](https://travis-ci.org/M1nified/Erlang-Samples)

## TL;DR

``` bash
./run.sh
```

## Compile

``` bash
erl -make
```

## Run

``` bash
erl -pa ebin
```

## Test

``` bash
./test.sh
```

This script runs `eunit:test/2` function for all compiled modules named `*_SUITE`.