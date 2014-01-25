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
        

playGame :: Int -> [Double] -> [Shapes] -> [[Shapes]] -> IO ()
--playGame n (rnd:rnds) rounds 
--First move
playGame n (d:ds)(rnd:rnds) [] 
  = do
    round <- playRound n rnd
    playGame n ds rnds (round:[])
playGame n (d:ds) (rnd:rnds) rounds 
  = do
    let nextMove = react d rounds
    round <- playRound n nextMove 
    playGame n ds rnds (round:rounds)
playGame _ __ [] _
  = do
    return ()


-- Pre: List is non-empty
react :: Double -> [[Shapes]] -> Shapes
react d p@(r:rs) 
  |d < 0.83   = snd (head ans) 
  |d < 0.9533 = snd (ans !! 1) 
  |d < 0.999  = snd (ans !! 2) 
  |otherwise  = snd (ans !! 3) 
  where
--  maxSc   = maximum score
  ans     = reverse ans'
  nPlayer = length r
  nRounds = length p
  ans'    = sortBy (compare `on` fst) (zip (react' p) allShapes)   

react' :: [[Shapes]] -> [Double]
react' p@(r:rs) 
  = score
  where
  score   = map eGain allShapes
--  score   = zipWith (+) (map fromIntegral (scoreRounds p)) (map (*(2* fromIntegral nRounds))(map eGain allShapes )) 
  stats   = getStats r rs (nPlayer)
  nPlayer = length r
  nRounds = length p
  eGain :: Shapes -> Double
  eGain m1= sum [(prob stats p m2 nRounds)*
                 (fromIntegral(beats m1 (toEnum (m2-1)))) 
                 | p <- [1..nPlayer],
                 m2 <- [1..5]]

--Pre: list is non-empty
scoreRounds :: [[Shapes]] -> [Int]
scoreRounds p@(r:rs)
  = foldl (zipWith (+)) [0,0..] (map (map (score r)) p)
  where
  score :: [Shapes] -> Shapes -> Int
  score shapes s
    = sum (map (beats s) shapes)

prob :: Array (Int,Int) Int -> Int -> Int -> Int -> Double
prob stats player move rounds
  = (fromIntegral(stats! (player,move))) / (fromIntegral rounds)


getStats :: [Shapes] -> [[Shapes]] -> Int
             -> Array (Int,Int) Int
getStats lr rs numPlayers
  = getStats' lr rs (array ((1,1),(numPlayers,5))[((i,j),0) 
                    | i <- [1..numPlayers],j <- [1..5]])

getStats' :: [Shapes] -> [[Shapes]] 
             -> Array (Int,Int) Int
             -> Array (Int,Int) Int
getStats' lr (r1:r:rs) stats
  |similar lr r = getStats' lr (r:rs) stats' 
  |otherwise    = getStats' lr (r:rs) stats
  where
    stats' = stats//
             [(pos i,(stats ! (pos i)) + 1 )
             |i <- [1..p]]
    (p,m)  = snd (bounds stats)
    pos:: Int -> (Int, Int)
    pos i'  = (i' , fromEnum (r!!(i'-1)) + 1 )
getStats' _ _ stats 
  = stats


similar :: [Shapes] -> [Shapes] -> Bool
similar s s'
  = sort s == sort s'

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

allShapes = [Rock,Paper,Scissors,Lizard,Spock]

--Pre ; item is in the list
lookUp :: Eq a => a -> [(a,b)] -> b
lookUp = (fromJust . ).lookup


playRound :: Int -> Shapes -> IO [Shapes]
playRound numPlayers s = do
              print s  
              mapM readMove [1..(numPlayers - 1)]

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
