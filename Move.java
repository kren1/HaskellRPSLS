public enum Move {

  ROCK("@"), PAPER("#"), SCISSORS("8<"), LIZARD("C"), SPOCK("V");

  private String symbol;

  private Move(String symbol) {
    this.symbol = symbol;
  }

  public String toString() {
    return symbol;
  }

  public boolean beats(Move other) {
    assert other != null;

    switch (this) {

    case ROCK:
      return other == LIZARD || other == SCISSORS;

    case PAPER:
      return other == ROCK || other == SPOCK;

    case SCISSORS:
      return other == PAPER || other == LIZARD;

    case LIZARD:
      return other == SPOCK || other == PAPER;

    case SPOCK:
      return other == SCISSORS || other == ROCK;
    }

    return false;

  }

  public static Move readMove(String move){

    if (move.equals("@")) {
      return Move.ROCK;
    } else if (move.equals("#")) {
      return Move.PAPER;
    } else if (move.equals("8<")) {
      return Move.SCISSORS;
    } else if (move.equals("C")) {
      return Move.LIZARD;
    } else if (move.equals("V")) {
      return Move.SPOCK;
    } else {
      return null;
    }

  }

}
