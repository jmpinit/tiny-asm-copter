int terrainLength = 88;

int[] heights = new int[terrainLength];
int[] sizes = new int[terrainLength];

void setup()
{
  size(terrainLength*4, 48);
  
  int h = int(random(0, 5));
  
  for(int i=0; i<terrainLength; i++)
  {
    int s = int(random(2, 6));
    
    heights[i] = h;
    sizes[i] = s;
    
    println(".db "+h+", "+s);
    h += int(random(-2, 2));
    if(h>5)
      h = 5;
    if(h<0)
      h = 0;
  }
  
  background(255);
  for(int i=0; i<terrainLength; i++)
  {
    int end = heights[i] + sizes[i];
    
    for(int y=0; y<heights[i]*6; y++)
    {
      point(i, y);
    }
    
    for(int y=end*6; y<height; y++)
    {
      point(i, y);
    }
  }
}

