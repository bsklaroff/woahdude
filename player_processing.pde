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
  int num = 3;
  

  Visual(FFT fftTemp, AudioPlayer trackTemp) {
    fft = fftTemp;
    offset = height/2;
    decay = new float[fft.specSize()];
    fft.window(FFT.HAMMING);
    t = trackTemp;
    type = 2;
  }

  void toggle(int i) {
    type = (type + i) % num;
  }

  void visualize()
  {
    fft.forward(t.mix);
    c+= 0.001;  
    pushMatrix();  

    if (type == 0) {
      visual1();
      init1();
    } 
    else if (type == 1) {
      visual2();
      init2();
    } 
    else if (type == 2) {
      visual3();
      init3();
    }

    popMatrix();
  }

  void init1() {
    bandSize = 25;
    strokeWeight(10);
  }

  void visual1() {
    background(128*sin(c)+127);
    stroke(255);
    translate(0, -offset);
    for (int i = 0; i < fft.specSize(); i++) {
      decay[i] = decay[i] * 0.9 + fft.getBand(i);
      pushMatrix();
      translate(0, 0, fft.getBand(i)*25);
      stroke(128*sin(i+c)+127, 128*sin(i+PI/2+c)+127, 128*cos(i-c)+127); 
      line(i, height - decay[i], i, height + decay[i]);
      popMatrix();
    }
  }

  void init2() {
    bandSize = 25;
    strokeWeight(10);
  }

  void visual2() {
    background(0);
    stroke(255);
    translate(0, -offset);
    for (int i = 0; i < fft.specSize(); i++) {
      decay[i] = decay[i] * 0.95 + fft.getBand(i);
      stroke(128*sin(i+10*c)+127, 128*sin(i+PI/2+10*c)+127, 128*cos(i-10*c)+127, 64); 
      pushMatrix();
      translate(0, 0, fft.getBand(i)*25);
      ellipse(width/2*sin(i-c)+width/2 + decay[i], height/2*cos(i-c)+height/2 + decay[i], decay[i]/10, decay[i]/10);
      ellipse(-width/2*sin(i-c)+width/2 - decay[i], height/2*cos(i-c)+height/2 + decay[i], decay[i]/10, decay[i]/10);
      ellipse(-width/2*sin(i-c)+width/2 - decay[i], -height/2*cos(i-c)+height/2 - decay[i], decay[i]/10, decay[i]/10);
      ellipse(width/2*sin(i-c)+width/2 + decay[i], -height/2*cos(i-c)+height/2 - decay[i], decay[i]/10, decay[i]/10);
      popMatrix();
    }
  }

  void init3() {
    noStroke();
  }

  void visual3() {
    background(0);
    stroke(255);
    for (int i = 0; i < fft.specSize(); i++) {
      decay[i] = decay[i] * 0.9 + fft.getBand(i);
      pushMatrix();
      translate((width/3+decay[i])*cos(c*50+i), (height/3+decay[i])*sin(c*50+i), fft.getBand(i)*0.5 - i*2);
      fill(128*sin(i+c*5)+127, 128*sin(i+PI/2+c*5)+127, 128*cos(i-c*5)+127, random(256));
      stroke(128*sin(i+c*5)+127, 128*sin(i+PI/2+c*5)+127, 128*cos(i-c*5)+127, random(256));
      if(i % 2 == 0)
        rect(width/2-decay[i]/2, height/2-decay[i]/2, decay[i], decay[i]);
      else
        rect(width/2, height/2, decay[i], decay[i]);      
      popMatrix();
    }
  }
  
  void init4() {
    
  }
  
  void visual4() {
    background(0);
    stroke(255);
    for (int i = 0; i < fft.specSize(); i++) {
      decay[i] = decay[i] * 0.9 + fft.getBand(i);
      pushMatrix();
      translate((width/3+decay[i])*cos(c*50+i), (height/3+decay[i])*sin(c*50+i), fft.getBand(i)*0.5 - i*2);
      fill(128*sin(i+c*5)+127, 128*sin(i+PI/2+c*5)+127, 128*cos(i-c*5)+127, random(256));
      stroke(128*sin(i+c*5)+127, 128*sin(i+PI/2+c*5)+127, 128*cos(i-c*5)+127, random(256));
      if(i % 2 == 0)
        rect(width/2-decay[i]/2, height/2-decay[i]/2, decay[i], decay[i]);
      else
        rect(width/2, height/2, decay[i], decay[i]);      
      popMatrix();
    }    
  }
}

