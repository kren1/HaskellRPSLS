import java.util.Random;
import java.util.Arrays;

public class StatisticalBot 
{

  private int numPlayers;
  private int numRounds;
  private final GameHistory gameHistory;

  public  StatisticalBot(int numPlayers, int numRounds)
  {
      this.numPlayers = numPlayers;
      this.numRounds = numRounds;
      gameHistory = new GameHistory(numPlayers, numRounds);

  }

  public Move getNextMove() 
  {
    
    double[] expectedMoveGain  = new double[Move.values().length];
    
    for(int i = 0; i < Move.values().length; i++)
    {    
        for(int j = 0; j < numPlayers; j++)
        {
          for(Move m:Move.values())
          {
            expectedMoveGain[i] += gameHistory.probaliblityPlayerPlaysM(m , j) 
                                    * Round.value(Move.values()[i] , m);
          }
        }
    }
//    System.out.println(Arrays.toString(expectedMoveGain));    
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

    return Move.values()[bestMove];
  }

  public void finishRound(Round playedRound) 
  {
    gameHistory.addRound(playedRound);
  }

}
