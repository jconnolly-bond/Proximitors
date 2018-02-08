
class SceneBox {  

  PVector pos;
  int size;
  PVector rotation;
  float rotationAngle = 0.001;
  ArrayList<PVector> vertices = new ArrayList<PVector>();
  ArrayList<int[]> planes = new ArrayList<int[]>();
  PVector normal = new PVector();

  SceneBox(PVector p, int s) {
    pos = p;
    size = s;

    // Vertices for cube
    vertices.add(new PVector(pos.x - size, pos.y - size, pos.z - size));    
    vertices.add(new PVector(pos.x + size, pos.y - size, pos.z - size));
    vertices.add(new PVector(pos.x - size, pos.y + size, pos.z - size));    
    vertices.add(new PVector(pos.x + size, pos.y + size, pos.z - size));  

    vertices.add(new PVector(pos.x - size, pos.y - size, pos.z + size));
    vertices.add(new PVector(pos.x + size, pos.y - size, pos.z + size)); 
    vertices.add(new PVector(pos.x - size, pos.y + size, pos.z + size));
    vertices.add(new PVector(pos.x + size, pos.y + size, pos.z + size));

    // Vertices for each plane
    planes.add(new int[]{0, 2, 1});
    planes.add(new int[]{1, 3, 5});
    planes.add(new int[]{2, 6, 3});
    planes.add(new int[]{5, 0, 1});
    planes.add(new int[]{0, 4, 2});
    planes.add(new int[]{4, 5, 6});

    if (checkEquations() != 0.0) {
      println("ERROR IN EQUATIONS");
    } else {
      println("EQUATIONS EVALUATE");
    }
  }

  void show() {

    strokeWeight(2);    
    stroke(color(255, 255, 255, 25));

    // Rotate each vertex
    for (int i = 0; i < vertices.size(); i++) {
      PVector v = vertices.get(i);
      v.set(rotateVectorY(v, rotationAngle));
    }

    // Draw cube
    line(vertices.get(0).x, vertices.get(0).y, vertices.get(0).z, 
      vertices.get(2).x, vertices.get(2).y, vertices.get(2).z);
    line(vertices.get(1).x, vertices.get(1).y, vertices.get(1).z, 
      vertices.get(3).x, vertices.get(3).y, vertices.get(3).z);
    line(vertices.get(4).x, vertices.get(4).y, vertices.get(4).z, 
      vertices.get(6).x, vertices.get(6).y, vertices.get(6).z);
    line(vertices.get(5).x, vertices.get(5).y, vertices.get(5).z, 
      vertices.get(7).x, vertices.get(7).y, vertices.get(7).z);

    for (int i = 0; i < vertices.size(); i++) {
      //text(i, vertices.get(i).x, vertices.get(i).y, vertices.get(i).z); // Overlay text
      if (i % 2 == 0) {
        line(vertices.get(i).x, vertices.get(i).y, vertices.get(i).z, 
          vertices.get(i+1).x, vertices.get(i+1).y, vertices.get(i+1).z);
      }
      if (i < 4) {
        line(vertices.get(i).x, vertices.get(i).y, vertices.get(i).z, 
          vertices.get(i+4).x, vertices.get(i+4).y, vertices.get(i+4).z);
      }
    }    

    // Centre point
    //strokeWeight(5);
    //stroke(color(255, 20, 20));
    //point(pos.x, pos.y, pos.z);

    // Show normals
    //strokeWeight(1);
    //for (int[] plane : planes) {
    //  PVector dir = new PVector();
    //  dir = vertices.get(plane[0]).copy().sub(vertices.get(plane[1]));            
    //  dir = dir.cross(vertices.get(plane[0]).copy().sub(vertices.get(plane[2]))); 
    //  normal = dir.normalize();

    //  PVector dNormal = normal.copy();
    //  dNormal.mult(size);
    //  line(pos.x, pos.y, pos.z, dNormal.x, dNormal.y, dNormal.z);
    //}   

    // Add floor 
    PShape floor = createShape();
    floor.beginShape();
    floor.fill(35);
    floor.noStroke();
    PVector v1 = vertices.get(2).copy();
    floor.vertex(v1.x, v1.y, v1.z);
    PVector v2 = vertices.get(3).copy();
    floor.vertex(v2.x, v2.y, v2.z);
    PVector v3 = vertices.get(7).copy();
    floor.vertex(v3.x, v3.y, v3.z);
    PVector v4 = vertices.get(6).copy();
    floor.vertex(v4.x, v4.y, v4.z);
    floor.endShape(CLOSE);
    shape(floor);
  }

  PVector rotateVectorY(PVector v, float angle) {  
    PVector result = new PVector();
    PVector vCopy = v.copy();
    result.x = vCopy.x * cos(angle) + vCopy.z * sin(angle);
    result.y = vCopy.y;
    result.z = -vCopy.x * sin(angle) + vCopy.z * cos(angle);    

    return result;
  }

  // Check if point is within planes
  boolean satisfiesEquation(PVector point) {
    PVector p = point.copy();    
    for (int[] plane : planes) {
      PVector dir = new PVector();
      dir = vertices.get(plane[0]).copy().sub(vertices.get(plane[1]));            
      dir = dir.cross(vertices.get(plane[0]).copy().sub(vertices.get(plane[2]))); 
      normal = dir.normalize();

      PVector dirToV = new PVector();
      dirToV = vertices.get(plane[0]).copy().sub(vertices.get(plane[2]));   
      dirToV.normalize();
      //println(dirToV.dot(normal)); // Should be 0

      // Equation of a plane
      // d = -(apx + bpy + cpz)
      // ax + by + cz + d = 0

      float d = -(normal.x * vertices.get(plane[0]).x + normal.y * vertices.get(plane[0]).y + normal.z * vertices.get(plane[0]).z);
      float equation = normal.x * p.x + normal.y * p.y + normal.z * p.z + d;

      // Check if on other side of plane
      if (equation > 0)
        return false;
    }

    // Point is on inside side of plane
    return true;
  }

  // Checks if all the equations for the planes are correct
  float checkEquations() {
    float sum = 0;
    for (int[] plane : planes) {
      PVector dir = new PVector();
      dir = vertices.get(plane[0]).copy().sub(vertices.get(plane[1]));            
      dir = dir.cross(vertices.get(plane[0]).copy().sub(vertices.get(plane[2]))); 
      normal = dir.normalize();

      PVector dirToV = new PVector();
      dirToV = vertices.get(plane[0]).copy().sub(vertices.get(plane[2]));   
      dirToV.normalize();
      //println(dirToV.dot(normal)); // Should be 0

      // Equation of a plane
      // d = -(apx + bpy + cpz)
      // ax + by + cz + d = 0

      float d = -(normal.x * vertices.get(plane[0]).x + normal.y * vertices.get(plane[0]).y + normal.z * vertices.get(plane[0]).z);
      float equation = normal.x * vertices.get(plane[1]).x + normal.y * vertices.get(plane[1]).y + normal.z * vertices.get(plane[1]).z + d;
      sum += equation;
    }
    return sum;
  }
}