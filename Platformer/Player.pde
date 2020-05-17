public class Player extends AnimatedSprite {
  int lives;
  boolean onPlatform, inPlace;
  PImage[] standLeft;
  PImage[] standRight;
  PImage[] jumpLeft;
  PImage[] jumpRight;
  
  public Player(PImage img, float scale) {
    super(img, scale);
    lives = 3;
    direction = RIGHT_FACING;
    onPlatform = true;
    inPlace = true;
    standLeft = new PImage[1];
    standLeft[0] = loadImage("mario_stand_left.png");
    standRight = new PImage[1];
    standRight[0] = loadImage("mario.png");
    jumpLeft = new PImage[1];
    jumpLeft[0] = loadImage("mario_jump_left.png");
    jumpRight = new PImage[1];
    jumpRight[0] = loadImage("mario_jump_right.png");
    moveLeft = new PImage[3];
    moveLeft[0] = loadImage("mario_walk4.png");
    moveLeft[1] = loadImage("mario_walk5.png");
    moveLeft[2] = loadImage("mario_walk6.png");
    moveRight = new PImage[3];
    moveRight[0] = loadImage("mario_walk1.png");
    moveRight[1] = loadImage("mario_walk2.png");
    moveRight[2] = loadImage("mario_walk3.png");
    currentImages = standRight;
  }
  
  @Override
  public void updateAnimation() {
    onPlatform = isOnPlatform(this, platforms);
    inPlace = change_x == 0 && change_y == 0;
    super.updateAnimation();
  }
  
  @Override
  public void selectDirection() {
    if (change_x > 0) {
      direction = RIGHT_FACING;
    }
    else if (change_x < 0) {
      direction = LEFT_FACING;
    }
  }
  
  @Override
  public void selectCurrentImages() {
    if (direction == RIGHT_FACING) {
      if (inPlace) {
        currentImages = standRight;
      }
      else if (!onPlatform) {
        currentImages = jumpRight;
      }
      else {
        currentImages = moveRight;
      }
    }
    else if (direction == LEFT_FACING) {
      if (inPlace) {
        currentImages = standLeft;
      }
      else if (!onPlatform) {
        currentImages = jumpLeft;
      }
      else {
        currentImages = moveLeft;
      }
    }
  }
}
    
