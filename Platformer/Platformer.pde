
//declare global variables
final static float MOVE_SPEED = 5;
final static float SPRITE_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = 0.6;
final static float JUMP_SPEED = 16;

final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;

final static float WIDTH = SPRITE_SIZE * 16;
final static float HEIGHT = SPRITE_SIZE * 12;
final static float GROUND_LEVEL = HEIGHT - SPRITE_SIZE;

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;

int numCoins;
boolean isGameOver;
Player player;
PImage snow, crate, red_brick, brown_brick, gold, spiky, p;
ArrayList<Sprite> platforms;
ArrayList<Sprite> coins;
Enemy enemy;

float view_x;
float view_y;


void setup() {
  size(800, 600);
  imageMode(CENTER);
  p = loadImage("mario.png");
  player = new Player(p, 1.5);
  player.setBottom(GROUND_LEVEL);
  player.center_x = 100;

  platforms = new ArrayList<Sprite>();
  coins = new ArrayList<Sprite>();
  numCoins = 0;
  isGameOver = false;
  
  gold = loadImage("gold_1.png");
  spiky = loadImage("spikeMan_walk1.png");
  red_brick = loadImage("red_brick.png");
  brown_brick = loadImage("brown_brick.png");
  crate = loadImage("crate.png");
  snow = loadImage("snow.png");
  createPlatforms("map.csv");
  
  view_x = 0;
  view_y = 0;
}

void draw() {
  scroll();
  background(255);
  
  //display objects
  displayAll();
  
  //update objects
  if (!isGameOver) {
    updateAll();
    collectCoins();
  }
  
}

void displayAll() {
  for (Sprite s : platforms) {
    s.display();
  }
  for (Sprite c : coins) {
    c.display();
  }
  player.display();
  enemy.display();
  
  fill(255, 0, 0);
  textSize(32);
  text("Coin:" + numCoins, view_x + 50, view_y + 50);
  text("Lives:" + player.lives, view_x + 50, view_y + 100);
  
  if(isGameOver) {
      fill(0, 0, 255);
      text("GAME OVER!", view_x + width / 2 - 100, view_y + height / 2);
      if (player.lives == 0) {
          text("You lose!", view_x + width / 2 - 100, view_y + height / 2 + 50);
      }
      else {
        text("You win!", view_x + width / 2 - 100, view_y + height / 2 + 50);
      }
      text("Press SPACE to restart!", view_x + width / 2 - 100, view_y + height / 2 + 100);
  }
}

void updateAll() {
  player.updateAnimation();
  resolvePlatformCollisions(player, platforms);
  enemy.update();
  enemy.updateAnimation();
  for (Sprite c : coins) {
    ((AnimatedSprite)c).updateAnimation();
  }
  
  collectCoins();
  checkDeath();
}
  
void collectCoins() {
  ArrayList<Sprite> coin_list = checkCollisionList(player, coins);
  if (coin_list.size() > 0) {
    for (Sprite coin : coin_list) {
       numCoins++;
       coins.remove(coin);
    }
  }
  //collect all coins to win
  if (coins.size() == 0) {
    isGameOver = true;
  }
}

void checkDeath() {
  boolean collideEnemy = checkCollision(player, enemy);
  boolean fallOffCliff = player.getBottom() > GROUND_LEVEL;
  if (collideEnemy || fallOffCliff) {
    player.lives--;
    if (player.lives == 0) {
      isGameOver = true;
    }
    else {
      player.center_x = 100;
      player.setBottom(GROUND_LEVEL);
    }
  }
}

void createPlatforms(String filename) {
  String[] lines = loadStrings(filename);
  for (int row = 0; row < lines.length; row++) {
    String[] values = split(lines[row], ",");
    for (int col = 0; col < values.length; col++) {
      if (values[col].equals("1")) {
        Sprite s = new Sprite(red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("2")) {
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("3")) {
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("4")) {
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      } else if (values[col].equals("5")) {
        Coin c = new Coin(gold, SPRITE_SCALE);
        c.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
        c.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        coins.add(c);
      } else if (values[col].equals("6")) {
        float bLeft = col * SPRITE_SIZE;
        float bRight = bLeft + 4 * SPRITE_SIZE;
        enemy = new Enemy(spiky, 50/120.0, bLeft, bRight);
        enemy.center_x = SPRITE_SIZE / 2 + col * SPRITE_SIZE;
        enemy.center_y = SPRITE_SIZE / 2 + row * SPRITE_SIZE;
      }
    }
  }
}

//called whenever a key is pressed
void keyPressed() {
  if (keyCode == RIGHT) {
    player.change_x = MOVE_SPEED;
  } else if (keyCode == LEFT) {
    player.change_x = -MOVE_SPEED;
  } else if (key == 'a' && isOnPlatform(player, platforms)) {
    player.change_y = -JUMP_SPEED;
  }
  else if (isGameOver && key == ' ') {
    setup();
  }
}
void keyReleased() {
  if (keyCode == RIGHT) {
    player.change_x = 0;
  } else if (keyCode == LEFT) {
    player.change_x = 0;
  } 
}

boolean checkCollision(Sprite s1, Sprite s2) {
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getTop() >= s2.getBottom() || s1.getBottom() <= s2.getTop();
  return !(noXOverlap || noYOverlap); 
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list) {
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for (Sprite p : list) {
    if (checkCollision(s, p)){
      collision_list.add(p);
    }
  }
  return collision_list;
}

public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls) {
  s.change_y += GRAVITY;
  s.center_y += s.change_y;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    if (s.change_y > 0) {
      s.setBottom(collided.getTop());
      s.change_y = 0;
    } else if (s.change_y < 0) {
      s.setTop(collided.getBottom());
      s.change_y = 0;
    }
  }
  s.center_x += s.change_x;
  col_list = checkCollisionList(s, walls);
  if (col_list.size() > 0) {
    Sprite collided = col_list.get(0);
    if (s.change_x > 0) {
      s.setRight(collided.getLeft());
      s.change_x = 0;
    } else if (s.change_x < 0) {
      s.setLeft(collided.getRight());
      s.change_x = 0;
    }
  }
}

public boolean isOnPlatform(Sprite s, ArrayList<Sprite> walls){
  s.center_y += 5;
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  s.center_y -= 5;
  return col_list.size() > 0;
}

void scroll(){
  float right_boundary = view_x + width - RIGHT_MARGIN;
  if(player.getRight() > right_boundary){
    view_x += player.getRight() - right_boundary;
  }
  
  float left_boundary = view_x + LEFT_MARGIN;
  if(player.getLeft() < left_boundary){
    view_x -= left_boundary - player.getLeft();
  }
  
  float bottom_boundary = view_y + height - VERTICAL_MARGIN;
  if(player.getBottom() > bottom_boundary){
    view_y += player.getBottom() - bottom_boundary;
  }
  
  float top_boundary = view_y + VERTICAL_MARGIN;
  if(player.getTop() < top_boundary){
    view_y -= top_boundary - player.getTop();
  }
  
  translate(-view_x, -view_y);
}
    
