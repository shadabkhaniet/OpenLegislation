#!/bin/bash

#NODE_TOTAL=${CIRCLE_NODE_TOTAL:-1}
NODE_TOTAL=`expr ${CIRCLE_NODE_TOTAL:-1} - 1`
NODE_INDEX=${CIRCLE_NODE_INDEX:-0}

if [ ${NODE_TOTAL} -eq 0 ]
then
NODE_TOTAL=${CIRCLE_NODE_TOTAL:-1}
echo "Node total value now..$NODE_TOTAL"
fi

i=0
tests=()
for file in $(find ./src/test/java -name "*Test.java" | sort)
do
  if [ $(($i % ${NODE_TOTAL})) -eq ${NODE_INDEX} ]
  then
    test=`basename $file | sed -e "s/.java//"`
    tests+="${test},"
  fi
  ((i++))
done

#mvn -Dmaven.test.skip=true clean install
#mvn clean -Dtest=${tests} test
#mvn -Dtest=${tests} test jacoco:report coveralls:report

mvn  -Dtest=${tests} test jacoco:report coveralls:report

#if [ ${NODE_TOTAL} -eq ${NODE_INDEX} ]
#then
# mvn -o site
#else
#mvn  -Dtest=${tests} test jacoco:report coveralls:report
#fi

#if [ ${NODE_TOTAL} -eq 1 ]
#then
#mvn  -Dtest=${tests} test jacoco:report coveralls:report 
#mvn  -Dtest=${tests} test jacoco:report coveralls:report site
#fi
 
