// David Solís
// 18 Dic 15
//
// Conway's Game of Life in Processing
// based on the game of life demo at http://ephexi.com/noc/gameoflife2/
//
// r to randomly initialize
// p to pause
// g to go
// s to single sTep
// c to clear 
// click/drag to modify the board
//


int cellsize = 20;
int COLS, ROWS;
//game of life board
int[][] old_board, new_board, colors;
int bGo = 65535;
int bgColor = 0;
PFont font24;
String outString; 
int fade = 0;
int last = 0;
int iteration = 0;
PImage img;
PGraphics pg;
boolean paused = false;

void setup()
{
  size(1600, 800);
  pg = createGraphics(1600, 800);

  smooth();
  //initialize rows, columns and set-up arrays
  COLS = width/cellsize;
  ROWS = height/cellsize;
  old_board = new int[COLS][ROWS];
  new_board = new int[COLS][ROWS];
  colorMode(RGB,255,255,255,255);
  img = loadImage("back.jpg");
  //background(0, 165, 180);
  //call function to fill array with random values 0 or 1
  print(pg);
  
  initBoard(false);
  frameRate(15);
}

void draw()
{ 
   if (keyPressed) {
    if (key == 'p' || key == 'P') {
      paused = !paused;
    }
  } 
  
  pg.beginDraw();

  if ( !paused ) {
    
    pg.loadPixels();
    for (int i = 0; i < pg.pixels.length; ++i) {
      
      color argb = pg.pixels[i];
      int a = (argb >> 24) & 0xFF;
      int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
      int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
      int b = argb & 0xFF;          // Faster way of getting blue(argb)
  
    
      if ( a > 0 ) {
       
        int na = a - (a == 255 ? 50 : 20);
        pg.pixels[i] = color(r,g,b, na);
        /*
        argb = pg.pixels[i];
        a = (argb >> 24) & 0xFF;
        print(i+" "+a);
        print("\n");
        */
  
      }
    } 
    
    color argb = pg.pixels[0];
    int a = (argb >> 24) & 0xFF;
    int r = (argb >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (argb >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = argb & 0xFF;          // Faster way of getting blue(argb)

  
    pg.updatePixels(); 
  

    check(); 
    iteration++; 
    bGo--;
  }
 
  render();

  
  pg.endDraw();
  
  background(img);
  image(pg, 0,0);
}

void grid() {
  /*
  for (int a=0; a<=COLS; a++) {
    for (int b=0; b<=ROWS; b++) {
      stroke(45);
      noFill();
      rectMode(CENTER);
      rect(a*cellsize, b*cellsize, cellsize, cellsize);    
    }
  }
  */
 
}

void check() {
  //loop through every spot in our 2D array and check spots neighbors
  for (int x = 0; x < COLS;x++) {
    for (int y = 0; y < ROWS;y++) {
      int nb = 0;
      //Note the use of mod ("%") below to ensure that cells on the edges have "wrap-around" neighbors
      
      //above row
      if (old_board[(x+COLS-1) % COLS ][(y+ROWS-1) % ROWS ] == 1) { nb++; }
      if (old_board[ x                ][(y+ROWS-1) % ROWS ] == 1) { nb++; }
      if (old_board[(x+1)      % COLS ][(y+ROWS-1) % ROWS ] == 1) { nb++; }
      
      //middle row
      if (old_board[(x+COLS-1) % COLS ][ y                ] == 1) { nb++; }
      if (old_board[(x+1)      % COLS ][ y                ] == 1) { nb++; }
      
      //bottom row
      if (old_board[(x+COLS-1) % COLS ][(y+1)      % ROWS ] == 1) { nb++; }
      if (old_board[ x                ][(y+1)      % ROWS ] == 1) { nb++; }
      if (old_board[(x+1)      % COLS ][(y+1)      % ROWS ] == 1) { nb++; }
       
    //RULES OF "LIFE" HERE
    if      ((old_board[x][y] == 1) && (nb <  2)) { new_board[x][y] = 0; }   
    else if ((old_board[x][y] == 1) && (nb >  3)) { new_board[x][y] = 0; }    
    else if ((old_board[x][y] == 0) && (nb == 3)) { new_board[x][y] = 1; }    
    else                                          { new_board[x][y] = old_board[x][y]; }
    }
  } 
  
  int[][] tmp = old_board;
  old_board = new_board;
  new_board = tmp;  
}

void render() 
{
  //RENDER game of life based on "new_board" values
  for ( int i = 0; i < COLS;i++) 
  {
    for ( int j = 0; j < ROWS;j++) 
    {
      if ((new_board[i][j] == 1)) 
      {
        pg.fill(255,50);
        pg.stroke(255, 180);
        pg.rect(i*cellsize+3,j*cellsize+3,cellsize-8,cellsize-8);
        
        pg.fill(255,0);
        pg.stroke(255, 200);
        pg.rect(i*cellsize,j*cellsize,cellsize-2,cellsize-2);
        
       
      }
    }
  }  //swap old and new game of life boards
}

//init board with random "alive" squares
void initBoard(boolean bClear) 
{
 
  //pg.background(bgColor);
  for (int i =0;i < COLS;i++) 
  {
    for (int j =0;j < ROWS;j++) 
    {
      if (random(5) <= 1.5 && !bClear) 
      {
        old_board[i][j] = 1;
        new_board[i][j] = 1;
      } 
      else 
      {
        old_board[i][j] = 0;
        new_board[i][j] = 0;
      }
    }
  }
}