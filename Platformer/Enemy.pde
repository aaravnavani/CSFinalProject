public class Enemy extends AnimatedSprite {
  float boundaryLeft, boundaryRight;
  
  public Enemy(PImage img, float scale, float bLeft, float bRight) {
    super(img, scale);
    moveLeft = new PImage[2];
    moveLeft[0] = loadImage("spikeMan_walk3.png");
    moveLeft[1] = loadImage("spikeMan_walk4.png");
    moveRight = new PImage[2];
    moveRight[0] = loadImage("spikeMan_walk1.png");
    moveRight[1] = loadImage("spikeMan_walk2.png");
    currentImages = moveRight;
    direction = RIGHT_FACING;
    boundaryLeft = bLeft;
    boundaryRight = bRight;
    change_x = 2;
  }
  
  void update() {
    super.update();
    if (getLeft() <= boundaryLeft) {
     setLeft(boundaryLeft);
     change_x *= -1;
    }
    else if (getRight() >= boundaryRight) {
     setRight(boundaryRight);
     change_x *= -1;
    }
  }
}
