import java.util.Random;

public class DefeatAlwaysBot 
{

  private Move[] AlwaysBotMoves; 
  private int numPlayers;
  private final Random random = new Random();

  public  DefeatAlwaysBot(int numPlayers)
  {
      this.numPlayers = numPlayers;
  }

  public Move getNextMove() 
  {
    if(AlwaysBotMoves == null)
      return Move.values()[random.nextInt(Move.values().length)];
    
    Move bestMove = null;
    Move currentMove;
    int bestMoveScore    = 0;
    int currentMoveScore = 0;
    for(int i = 0; i < Move.values().length; i++)
    {
      currentMove = Move.values()[i];
      for(int j = 0; j < AlwaysBotMoves.length; j++)
      {
        if(AlwaysBotMoves[j] != null)
        {
          if(currentMove.beats(AlwaysBotMoves[j]))
            currentMoveScore++;
          else if(currentMove != AlwaysBotMoves[j] && !currentMove.beats(AlwaysBotMoves[j]))
            currentMoveScore--;
        }
     }
      if(currentMoveScore > bestMoveScore)
      {
        bestMoveScore = currentMoveScore;
        bestMove = currentMove;
        currentMoveScore = 0;
      }
    }

    if(bestMove == null)
      return Move.values()[random.nextInt(Move.values().length)];

    return bestMove;

  }

  public void finishRound(Round playedRound) 
  {
    if(AlwaysBotMoves == null)
    {
      AlwaysBotMoves = new Move[numPlayers];

      for(int i = 0; i < numPlayers;i++)
      {
        AlwaysBotMoves[i] = playedRound.getPlayerMove(i);
      }
    }
    else
    {
      for(int i = 0; i < numPlayers;i++)
      {
        if (AlwaysBotMoves[i] != playedRound.getPlayerMove(i))
          AlwaysBotMoves[i] = null;
      }
    }
  }


}
