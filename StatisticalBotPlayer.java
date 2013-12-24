public class StatisticalBotPlayer
{

  public static void main(String[] args){

    int numberOfPlayers = IOUtil.readInt();
    int numberOfRounds = IOUtil.readInt();

    StatisticalBot ab = new StatisticalBot(numberOfPlayers, numberOfRounds);

    for(int i = 0; i < numberOfRounds; i++){
      Move roundMove = ab.getNextMove();
      System.out.println(roundMove);


      // Remember, the constructor for Round will drain stdin.
      Round round = new Round(numberOfPlayers, roundMove);

      ab.finishRound(round);
    }

  }

}
