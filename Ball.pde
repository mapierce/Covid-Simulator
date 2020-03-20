class Ball {

    // Constants

    final float RADIUS = 7;
    final float INFECTED_TIME = 9000;
    final float LINE_POSITION = 100;

    // Private variables
    
    private PVector location;
    private PVector velocity = PVector.random2D().mult(1.2);
    private int id;
    private int infectedTimer;
    private HealthStatus healthStatus = HealthStatus.HEALTHY;
    private ArrayList<Ball> otherBalls;
    
    // SETUP

    Ball(float x, float y) {
        this.location = new PVector(x, y);
    }
    
    void update(int id, ArrayList<Ball> otherBalls) {
        this.id = id;
        this.otherBalls = otherBalls;
    }

    // GETTERS & SETTERS

    HealthStatus getHealthStatus() {
        return healthStatus;
    }

    void setHealthStatus(HealthStatus healthStatus) {
        this.healthStatus = healthStatus;
    }
    
    // VISUAL
    
    void display() {
        noStroke();
        checkRecoveryTime();
        fill(getColor());
        circle(location.x,location.y,RADIUS * 2);
    }
    
    void updateLocation() {
        location.add(velocity);
    }
    
    void checkRecoveryTime() {
        int currentTime = millis();
        if (currentTime - infectedTimer > INFECTED_TIME && this.healthStatus == HealthStatus.INFECTED) {
            this.healthStatus = HealthStatus.RECOVERED;
        }
    }
    
    void updateInfected(Ball other) {
        if (healthStatus == HealthStatus.INFECTED && other.healthStatus == HealthStatus.HEALTHY) {
            other.infectedTimer = millis();
            other.healthStatus = HealthStatus.INFECTED;
        }
        if (healthStatus == HealthStatus.HEALTHY && other.healthStatus == HealthStatus.INFECTED) {
            infectedTimer = millis();
            healthStatus = HealthStatus.INFECTED;
        }
    }

    // COLLISION DETECTION
    
    void checkBoundaryCollision() {
        if (location.x > width - RADIUS) {
            location.x = width - RADIUS;
            velocity.x *= -1;
        } else if (location. x < RADIUS) {
            location.x = RADIUS;
            velocity.x *= -1;
        } else if (location.y > height - RADIUS) {
            location.y = height - RADIUS;
            velocity.y *= -1;
        } else if (location.y < LINE_POSITION + RADIUS) {
            location.y = LINE_POSITION + RADIUS;
            velocity.y *= -1;
        }
    }
    
    void checkCollision() {
        for (Ball other : otherBalls) {
            if (other.id == id) { break; }
            float dx = other.location.x - location.x;
            float dy = other.location.y - location.y;
            float dist = sqrt(dx*dx+dy*dy);
            if(dist < RADIUS + other.RADIUS) {
                updatePosition(other,dx,dy);
                updateInfected(other);
            }
        }
    }
    
    void updatePosition(Ball other, float dx, float dy) {
        float angle = atan2(dy, dx);
        float sin = sin(angle);
        float cos = cos(angle);
        
        float x1 = 0;
        float y1 = 0;
        float x2 = dx*cos+dy*sin;
        float y2 = dy*cos-dx*sin;
        
        float vx1 = velocity.x*cos+velocity.y*sin;
        float vy1 = velocity.y*cos-velocity.x*sin;
        float vx2 = other.velocity.x*cos+other.velocity.y*sin;
        float vy2 = other.velocity.y*cos-other.velocity.x*sin;
        
        float vx1final = ((RADIUS-other.RADIUS)*vx1+2*other.RADIUS*vx2)/(RADIUS+other.RADIUS);
        float vx2final = ((other.RADIUS-RADIUS)*vx2+2*RADIUS*vx1)/(RADIUS+other.RADIUS);
        
        vx1 = vx1final;
        vx2 = vx2final;
        
        float absV = abs(vx1)+abs(vx2);
        float overlap = (RADIUS+other.RADIUS)-abs(x1-x2);
        x1 += vx1/absV*overlap;
        x2 += vx2/absV*overlap;
        
        float x1final = x1*cos-y1*sin;
        float y1final = y1*cos+x1*sin;
        float x2final = x2*cos-y2*sin;
        float y2final = y2*cos+x2*sin;
        
        other.location.x = location.x + x2final;
        other.location.y = location.y + y2final;
        
        location.x = location.x + x1final;
        location.y = location.y + y1final;
        
        velocity.x = vx1*cos-vy1*sin;
        velocity.y = vy1*cos+vx1*sin;
        other.velocity.x = vx2*cos-vy2*sin;
        other.velocity.y = vy2*cos+vx2*sin;
    }
    
    // UTILITY
    
    boolean overlapsWith(Ball ball) {
        float distance = dist(ball.location.x, ball.location.y, this.location.x, this.location.y);
        return distance < RADIUS * 2;
    }
    
    color getColor() {
        switch(healthStatus) {
            case HEALTHY: return #45d69a;
            case INFECTED: return #F45B69;
            case RECOVERED: return #B4ADEA;
            default: return #FFFFFF;
        } 
    }
    
}
