import java.util.Random;

public class ReactiveBot 
{

  private Round lastRound; 
  private int numPlayers;
  private final Random random = new Random();

  public  ReactiveBot(int numPlayers)
  {
      this.numPlayers = numPlayers;
  }
 
  public Move getNextMove() 
  {
     if(lastRound == null)
      return Move.values()[random.nextInt(Move.values().length)];
    
    Move bestMove = null;
    Move currentMove;
    Move playerMove;
    int bestMoveScore    = 0;
    int currentMoveScore = 0;
    for(int i = 0; i < Move.values().length; i++)
    {
      currentMove = Move.values()[i];
      for(int j = 0; j < numPlayers; j++)
      {
        playerMove = lastRound.getPlayerMove(j);
        if(playerMove != null)
        {
          if(currentMove.beats(playerMove))
            currentMoveScore++;
          else if(currentMove != playerMove && !currentMove.beats(playerMove))
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
    lastRound = playedRound;
  }
 /* public Move getNextMove() 
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
      AlwaysBotMoves = new Move[numPlayers - 1];
    }

    for(int i = 0; i < numPlayers - 1;i++)
    {
      AlwaysBotMoves[i] = playedRound.getPlayerMove(i);
    }
  }*/


}
