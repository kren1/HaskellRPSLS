import java.util.Arrays;

public class Round
{
    private Move[] moves;
    private int numOfPlayers;
    
    public Round(int numberOfPlayers, Move ourPlayerMove)
    {
        numberOfPlayers = numberOfPlayers;
        moves = new Move[numberOfPlayers];
        for(int i = 0; i < numberOfPlayers - 1;i++)
        {
            moves[i] = Move.readMove(IOUtil.readString());
        }
        moves[numberOfPlayers - 1] = ourPlayerMove;
    } 
    public int getNumberOfPlayers()
    {
        return numOfPlayers;
    }
    public Move getPlayerMove(int playerIndex)
    {
        return moves[playerIndex];
    }
    public int[] getResult()
    {
        int[] result = new int[numOfPlayers];

        for(int i = 0; i < moves.length; i++)
        {
            for(int j = 0; i < moves.length; i++)
            {
                if( i != j && getPlayerMove(i).beats(getPlayerMove(j)))
                {
                        result[i]++;
                }
            }
        }

        return result;
    }

    public boolean similar(Round otherRound)
    {
        if(numOfPlayers != otherRound.getNumberOfPlayers()) return false;

        int[] moveFrequncyHere = new int[5];
        int[] moveFrequncy= new int[5];

        for(int i = 0; i < numOfPlayers; i++)
        {
            switch(this.getPlayerMove(i))
            {
                case ROCK: moveFrequncyHere[0]++;
                case PAPER: moveFrequncyHere[1]++;
                case SCISSORS: moveFrequncyHere[2]++;
                case LIZARD: moveFrequncyHere[3]++;
                case SPOCK: moveFrequncyHere[4]++;
            }  
            switch(this.getPlayerMove(i))
            {
                case ROCK: moveFrequncy[0]++;
                case PAPER: moveFrequncy[1]++;
                case SCISSORS: moveFrequncy[2]++;
                case LIZARD: moveFrequncy[3]++;
                case SPOCK: moveFrequncy[4]++;
            } 
        }

        return Arrays.equals(moveFrequncyHere , moveFrequncy);

    }
    public static int value(Move m1 , Move m2)
    {
      if(m1 == m2) return 0;
      else if(m1.beats(m2)) return 1;
      else return -1;
    }
}
