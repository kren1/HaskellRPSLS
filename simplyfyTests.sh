#!/bin/bash
RUN="./Competition.rb"
ALW='java -ea AlwaysBotPlayer'
RND='java -ea RandomBotPlayer'
DALW='java -ea DefeatAlwaysBotPlayer'
REAC='java -ea ReactiveBotPlayer'
STAT='java -ea StatisticalBotPlayer'

HAS_REAC='./ReactiveBot'
HAS_STAT='./StrategicBot'

#while test $# -gt 0
#do
#  echo $1
#  shift
#done
#javac *.java
#$RUN "$DALW" "$REAC" "$STAT" "$RND" "$ALW \"C\""
#$RUN "$DALW" "$REAC" "$STAT" "$ALW \"C\"" "$HAS_STAT"
#$RUN "$HAS_REAC" "$HAS_STAT"
#$RUN  "$REAC" "$STAT" "$RND" "$DALW" "$HAS_REAC" "$HAS_STAT"
$RUN  "$REAC" "$STAT"  "$ALW \"C\"" "$ALW \"C\"" "$HAS_REAC" "$HAS_STAT" "$HAS_STAT" "$HAS_REAC" "$HAS_STAT"
#$RUN  "$ALW \"C\"" "$ALW \"#\"" "$HAS_STAT"

