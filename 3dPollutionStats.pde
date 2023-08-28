import peasy.*;
PeasyCam cam;
Table table;
float angle = 0.01;
float radius = 300;
static final PVector X_AXIS = new PVector(1, 0, 0);
PImage earth;
PShape globe;

void setup() {
   size(1000, 800, P3D);
   frameRate(100);
   float dist = constrain(3 * radius - width, 3 * radius, 3 * radius);
   cam = new PeasyCam(this, dist);
    
   earth = loadImage("earth.jpg");
   table = loadTable("dataPointscontinents.csv", "header");
   noStroke(); 
   globe = createShape(SPHERE, radius);
   globe.setTexture(earth);
}

void draw() {
   globe();
}

void globe() {
    background(40);
   //translate(width/2, height/2);
   rotateY(angle);
   angle += 0.006;
   //lights();
   fill(200);
   noStroke();
   texture(earth);
   //sphere(radius);
   shape(globe, 0, 0);

  // Print out table data

  for(TableRow row: table.rows()) {
    float lat = row.getFloat("Latitude");
    float longi = row.getFloat("Longitude");
    float airQuality = row.getFloat("AirQuality");
    float waterPollution = row.getFloat("WaterPollution");
   
    
    //Create spherical coordinates

    float latitudeAngle = radians(lat) + PI/2;
    float longitudeAngle = radians(-longi) + PI;
  
    float x = radius * sin(latitudeAngle) * cos(longitudeAngle);
    float y = radius * cos(latitudeAngle); 
    float z = radius * sin(latitudeAngle) * sin(longitudeAngle);
        
    PVector dir = new PVector(x, y, z);
    float angleBetween = PVector.angleBetween(X_AXIS, dir);
    PVector rotAxis = X_AXIS.cross(dir);
    
    pushMatrix();
    translate(x, y, z);
    rotate(angleBetween, rotAxis.x, rotAxis.y, rotAxis.z);
    box(waterPollution, 5, 5);
    popMatrix();
  
    cam.beginHUD();
    textSize(20);
    fill(165, 42, 42);
    text("Red: Air Quality between 0-33", width - 300, 50);
    fill(255, 191, 0);
    text("Yellow: Air Quality between 33-66", width - 300, 70);
    fill(2, 200, 32);
    text("Green: Air Quality between 66-100", width - 300, 90);

    fill(255);
    text("Height represents level of water pollution", width - 375, 750);
    text("The higher the box, the more polluted the water is", width - 430, 770);

    cam.endHUD();

    if(airQuality < 33) {
      fill(165, 42, 42, 200);
    }
    else if(airQuality < 66 && airQuality > 33) {
      fill(255, 191, 0, 200);
    }
    else {
      fill(0, 128, 0, 200);
    }
   // println(lat, longi, airQuality, waterPollution);
  }
  
}


//void mouseDragged()
//{
//radius += mouseX - pmouseX;
//}

//void keyPressed() {
//  if (keyCode == RIGHT) {
//    angle = angle + 0.5;
//  }
//  else if (keyCode == LEFT) {
//    angle = angle - 0.5;
//  }
//  if (angle >= 2*PI) angle = 0;
//}

//void keyReleased() {
//  //
//}
