#!/bin/bash
RUN="./Competition.rb"
ALW='java -ea AlwaysBotPlayer'
RND='java -ea RandomBotPlayer'
DALW='java -ea DefeatAlwaysBotPlayer'
REAC='java -ea ReactiveBotPlayer'
STAT='java -ea StatisticalBotPlayer'

while test $# -gt 0
do
  echo $1
  shift
done

#$RUN "$RND" "$DALW"

