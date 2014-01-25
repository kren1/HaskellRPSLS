import java.util.Random;
import java.util.Arrays;

public class StatisticalBot 
{

  private int numPlayers;
  private int numRounds;
  private final GameHistory gameHistory;
  private final Random random = new Random();

  public  StatisticalBot(int numPlayers, int numRounds)
  {
      this.numPlayers = numPlayers;
      this.numRounds = numRounds;
      gameHistory = new GameHistory(numPlayers, numRounds);

  }

  public Move getNextMove() 
  {
    
    double[] expectedMoveGain  = new double[Move.values().length];
    int similarRounds = gameHistory.getNumOfSimilarRounds();

    if(similarRounds < 1)
    {
      return Move.values()[random.nextInt(Move.values().length)];
    }
    
    for(int i = 0; i < Move.values().length; i++)
    {    
      expectedMoveGain[i] = eGain(Move.values()[i]);
    }
   int bestMove = 0;
    double prevGain = 0;
    for(int i = 0; i < expectedMoveGain.length; i++)
    {
      if(expectedMoveGain[i] > prevGain)
      {
        prevGain = expectedMoveGain[i];
        bestMove = i;
      }
    }
   // if(gameHistory.getCurrentRound() > 10)
//       System.out.println(eGain(Move.ROCK));    
   //System.out.println(Arrays.toString(expectedMoveGain) + Move.values()[bestMove]);    
 
    return Move.values()[bestMove];
  }
  private double eGain(Move m1)
  {
    double gain = 0;
    int[][] stats = gameHistory.getStats();

    for(int j = 0; j < numPlayers - 1; j++)
    {
      double sum = 0;
      for(int i1: stats[j])
      {
        sum += (double)i1;
      }
      for(Move m2:Move.values())
      {
        //System.out.println(Round.value(m1,m2));
        gain += (stats[j][m2.ordinal()]/sum) * Round.value(m1,m2);
      }
    }
    return gain;
  }
  public void finishRound(Round playedRound) 
  {
    gameHistory.addRound(playedRound);
  }
}
