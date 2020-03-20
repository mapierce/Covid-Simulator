import controlP5.*;

class Window implements CompletionCallback {

	final float BALL_COUNT = 400;
	final int LINE_POS = 100;

	private PApplet applet;
	private ControlP5 cp5;
	private controlP5.Button resetButton;
	private int healthyCount;
	private int recoveredCount;
	private int infectedCount;
	private boolean simulationComplete;
	private Chart chart;
	private ArrayList<Ball> balls;
	private SimulationTimer timer = new SimulationTimer();

	Window(PApplet applet) {
		this.applet = applet;
		this.cp5 = new ControlP5(applet);
	}

	void setup() {
		resetButton = cp5.addButton("reset")
			.setValue(1)
			.setPosition((SCREEN_WIDTH / 2) - 50, SCREEN_HEIGHT / 2)
			.setSize(100, 40).onPress(new CallbackListener() {
		    	public void controlEvent(CallbackEvent event) {
		    		start();
		    	}
		    });
	}

	void start() {
		simulationComplete = false;
		balls = createBalls();
	    chart = new Chart((int)BALL_COUNT, FRAME_RATE, this);
	}

	void drawWindow() {
        for (Ball ball : balls) {
            ball.display();
            ball.updateLocation();
            ball.checkBoundaryCollision();
            ball.checkCollision();
        }
        stroke(0);
        line(0, LINE_POS, width, LINE_POS);
        updateCountText();
        chart.display(healthyCount, infectedCount, recoveredCount);
        handleResetOverlay();
        // timer.updateWithCounts(healthyCount, infectedCount, recoveredCount); - Call to time the simulation
	}

	// Create visual components

	ArrayList<Ball> createBalls() {
	    ArrayList<Ball> balls = new ArrayList<Ball>();
	    balls.add(new Ball(random(SCREEN_WIDTH), random(LINE_POS, SCREEN_HEIGHT)));
	    while(balls.size() < BALL_COUNT) {
	        Ball newBall = new Ball(random(SCREEN_WIDTH), random(LINE_POS, SCREEN_HEIGHT));
	        boolean overlapping = false;
	        for (int j = 0; j < balls.size(); j++) {
	            if (newBall.overlapsWith(balls.get(j))) {
	                overlapping = true;
	                break;
	            }
	        }
	        if (!overlapping) {
	            balls.add(newBall);
	        }
	    }
	    updateBalls(balls);
	    return balls;
	}

	void handleResetOverlay() {
		if (simulationComplete) {
			fill(0, 0, 0, 200);
			rect(0, LINE_POS, SCREEN_WIDTH, SCREEN_HEIGHT - LINE_POS);
			resetButton.show();
		} else {
			resetButton.hide();
		}
	}

	// Utility

	void updateBalls(ArrayList<Ball> balls) {
	    int infectedId = (int)random(BALL_COUNT);
	    for (int i = 0; i < balls.size(); i++) {
	        Ball ball = balls.get(i);
	        ball.update(i,balls);
	        if (i == infectedId) {
	            ball.setHealthStatus(HealthStatus.INFECTED);
	        }
	    }
	}

	void updateCountText() {
	    getCounts();
	    fill(#45D69A);
	    textSize(25);
	    text("Healthy: " + healthyCount, 10, 25);
	    fill(#F45B69);
	    textSize(25);
	    text("Infected: " + infectedCount, 10, 55);
	    fill(#B4ADEA);
	    textSize(25);
	    text("Recovered: " + recoveredCount, 10, 85);
	}

	void getCounts() {
	    int healthy = 0;
	    int infected = 0;
	    int recovered = 0;
	    for (Ball ball : balls) {
	        if (ball.getHealthStatus() == HealthStatus.HEALTHY) {
	            healthy++;
	        } else if (ball.getHealthStatus() == HealthStatus.INFECTED) {
	            infected++;
	        } else if (ball.getHealthStatus() == HealthStatus.RECOVERED) {
	            recovered++;
	        }
	    }
	    healthyCount = healthy;
	    infectedCount = infected;
	    recoveredCount = recovered;
	}

	// CompletionCallback functions

	void simulationComplete() {
		simulationComplete = !simulationComplete;
	}
	
}
