import java.awt.Rectangle;

class Entity {

  final public float ACCELERATION = 0.5;
  final public float DECCELERATION = 0.2;
  final public float MAX_VELOCITY = 5;

  private PVector position;
  private PVector velocity;

  Entity(PVector position) {
    this.position = position;
    velocity = new PVector(0, 0);
  }

  public void update(int[][] map)
  {
    if (velocity.mag() > MAX_VELOCITY)
    {
      velocity.normalize();
      velocity.mult(MAX_VELOCITY);
    }
    
    position.x += velocity.x;
    if(isColliding() != null)
    {
      Rectangle mapRect = isColliding();
     if(velocity.x > 0)
     {
      position.x = mapRect.x - levelGenTest.CELL_SIZE;
     }
     else if(velocity.x < 0)
     {
       position.x = mapRect.x + levelGenTest.CELL_SIZE;
     }
    }

    position.y += velocity.y;
    if(isColliding() != null)
    {
      Rectangle mapRect = isColliding();
     if(velocity.y > 0)
     {
      position.y = mapRect.y - levelGenTest.CELL_SIZE;
     }
     else if(velocity.y < 0)
     {
       position.y = mapRect.y + levelGenTest.CELL_SIZE;
     }
    }
  }
  
  public Rectangle isColliding()
  {
    int cellSize = levelGenTest.CELL_SIZE;
    Rectangle playerRect = new Rectangle(floor(position.x), floor(position.y), cellSize, cellSize);

    for (int x = 0; x < levelGenTest.MAP_WIDTH; x++) {
      for (int y = 0; y < levelGenTest.MAP_HEIGHT; y++) {
        Rectangle mapRect = new Rectangle(x * cellSize, y * cellSize, cellSize, cellSize);
        if(map[x][y] == CELL_WALL && playerRect.intersects(mapRect))
        {
          return mapRect;
        }
      }
    } 
    return null;
  }

  public PVector getPosition()
  {
    return position;
  }

  public float getX() {
    return position.x;
  }

  public float getY() {
    return position.y;
  }

  public PVector getVelocity()
  {
    return velocity;
  }

  public float getVelX()
  {
    return velocity.x;
  }

  public float getVelY()
  {
    return velocity.y;
  }

  public void setPosition(PVector position)
  {
    this.position = position;
  }

  public void setX(int x) {
    position.x = x;
  }

  public void setY(int y) {
    position.y = y;
  }

  public void setVelocity(PVector velocity)
  {
    this.velocity = velocity;
  }

  public void setVelX(float velX)
  {
    velocity.x = velX;
  }

  public void setVelY(float velY)
  {
    velocity.y = velY;
  }
}


/*

 if (key_UP) {
 player.setVelY(player.getVelY() - player.ACCELERATION);
 }
 if (key_Down) {
 player.setVelY(player.getVelY() + player.ACCELERATION);
 }
 if (key_Left) {
 player.setVelX(player.getVelX() - player.ACCELERATION);
 }
 if (key_Right) {
 player.setVelX(player.getVelX() + player.ACCELERATION);
 }
 
 */
