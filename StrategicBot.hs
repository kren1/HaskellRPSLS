module Main where
import System.IO
import System.Random
import Data.Char
import Data.Function
import Data.Array
import Data.List
import Data.Maybe
import Control.Applicative


data Shapes = Rock | Paper | Scissors | Lizard | Spock
     deriving (Eq,Ord, Enum, Bounded)


-- (golombsID of the round, list of Shapes palyed by the players)
-- head of Round is this plazyer!!!!!!!!!
type Round = (Int,[Shapes])
type MoveCount = (Double,Double,Double,Double,Double)
type PlayerProb = [MoveCount]
type GameStatus = ([Int],[Int])
type PlayerHistory = [[Shapes]]
type BestMove      = (Shapes,Shapes)

--type MoveCount = (Int,Int,Int,Int,Int)

main = do
       gen <- getStdGen
       numPlayer' <- getLine
       numRounds' <- getLine
       hSetBuffering stdout LineBuffering

       let numPlayers   = read numPlayer' :: Int
           numRounds    = read numRounds' :: Int
           roundomMoves = randoms gen     :: [Shapes] 
           randomDouble = randoms gen     :: [Double]
       playGame numPlayers randomDouble (take numRounds roundomMoves) []
       --mapM_ (playRound numPlayers )(take numRounds roundomMoves)
        

playGame :: Int -> [Double] -> [Shapes] -> [Round] -> IO ()
--playGame n (rnd:rnds) rounds 
--First move
playGame n (d:ds)(rnd:rnds) [] 
  = do
    round <- playRound n rnd
    playGame n ds rnds (round:[])
playGame n (d:ds) (rnd:rnds) rounds 
  = do
    let nextMove = react d rnd rounds
    round <- playRound n nextMove 
    playGame n ds rnds (round:rounds)
playGame _ __ [] _
  = do
    return ()


-- Pre: List is non-empty
react :: Double -> Shapes -> [Round] -> Shapes
react rnd rns rounds
  = case relevant (head rounds) rounds of
     []    -> rns
     rel   -> smart rel
    
smart :: [Round] -> Shapes
smart rs
  = allShapes !! fromJust (elemIndex (maximum counted) counted)
  where
    stats     = playerProbs (playerMoveHistory rs) 
    bestMoves = best2Moves4Player stats
    (raw,win) = gameScore rs
    others    = zip win bestMoves
--    ordered   = sortBy ((flip compare) `on` fst) others
    me        = fst (head others)
    counted   = map (length.((flip elemIndices) goodMoves)) allShapes
    goodMoves = concatMap f others
    f (score,(a,b))
      |score > me  = a:a:b:b:[] 
      |otherwise   = pairToList (a,b)

pairToList :: (a,a) -> [a]
pairToList (x,x') = x:x':[]

best2Moves4Player :: PlayerProb -> [BestMove]
best2Moves4Player  
  = map prob2BestMove

prob2BestMove :: MoveCount -> BestMove
prob2BestMove (r,p,s,l,sp)
  = if duplicate == Nothing then (b,b1) else (m, head (delete m pb))
  where
    ls              = zip [r,p,s,l,sp] allShapes
    (_,w):(_,w'):os = sortBy ((flip compare) `on` fst) ls
    pb@(b:b':[])    = shapeThatBeats w
    p'@(b1:b1':[])  = shapeThatBeats w'
    duplicate       = getDuplicate pb p' 
    m               = fromJust duplicate


getDuplicate :: Eq a => [a] -> [a] -> Maybe a
getDuplicate pb p'
  = case intersect pb p' of
    [] -> Nothing 
    (x:xs) -> Just x

shapeThatBeats :: Shapes ->[Shapes]
shapeThatBeats Rock      = [Spock,Paper]
shapeThatBeats Paper     = [Lizard,Scissors]
shapeThatBeats Scissors  = [Rock,Spock]
shapeThatBeats Lizard    = [Rock,Scissors]
shapeThatBeats Spock     = [Lizard,Paper]


gameScore :: [Round] -> GameStatus
gameScore s
  =  (pureScore, winScore)
  where
    pureScore  = (map sum) (transpose individual)
    winScore   = (map sum) (transpose (map playerPosition individual))
    individual = map (roundScore.snd) s

playerPosition :: [Int] -> [Int]
playerPosition raw
  = fst (unzip (sortBy (compare `on` snd) ((5,i):(2,i'):t)))
  where
    (_,i):(_,i'):s = sortBy ((flip compare) `on` fst) (zip raw [0..])
    t = map (\(_,p) -> (0,p)) s

playerProbs :: PlayerHistory -> PlayerProb
playerProbs rs 
  = map ((divide (fromIntegral (length rs) - 0)).(count nullM)) rs

--Pre: there is atleast one elemnt in the list
relevant :: Round -> [Round] -> [Round]
relevant r' (r2:r:rs)
  |fst r' == fst r = r2:relevant r' (r:rs)
  |otherwise       = relevant r' (r:rs)
relevant _ (r:rs)
  = []

playerMoveHistory :: [Round] -> PlayerHistory
playerMoveHistory 
  = transpose.map snd

count :: MoveCount -> [Shapes]  -> MoveCount
count c (Rock:s)     = count (rockPlus c) s
count c (Paper:s)    = count (paperPlus c) s
count c (Scissors:s) = count (scissorsPlus c) s
count c (Lizard:s)   = count (lizardPlus c) s
count c (Spock:s)    = count (spockPlus c) s
count c []           = c

divide :: Double -> MoveCount -> MoveCount
divide d (r,p,s,l,s') = (r/d,p/d,s/d,l/d,s'/d) 

allShapes = [Rock,Paper,Scissors,Lizard,Spock]

--Pre ; item is in the list
lookUp :: Eq a => a -> [(a,b)] -> b
lookUp = (fromJust . ).lookup


playRound :: Int -> Shapes -> IO Round
playRound numPlayers s = do
              print s  
              ms <- mapM readMove [1..(numPlayers - 1)]
              return (hash(s:ms),ms)

readMove :: Int -> IO Shapes
readMove _ = do
             move <- getLine
             if move == [] then readMove 0 
             else 
               case move of
               --[]        -> return Spock
               ['@']     -> return Rock
               ['#']     -> return Paper
               ['8','<'] -> return Scissors
               ['C']     -> return Lizard
               ['V']     -> return Spock
            --   _         -> return Spock
               
hash :: [Shapes] -> Int
hash 
  = foldl (flip$(+).golombId) 0

golombId :: Shapes -> Int
golombId Rock     = 1
golombId Paper    = 2
golombId Scissors = 5
golombId Lizard   = 10
golombId Spock    = 12

instance Random Shapes where
   random g = case randomR (fromEnum (minBound :: Shapes), fromEnum (maxBound :: Shapes)) g of
                    (r, g') -> (toEnum r, g')
   randomR (a,b) g = case randomR (fromEnum a, fromEnum b) g of
                    (r, g') -> (toEnum r, g')

instance Show Shapes where
  show Rock      = "@"
  show Paper     = "#"
  show Scissors  = "8<"
  show Lizard    = "C"
  show Spock     = "V"

beats :: Shapes -> Shapes -> Int
beats s s'
  |s == s'       = 0
beats Rock s
  |s == Scissors = 1
  |s == Lizard   = 1
  |otherwise     = -1
beats Paper s
  |s == Spock    = 1
  |s == Rock     = 1
  |otherwise     = -1
beats Scissors s
  |s == Paper    = 1
  |s == Lizard   = 1
  |otherwise     = -1
beats Lizard s
  |s == Spock    = 1
  |s == Paper    = 1
  |otherwise     = -1
beats Spock s
  |s == Rock     = 1
  |s == Scissors = 1
  |otherwise     = -1

roundScore :: [Shapes] -> [Int]
roundScore s
  = map ((flip shapeScore) c) s
  where
    c = count nullM s

shapeScore :: Shapes -> MoveCount -> Int
shapeScore Rock c = round (lizard c + scissors c - spock c - paper c)
shapeScore Paper c = round (spock c + rock c - scissors c - lizard c)
shapeScore Scissors c = round (lizard c + paper c - spock c - rock c)
shapeScore Lizard c = round (spock c + paper c - rock c - scissors c)
shapeScore Spock c = round (rock c + scissors c - lizard c - paper c)

paper (_,p,_,_,_)    = p
rock (r,_,_,_,_)     = r
scissors (_,_,s,_,_) = s
lizard (_,_,_,l,_)   = l
spock (_,_,_,_,s)    = s

rockPlus (r,p,s,l,s')     = (r+1,p,s,l,s') 
paperPlus (r,p,s,l,s')    = (r,p+1,s,l,s') 
scissorsPlus (r,p,s,l,s') = (r,p,s+1,l,s') 
lizardPlus (r,p,s,l,s')   = (r,p,s,l+1,s') 
spockPlus (r,p,s,l,s')    = (r,p,s,l,s'+1) 

nullM = (0,0,0,0,0)

io1 = [[Rock,Paper,Spock,Paper],[Spock,Lizard,Paper,Spock],
        [Paper,Paper,Rock,Spock],[Rock,Paper,Spock,Paper],
        [Spock,Lizard,Paper,Spock],[Paper,Paper,Rock,Spock]]

round1 = zip (map hash io1) io1
