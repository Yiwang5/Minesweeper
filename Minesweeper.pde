import de.bezier.guido.*;
public final static int NUM_ROWS = 12;
public final static int NUM_COLS = 12;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList<MSButton> mines = new ArrayList<MSButton>();
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r+=1){
      for(int c = 0; c < NUM_COLS; c+=1){
          buttons[r][c] = new MSButton(r,c);
      }
    }
    setMines();
    background( 0 );

}
public void setMines()
{
 for (int i = 0; i < 11; i++){ //adjust for number of mines
 int r  = (int) (Math.random() * NUM_ROWS);
 int c  = (int) (Math.random() * NUM_COLS);
 if (!mines.contains(buttons[r][c])) {
   mines.add(buttons[r][c]);
   }
 }
 
}


public void revealAllMines() {
    for (MSButton mine : mines) {
        mine.revealMine();
    }
    displayLosingMessage();
}

public void draw ()
{
    if(isWon() == true){
    }
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked) {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    square(0,0,400);
    fill(255);
    fill(0);
    textSize(32);
    text("You Lose!", width / 2, height / 2);
}

public void displayWinningMessage()
{  
    square(0,0,400);
    fill(255);
    fill(0);
    textSize(32);
    text("You Win!", width / 2, height / 2);
    
}
public boolean isValid(int r, int c)
{
  if (r < NUM_ROWS && c < NUM_COLS && r >= 0 && c >= 0){
    return true;
  }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int r = -1; r <= 1; r++) {
        for (int c = -1; c <= 1; c++) {
            if (isValid(row + r, col + c) && mines.contains(buttons[row + r][col + c])) {
                numMines++;
            }
        }
    }
    return numMines;
}
public class MSButton
{
private int myRow, myCol;
private float x,y, width, height;
private boolean clicked, flagged;
private String myLabel;
private boolean isMineRevealed = false;

public MSButton ( int row, int col )
{
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
}

// called by manager
public void mousePressed () 
{
    if (flagged) return;
    clicked = true;
    

    if (mouseButton == RIGHT) {
        flagged = !flagged;
        if (!flagged) clicked = false;
     }
     else if (mines.contains(this)) {
             setLabel("lose"); 
             revealAllMines();
     }
     else {
        int mineCount = countMines(myRow, myCol);
        if (mineCount > 0) {
            setLabel(mineCount);
        } else {
            for (int dr = -1; dr <= 1; dr++) {
                for (int dc = -1; dc <= 1; dc++) {
                    int newRow = myRow + dr;
                    int newCol = myCol + dc;
                    if (isValid(newRow, newCol) && !buttons[newRow][newCol].clicked) {
                        buttons[newRow][newCol].mousePressed();
                    }
                }
            }
        }
        if (isWon()) {
            setLabel("win");
            noLoop();
        }
    }
}

 public void revealMine() {
        isMineRevealed = true;
    }
    
public void draw () 
{    
    if (flagged)
        fill(0);
    else if( clicked && mines.contains(this) ) 
         fill(255,0,0);
    else if(clicked)
        fill( 200 );
    else 
        fill( 100 );
    
     if (isMineRevealed) {
            fill(255, 0, 0); 
        }
        
    rect(x, y, width, height);
    fill(0);
    textSize(16);
    text(myLabel,x+width/2,y+height/2);
}
public void setLabel(String newLabel)
{
    myLabel = newLabel;
}
public void setLabel(int newLabel)
{
    myLabel = ""+ newLabel;
}
public boolean isFlagged()
{
    return flagged;
}
}
