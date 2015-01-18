# HaskellRPSLS

Build the bot by invoking 
```
    ./build
```
Then run it with:

```
./StrategicBot
```

Now type in two integers one for the number of players and the other for number of rounds played. It will then output it's choice and you can type in the rest of the choices for other players. It can be run with sample input:
 ```
 ./StrategicBot < TextBot.test
 ```
 
 Or you can run the competition by invoking the ruby script with itself:

 ```
 ./Competition.rb ./StrategicBot ./StrategicBot ./StrategicBot
 ```
 will run the competition with 3 same bots, you can put there any number of your own bots the conform to the rules.
 
 BUG: Strategic bot will not work for just 2 players
 
 Final note: Non haskell part of the repo belongs to it's respective owners
