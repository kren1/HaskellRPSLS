import java.util.Random;

public class AlwaysBot {

  private final Move initMove;

  public AlwaysBot(s:String)
  {
    initMove = Move.readMove(s);
  }

  public Move getNextMove() {
    return initMove;
  }

  public void finishRound(Round playedRound) {
    // Nothing needed here
  }

}
