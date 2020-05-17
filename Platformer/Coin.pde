public class Coin extends AnimatedSprite {
  
  public Coin(PImage img, float scale) {
    super(img, scale);
    standNeutral = new PImage[4];
    standNeutral[0] = loadImage("gold_1.png");
    standNeutral[1] = loadImage("gold_2.png");
    standNeutral[2] = loadImage("gold_3.png");
    standNeutral[3] = loadImage("gold_4.png");
    currentImages = standNeutral;
  }
}
