public class MoveTests {

  public static void main(String[] args) {
    System.out.println("running tests...");
    testBeats();
    System.out.println("...done");
  }

  private static void testBeats() {

    final Move rock = Move.ROCK;
    final Move paper = Move.PAPER;
    final Move scissors = Move.SCISSORS;
    final Move lizard = Move.LIZARD;
    final Move spock = Move.SPOCK;

    assert ! rock.beats(rock);
    assert ! rock.beats(paper);
    assert rock.beats(scissors);
    assert rock.beats(lizard);
    assert ! rock.beats(spock);

    assert paper.beats(rock);
    assert ! paper.beats(paper);
    assert ! paper.beats(scissors);
    assert ! paper.beats(lizard);
    assert paper.beats(spock);

    assert ! scissors.beats(rock);
    assert scissors.beats(paper);
    assert ! scissors.beats(scissors);
    assert scissors.beats(lizard);
    assert ! scissors.beats(spock);

    assert ! lizard.beats(rock);
    assert lizard.beats(paper);
    assert ! lizard.beats(scissors);
    assert ! lizard.beats(lizard);
    assert lizard.beats(spock);

    assert spock.beats(rock);
    assert ! spock.beats(paper);
    assert spock.beats(scissors);
    assert ! spock.beats(lizard);
    assert ! spock.beats(spock);
  }
}
