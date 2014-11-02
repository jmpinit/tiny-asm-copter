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

/*
Copyright (c) 2011 Owen Trueblood

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
