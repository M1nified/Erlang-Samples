#!/bin/bash  
SUITES=`ls ebin | grep _SUITE`
SUITES=${SUITES//.beam/}
SUITES="${SUITES[*]}"
# echo $SUITES
SUITES_STR=""
for SUITE in $SUITES; do
  SUITES_STR="$SUITES_STR, $SUITE"
done
# echo ${SUITES_STR#, }
erl -noshell -pa ebin -eval "eunit:test([${SUITES_STR#, }], [verbose])" -s init stop
# erl -noshell -pa ebin -eval "eunit:test(pmap_SUITE, [verbose])" -s init stop