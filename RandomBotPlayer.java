
public class RandomBotPlayer {

  public static void main(String[] args){

    int numberOfPlayers = IOUtil.readInt();
    int numberOfRounds = IOUtil.readInt();

    RandomBot rb = new RandomBot();

    for(int i = 0; i < numberOfRounds; i++){
      Move roundMove = rb.getNextMove();
      System.out.println(roundMove);


      // Remember, the constructor for Round will drain stdin.
      Round round = new Round(numberOfPlayers, roundMove);

      rb.finishRound(round);
    }

  }

}
