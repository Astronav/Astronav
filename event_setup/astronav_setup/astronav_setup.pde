int[] origin_loc = new int[2]; /// stores x,y location of origin in a list
int[] direction_loc = new int[2]; // stores x,y location of second origin that derives location
int[] table_loc = new int[2]; // stores x,y location of table in a list
int clicks; //counts the number of clicks
ArrayList table_list = new ArrayList(); //stores the table location info in an array of x,y coordinates
PVector astronav_vec, table_vec;

int[] img_size = new int[2];
PImage table_layout, star_background;
int circle_size;
int table_number;
int table_distance, table_angle;
PFont futura, italic;
  
Table table_info;

void setup() {
    futura = createFont("Futura-Medium",32);
    italic = createFont("Futura-MediumItalic",32); 
    
    table_info = new Table();
    table_info.addColumn("table_number");
    table_info.addColumn("table_x");
    table_info.addColumn("table_y");
    table_info.addColumn("table_angle");
    table_info.addColumn("table_distance");
  
  
    size(1280, 720);
    star_background = loadImage("data/starry_720p.jpg");
    star_background.resize(1280, 720);
    image(star_background, 0, 0);

    textFont(italic);
    textSize(50);
    fill(#ffffff);
    textAlign(CENTER,BOTTOM);
    text("Welcome to your Astronav setup!", 1280/2, 720/2);
    
    
    textFont(futura);
    textSize(22);
    text("Step 1: Click to place your Astronav compass in the space", 1280/2, 720/2 + 35);
    text("Step 2: Click to place the tables in the space", 1280/2, 720/2 + 70);
    text("Step 3: Press enter to upload the room layout to your Astronav compass", 1280/2, 720/2 + 105);

}

void draw() { //makes the program repeat    
}

void mouseClicked(){
    println(clicks);
    //set background to uploaded room_layout
    if (clicks == 0){    
        table_layout = loadImage("room_layout.jpg");
        table_layout.resize(1280, 720);
        image(table_layout, 0, 0);
        circle_size = table_layout.width/25;
        
        //fill(#000000);
        //textFont(futura);
        //textSize(22);
        //text("Step 1: Click to place your Astronav compass in the space", 1280/2, 720/2 + 40);
    }
    //set origin of astronav
    if (clicks == 1){
      
        //reset image without texxt
        image(table_layout, 0, 0);
 
        //store origin information
        origin_loc[0] = int(mouseX);
        origin_loc[1] = int(mouseY);
         
        println(origin_loc);
         
        //reset map
        image(table_layout, 0, 0);
         
        // drop origin pin on map
        fill(#000000); // black fill
        ellipse(origin_loc[0], origin_loc[1], circle_size, circle_size);
        
        saveFrame("data/origin_layout.jpg");
        
        //tell user to click tables on map
        textFont(futura);
        textSize(16);
        fill(0, 102, 153);
          
    }
   
    // set tables in space 
    else if(clicks >1){  
     //store table location information
        table_number = clicks-1;
     
        table_loc[0]  = mouseX - origin_loc[0];
        table_loc[1] = origin_loc[1] - mouseY;
        //print the value of the x, y coordinate 
        println(table_loc);
        
        // calculate angle and distance
        table_vec = new PVector(-table_loc[0], table_loc[1]);
        table_vec.rotate(3*PI/2);
        table_distance = int(table_vec.mag());
        table_angle = int(table_vec.heading()*(180/PI));
        
        println(table_distance);
        println(table_angle);
        
         
        // drop table pin on map
        fill(#ffffff);
        ellipse(mouseX, mouseY, circle_size, circle_size);
        
        // write table number
        textFont(futura);
        textSize(circle_size*2/3);
        textAlign(CENTER, CENTER);
        fill(0, 102, 153);
        text(table_number,mouseX,mouseY-7); 
        
        //store table_info
        table_list.add(table_loc);
        
        TableRow newRow = table_info.addRow();
        newRow.setInt("table_number", table_number);
        newRow.setInt("table_x", table_loc[0]);
        newRow.setInt("table_y", table_loc[1]);
        newRow.setInt("table_angle", table_angle);
        newRow.setInt("table_distance", table_distance);
     }
    
   //increment the click value by 1
   clicks++; 
  
}    


void keyPressed() {
  if (key == ENTER) {
    println("Table saved");
    save("data/table_layout.jpg");
    
    saveTable(table_info, "data/penn_apps_table_info.csv");
    
    image(star_background, 0, 0);
    fill(#ffffff);
    textAlign(CENTER,BOTTOM);
    text("Astronav setup complete!", 1280/2, 720/2);
    //break;
  }
}