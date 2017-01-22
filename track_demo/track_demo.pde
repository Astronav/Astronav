/* Name: track_demo.py
# Author: Jono Sanders
# Date: Jan 21 2017
# Description: Astronav code for 7" touch screen on raspberry pi
*/

PImage main_nav, bg, map, nerds, logo, arrow;
PGraphics mask;
PFont futura, italic;

int state=0;
int team_sel;
int start_time;
int size = 100;
int angle=15;

int[] nav_X = {188,296,373,435,420,550,594};  // X coordinates for the tracks
int[] nav_Y = {140,165,225,285,375,415,338};  // X coordinates for the tracks
//int[] nav_Y = new int[7];  // ref declaration

ArrayList<Track> pennapps = new ArrayList<Track>();  //Array of tracks
int cur_track=0;
Project proj1;
Project proj2;
Project proj3;

void setup() {
  size(800, 480); // set up display size
  // Set up track
  pennapps.add(new Track("Education",3)); // Track(String name_in, int count)
  pennapps.add(new Track("Cybersecurity",0)); // Track(String name_in, int count)
  pennapps.add(new Track("Social+Civic",0)); // Track(String name_in, int count)
  pennapps.add(new Track("VR/AR",0)); // Track(String name_in, int count)
  pennapps.add(new Track("Hardware",0)); // Track(String name_in, int count)
  pennapps.add(new Track("Health",0)); // Track(String name_in, int count)
  pennapps.add(new Track("Unlabeled",0)); // Track(String name_in, int count)
  proj1 = new Project("TeamOne", 600, 100, 1); //Project(String name_in, int X, int Y, int table_in)
  proj2 = new Project("TeamTwo", 670, 190, 2);
  proj3 = new Project("TeamThree", 580, 240, 3);
  pennapps.get(cur_track).add_project(proj1);
  pennapps.get(cur_track).add_project(proj2);
  pennapps.get(cur_track).add_project(proj3);
  
  futura = createFont("Futura-Medium",32);
  italic = createFont("Futura-MediumItalic",32);
  bg = loadImage("starry_720p.jpg");
  logo = loadImage("logo_white.png");
  logo.resize(0, 120);
  main_nav = loadImage("main_nav.jpg");
  map = loadImage("tables.jpg");
  nerds = loadImage("nerds.jpg");
  mask=createGraphics(80, 80);//draw the mask object
  mask.beginDraw();
  mask.smooth();//this really does nothing, i wish it did
  mask.background(0);//background color to target
  mask.fill(255);
  mask.ellipse(40, 40, 82, 82);
  mask.endDraw();
  nerds.mask(mask);
  arrow = loadImage("arrow.png");
  start_time = millis();
}

void draw() { 
  //update(mouseX, mouseY); //to have mouseover change colors

  //for buttons
  switch(state)
  {
  case 0: // for Main Menu
    background(0);
    main_menu();
      break;

  case 1: // for Track
    pennapps.get(cur_track).display();
    break;

  case 2: // for Project
    background(0);
    pennapps.get(cur_track).display_team(team_sel);
    break;
  } // end switch statement
}

void mousePressed() {
  if (state < 1) {
    int track_sel = nav_check(mouseX, mouseY);
    if (track_sel > 0) // Returns 0 if no selection
    {
      state = 1;
      cur_track = track_sel-1; // Saves the selected track (indexed at 0)
    }
    else state = 0;
  } else if (state < 2) {  
    int proj_sel = pennapps.get(cur_track).check(mouseX, mouseY);  // Checks if a name is at that X,Y position
    if (proj_sel >0)  // Returns 0 if no name
    {
      state = 2;
      team_sel = proj_sel-1;  // Saves the selected team number (indexed at 0)
    }
    if ((mouseX > 0) && (mouseX < 80)){  // Check if clicks on PennApps back area
      if ((mouseY > 0) && (mouseY < 100))
      state = 0;}
    
  } else {  // **********  Change this to only go back if you click in the top L corner?  ********
    state = 1;
  }
  println("X: ", mouseX, ", Y: ", mouseY);
}

void main_menu()
{
  image(main_nav,0, 0);
    logo.resize(0, 120);
    image(logo, 40, 20);
    textFont(futura);
    textSize(82);
    textAlign(CENTER,CENTER);
    text("Astronav", 400, 60);
    textFont(italic);
    textSize(size);
    text("SELECT A TRACK TO START", 400, 200);
    if (size>32)
      size-=1;
    if ((millis()-start_time) > 2500)
    {
      background(0);
      image(main_nav,0, 0);
      textFont(futura);
      textSize(82);
      textAlign(CENTER,CENTER);
      text("Astronav", 400, 60);
      for (int i =0; i < 6; i++) {  // Print the name of each project
        rectMode(CENTER);
        stroke(0,20); fill(0,20);
        rect(nav_X[0], nav_Y[0],130, 30, 5,5,5,5); //EDUCATION
        rect(nav_X[1], nav_Y[1],150, 30, 5,5,5,5); //CYBERSECURITY
        rect(nav_X[2], nav_Y[2],140, 30, 5,5,5,5); //SOCIAL+CIVIC
        rect(nav_X[3], nav_Y[3],70, 30, 5,5,5,5); //VR/AR
        rect(nav_X[4], nav_Y[4],110, 30, 5,5,5,5); //HARDWARE
        rect(nav_X[5], nav_Y[5],85, 30, 5,5,5,5); //HEALTH
        rect(nav_X[6], nav_Y[6],120, 30, 5,5,5,5); //UNLABELED
        fill(135,206,235); // sky blue, burnt orange (204,85,0)
        textSize(18);
        text("EDUCATION", nav_X[0], nav_Y[0]);
        text("CYBERSECURITY", nav_X[1], nav_Y[1]);
        text("SOCIAL+CIVIC", nav_X[2], nav_Y[2]);
        text("VR/AR", nav_X[3], nav_Y[3]);
        text("HARDWARE", nav_X[4], nav_Y[4]);
        text("HEALTH", nav_X[5], nav_Y[5]);
        text("UNLABELED", nav_X[6], nav_Y[6]);
      }
      image(logo, 40, 20);
      fill(255); // return to white
      rectMode(CORNER);
    }
}

int nav_check(int X, int Y)
  {
    for (int i =0; i < 7; i++)
    {
      boolean inside_x = (X > nav_X[i]-60) && (X < (nav_X[i]+60)); 
      boolean inside_y = (Y < nav_Y[i]+10) && (Y > (nav_Y[i]-10));
      if (inside_x && inside_y) {
        return i+1;
      }
    }
    return 0;
  }

//~~~~~~~ CLASSES DEFINED HERE ~~~~~~~~~~~~~~~~~~~~~~//

class Project {    // This is where projects are created
  String name;
  String description;
  int[] loc = new int[2];  // X, Y coordinates
  int table_num;
  String photo_url;
  int feet;
  int angle;

  Project(String name_in, int X, int Y, int table_in) {  // Constructor
    name = name_in;
    loc[0] = X;
    loc[1] = Y;
    table_num = table_in;
  }

  void set_vars(int dist, int omega)
  {
      feet = dist;
      angle = omega;
  }

  String get_name() {
    return name;
  }

  int get_table() {
    return table_num;
  }

  int get_X() {
    return loc[0];
  }

  int get_Y() {
    return loc[1];
  }
  
  int get_feet(){
    return feet;}
    
    int get_angle(){
      return angle;}
}

class Track {    // This is where various tracks are created (ie Health, VR/AR, Cybersecurity, etc)
  String name;    // name of track
  int project_count;
  ArrayList<Project> proj = new ArrayList<Project>();  //Array of projects

  Track(String name_in, int count) {  //Constructor
    name = name_in;
    project_count = count;
  }

  void add_project(Project new_proj) {
    proj.add(new_proj);
  }

  void display() {    // For showing all the projects in this track
    image(bg, 0, 0);
    logo.resize(0, 80);
    textFont(italic);
    textSize(18);
    text("back", 50, 80); 
    image(logo, 5, 0);
    textFont(futura);
    if (size<36)
      size=64;
    textSize(size);
    text(name, 400, 380);
    text("Hacking", 400, 420);
    if (size>36)
      size-=1;
    else
    {
      for (int i =0; i < project_count; i++) {  // Print the name of each project
        rectMode(CENTER);
        stroke(0,126);
        fill(0,126);
        rect(proj.get(i).get_X(), proj.get(i).get_Y(),100, 30, 5,5,5,5);
        fill(135,206,235); // sky blue, burnt orange (204,85,0)
        textSize(18);
        text(proj.get(i).get_name(), proj.get(i).get_X(), proj.get(i).get_Y());
      }
      fill(255); // return to white
      rectMode(CORNER);
    }
  }

  int check(int X, int Y)
  {
    for (int i =0; i < project_count; i++)
    {
      boolean inside_x = (X > proj.get(i).get_X()-60) && (X < (proj.get(i).get_X()+60)); 
      boolean inside_y = (Y < proj.get(i).get_Y()+10) && (Y > (proj.get(i).get_Y()-10));
      if (inside_x && inside_y) {
        return i+1;
      }
    }
    return 0;
  }
  void display_team(int team_num)  // For showing a specific team's info (state 2)
  {
    image(bg, 0, 0); 
    textFont(futura);
    textSize(24);
    text("Social+Civic", 80, 30);
    text("Hacking", 80, 55);
    textFont(italic);
    textSize(16);
    text("back", 80, 85);
    textFont(futura);
    textSize(62);
    String table = "Table"+Integer.toString(proj.get(team_num).get_table());
    text(table, 330, 50);
    textSize(36);
    textFont(italic);
    text("200 feet", 330, 105);
    image(map, 140, 140);
    image(nerds, 630, 80);
    textSize(36);
    textFont(futura);
    text(proj.get(team_num).get_name(), 670, 200);
    textFont(italic);
    textSize(21);
    text("blah blah blah", 670, 240);
    text(proj.get(team_num).get_name()+" this", 670, 270);
    text("and more stuff", 670, 300);
    //tint(255,126);  // Applies transparency but also seems to make things grey
    translate(120, -150);
    // ******* ADD ANGLE CALCULATION!! *************
    float angle = 180/3.14*atan((float)proj.get(team_num).get_Y()/proj.get(team_num).get_X());
    println("X is: "+proj.get(team_num).get_X()+", Angle is: "+angle);
    rotate(radians(angle));  // rotates 30 degrees
    image(arrow, 220, 160);  // **** NEED TO DETERMINE LOCATION BASED ON ROTATION ******
  }
}