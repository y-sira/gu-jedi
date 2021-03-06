final class ParticleFilterYellow extends AbstractParticleFilter {
  public ParticleFilterYellow(int n, double variance, PImage initImage) {
    super(n, variance, initImage);
  }
  
  public ParticleFilterYellow(int n, double variance, int x, int y) {
    super(n, variance, x, y);
  }

  @Override
  protected double likelihood(int x, int y, PImage image) {
    final int width = 4;
    final int height = 4;

    float[] w = new float[width * height];
    int count = 0;
    int index = 0;
    float w_max = 0.0;
    for (int j = y - height / 2; j < y + height / 2; j++) {
      for (int i = x - width / 2; i < x + width / 2; i++) {
        if (isInImage(i, j, image) && isYellow(image.get(i, j))) {
          count++;
          color c = image.get(i, j);
          float d = sqrt(
            pow(35.0 - hue(c), 2)
            + pow(168.0 - saturation(c), 2) 
            + pow(145.0 - brightness(c), 2)
          );

          // sqrt((35 - 255)^2 + 168^2 + 145^2) = 313          
          w[index] = 313.0 - d;
        } else {
          w[index] = 0.0;
        }
        
        index++;
      }
    }
    
    Arrays.sort(w);
    
    if (count == 0) {
      return 0.0001;
    } else {
      return w[width * height - 1];
    }
  }

  private boolean isInImage(int x, int y, PImage image) {
    return (0 <= x && x < (int) image.width && 0 <= y && y < (int) image.height);
  }

  private boolean isYellow(color c) {
    return(
      (hue(c) > 30.0 && hue(c) < 45.0) &&
      (saturation(c) > 80.0 && saturation(c) < 256.0) &&
      (brightness(c) > 125.0 && brightness(c) < 165.0)
    );
  }
}

