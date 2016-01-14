//individual body variables are modified here
class CelestialBody {
  PVector vel; //velocity
  PVector acl = new PVector(0,0); //acceleration
  PVector pos; //position
  PVector dpos = new PVector(0,0); //change in position to next frame: delta pos
  float mass;
  float radius;
  color col;
  int pathLength = 500;
  ArrayList<PVector> path;

  CelestialBody(PVector ipos, PVector ivel,
                float imass, float iradius, color icol) {
    pos = ipos;
    vel = ivel;
    mass = imass;
    radius = iradius;
    col = icol;
    path = new ArrayList<PVector>();
  }

  void move(float dt, float simSpeed) {
    dt *= simSpeed;
    acl.div((float)1e14);
    vel.add(PVector.mult(acl,dt));
    dpos = PVector.mult(vel, dt).add(PVector.mult(acl,0.5*dt*dt));
    pos.add(dpos);

    path.add(new PVector(pos.x, pos.y));

    if (path.size() > pathLength) {
      path.remove(0);
    }
  }

  void draw(color strokeColor) {
    fill(col);
    stroke(strokeColor);
    ellipse(pos.x, pos.y, radius, radius);
    stroke(col); //Reset color for path drawing
    if (UI.drawPath) {
      for (int i = 1; i < path.size(); i++) {
        PVector p1 = path.get(i);
        PVector p2 = path.get(i-1);
        line(p1.x, p1.y, p2.x, p2.y);
      }
    }
  }
}