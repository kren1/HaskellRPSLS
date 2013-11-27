import java.util.Random;

public class RandomBot {

  private final Random random = new Random();

  public Move getNextMove() {
    return Move.values()[random.nextInt(Move.values().length)];
  }

  public void finishRound(Round playedRound) {
    // Nothing needed here
  }

}
