import controlP5.*;

class Window implements CompletionCallback {

	final float BALL_COUNT = 400;
	final int TOP_LINE_POS = 100;
	final int BOTTOM_LINE_POS = 700;
	final int RESET_BUTTON_WIDTH = 100;
	final int RESET_BUTTON_HEIGHT = 40;

	private PApplet applet;
	private ControlP5 cp5;
	private controlP5.Button resetButton;
	private Toggle toggle;

	private PFont SFFont_25;
	private PFont SFFont_14;
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
		this.SFFont_25 = loadFont("SFProDisplay-Light-25.vlw");
		this.SFFont_14 = loadFont("SFProDisplay-Light-14.vlw");
	}

	void setup() {
		setupResetButton();
		setupMoveOnInfectedToggle();
	}

	void start() {
		simulationComplete = false;
		balls = createBalls();
	    chart = new Chart((int)BALL_COUNT, FRAME_RATE, this);
	}

	void drawWindow() {
        for (Ball ball : balls) {
            ball.display();
            ball.updateLocation(toggle.getValue() == 1.0);
            ball.checkBoundaryCollision();
            ball.checkCollision();
        }
        stroke(0);
        line(0, TOP_LINE_POS, width, TOP_LINE_POS);
        line(0, BOTTOM_LINE_POS, width, BOTTOM_LINE_POS);
        updateCountText();
        chart.display(healthyCount, infectedCount, recoveredCount);
        handleResetOverlay();
        // timer.updateWithCounts(healthyCount, infectedCount, recoveredCount); - Call to time the simulation
	}

	// GUI

	void setupResetButton() {
		resetButton = cp5.addButton("reset")
			.setValue(1)
			.setFont(SFFont_14)
			.setPosition((SCREEN_WIDTH / 2) - (RESET_BUTTON_WIDTH / 2), SCREEN_HEIGHT / 2)
			.setSize(RESET_BUTTON_WIDTH, RESET_BUTTON_HEIGHT).onPress(new CallbackListener() {
		    	public void controlEvent(CallbackEvent event) {
		    		start();
		    	}
		    });
	}

	void setupMoveOnInfectedToggle() {
		toggle = cp5.addToggle("")
			.setPosition(8, BOTTOM_LINE_POS + 8)
			.setSize(20, 20)
			.setLabel("")
			.setValue(true)
			.setMode(ControlP5.SWITCH)
			.setColorBackground(color(255))
			.setColorForeground(color(#45D69A))
			.setColorActive(#45D69A);
		cp5.addTextlabel("stopMovingInfectedLabel")
			.setText("Stop moving when infected")
			.setPosition(32, BOTTOM_LINE_POS + 12)
			.setColorValue(color(0))
			.setFont(SFFont_14);
	}

	// Create visual components

	ArrayList<Ball> createBalls() {
	    ArrayList<Ball> balls = new ArrayList<Ball>();
	    balls.add(new Ball(random(SCREEN_WIDTH), random(TOP_LINE_POS, BOTTOM_LINE_POS)));
	    while(balls.size() < BALL_COUNT) {
	        Ball newBall = new Ball(random(SCREEN_WIDTH), random(TOP_LINE_POS, BOTTOM_LINE_POS));
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
			rect(0, TOP_LINE_POS, SCREEN_WIDTH, BOTTOM_LINE_POS - TOP_LINE_POS);
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
	        	println("setting infected");
	            ball.setHealthStatus(HealthStatus.INFECTED);
	        }
	    }
	}

	void updateCountText() {
		textFont(SFFont_25);
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
