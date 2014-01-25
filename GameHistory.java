public class GameHistory
{
  private Move[][] history;
  private Round[] roundHistory;
  private int currentRound = 0;
  private int numPlayers;
  private int numRounds;

  public GameHistory(int numOfPlayers, int numRounds)
  {
    history = new Move[numOfPlayers][numRounds];
    roundHistory = new Round[numRounds];
    numPlayers = numOfPlayers;
    this.numRounds = numRounds;
  }
  public int getCurrentRound()
  {
    return currentRound;
  }
  public int getNumOfSimilarRounds()
  {
    int sim = 0;
    for(int i = 0; i < currentRound - 1; i++)
    {
      if(roundHistory[i].similar(roundHistory[currentRound - 1]))
      {
        sim++;
      }
    }
    return sim;
  }
  public int[][] getStats()
  {
    int[][] stats = new int[numPlayers][Move.values().length];
    Round r2;

    for(int i = 0; i < currentRound - 1; i++)
    {
      if(roundHistory[i].similar(roundHistory[currentRound - 1]))
      {
        for(int j = 0; j < numPlayers - 1;j++)
        {
          r2 = roundHistory[i + 1];
          stats[j][r2.getPlayerMove(j).ordinal()]++;
        }
      }
    }
    return stats;
  }
  public double probaliblityPlayerPlaysM(Move m,int player)
  {
    assert player < history.length: "invalid player";

    int moveCounter = 0;
    
    if(currentRound == 0) return 0.2;

    for(int i = 0; i < history[player].length; i++)
    {
      if(history[player][i] == null) break; 
      if(history[player][i] == m) moveCounter++;
    }
  
    return moveCounter / currentRound;
  }
  public void addRound(Round r)
  {
    for(int i = 0; i < history.length; i++)
    {
      history[i][currentRound] = r.getPlayerMove(i);
    }
    roundHistory[currentRound] = r;
    currentRound++;
  }
}
