public class GameHistory
{
  private Move[][] history;
  private int currentRound = 0;

  public GameHistory(int numOfPlayers, int numRounds)
  {
    history = new Move[numOfPlayers][numRounds];
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
    currentRound++;
  }
}
