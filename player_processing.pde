import processing.opengl.*;
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AudioPlayer track;
FFT fft;
String windowName;
int offset;
int bandSize;
float c;
float decay[];
Visual visual;

void setup()
{
  size(500, 500, P3D);
  
  minim = new Minim(this);
  
  track = minim.loadFile("song.mp3", 2048);
  track.loop();
  fft = new FFT(track.bufferSize(), track.sampleRate());
  offset = height/2;
  bandSize = 25;
  strokeWeight(10);
  c = 0;
  decay = new float[fft.specSize()];
  fft.window(FFT.HAMMING);
  visual = new Visual(fft, track);
}

void draw()
{
  visual.visualize();
}

void stop()
{
  track.close();
  minim.stop(); 
  super.stop();
}

void keyReleased()
{
  if ( key == 'w' ) 
    visual.toggle(1);      
  if ( key == 'e' ) 
    visual.toggle(2);
}

class Visual {

  Minim minim;
  AudioPlayer t;
  FFT fft;
  String windowName;
  int offset;
  int bandSize;
  float c;
  float decay[];
  AudioPlayer track;
  int type;
  int num = 2;

  Visual(FFT fftTemp, AudioPlayer trackTemp) {
    fft = fftTemp;
    offset = height/2;
    bandSize = 25;
    strokeWeight(10);
    decay = new float[fft.specSize()];
    fft.window(FFT.HAMMING);
    t = trackTemp;
  }
  
  void toggle(int i) {
    type = (type + i) % num; 
  }
  
  void visualize()
  {
    if(type == 0)
      visual1();
    else if(type == 1)
      visual2();
  }
  
  void visual1() {
    background(128*sin(c)+127);
    stroke(255);
    fft.forward(t.mix);
    
    pushMatrix();
    translate(0, -offset);
    for(int i = 0; i < fft.specSize(); i++) {
      decay[i] = decay[i] * 0.9 + fft.getBand(i);
      pushMatrix();
      translate(0,0, fft.getBand(i)*25);
      stroke(128*sin(i+c)+127, 128*sin(i+PI/2+c)+127, 128*cos(i-c)+127); 
      line(i, height - decay[i], i, height + decay[i]);
      popMatrix();
    }
    fill(255);
    popMatrix();
    c+= 0.001;    
  }
  
  void visual2() {
    background();
    stroke(255);
    fft.forward(t.mix);
    
    pushMatrix();
    translate(0, -offset);
    for(int i = 0; i < fft.specSize(); i++) {
      decay[i] = decay[i] * 0.9 + fft.getBand(i);
      stroke(128*sin(i+c)+127, 128*sin(i+PI/2+c)+127, 128*cos(i-c)+127, 64); 
      pushMatrix();
      translate(0,0, fft.getBand(i)*25);
      ellipse(width/2*sin(i-c)+width/2 + decay[i], height/2*cos(i-c)+height/2 + decay[i], decay[i]/10, decay[i]/10);
      ellipse(-width/2*sin(i-c)+width/2 - decay[i], height/2*cos(i-c)+height/2 + decay[i], decay[i]/10, decay[i]/10);
      ellipse(-width/2*sin(i-c)+width/2 - decay[i], -height/2*cos(i-c)+height/2 - decay[i], decay[i]/10, decay[i]/10);
      ellipse(width/2*sin(i-c)+width/2 + decay[i], -height/2*cos(i-c)+height/2 - decay[i], decay[i]/10, decay[i]/10);
      popMatrix();
    }
    fill(255);
    popMatrix();
    c+= 0.001;    
  }
}
