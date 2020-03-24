import controlP5.*;

class Window implements CompletionCallback, GuiCallback {

	final int TOP_LINE_POS = 100;
	final int RESET_BUTTON_WIDTH = 100;
	final int RESET_BUTTON_HEIGHT = 60;

	private int ballCount;
	private int healthyCount;
	private int recoveredCount;
	private int infectedCount;
	private boolean simulationComplete = true;
	private Chart chart;
	private ArrayList<Ball> balls;
	private PFont SFFont_25;
	private PFont SFFont_14;

	private Gui gui;

	Window(PApplet applet) {
		this.gui = new Gui(applet, this);
		this.SFFont_25 = loadFont("SFProDisplay-Light-25.vlw");
		this.SFFont_14 = loadFont("SFProDisplay-Light-14.vlw");
	}

	void setup() {
		gui.setupGui();
	}

	void resetView() {
		ballCount = gui.getBallCountFromTextField();
		balls = createBalls();
	    chart = new Chart(ballCount, gui.getDurationFromTextField(), this);
	}

	void start() {
		simulationComplete = false;
	}

	void drawWindow(int mouseX, int mouseY) {
		if (!simulationComplete) {
	        for (Ball ball : balls) {
	            ball.display();
	            ball.updateLocation(gui.moveOnInfectedToggleValue());
	            ball.checkBoundaryCollision();
	            ball.checkCollision();
	        }
	    }
	    stroke(0);
        line(0, TOP_LINE_POS, Constants.View.SCREEN_WIDTH, TOP_LINE_POS);
        line(0, Constants.View.BOTTOM_LINE_POS, Constants.View.SCREEN_WIDTH, Constants.View.BOTTOM_LINE_POS);
    	updateCountText();
        chart.display(healthyCount, infectedCount, recoveredCount, simulationComplete);
        handleResetOverlay();
	}

	// Create visual components

	ArrayList<Ball> createBalls() {
	    ArrayList<Ball> balls = new ArrayList<Ball>();
	    balls.add(new Ball(random(Constants.View.SCREEN_WIDTH), random(TOP_LINE_POS, Constants.View.BOTTOM_LINE_POS)));
	    while(balls.size() < ballCount) {
	        Ball newBall = new Ball(random(Constants.View.SCREEN_WIDTH), random(TOP_LINE_POS, Constants.View.BOTTOM_LINE_POS));
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
			rect(0, TOP_LINE_POS, Constants.View.SCREEN_WIDTH, Constants.View.BOTTOM_LINE_POS - TOP_LINE_POS);
			gui.showResetButton(true);
		} else {
			gui.showResetButton(false);
		}
	}

	// Utility

	void updateBalls(ArrayList<Ball> balls) {
	    int infectedId = (int)random(ballCount);
	    for (int i = 0; i < balls.size(); i++) {
	        Ball ball = balls.get(i);
	        ball.update(i,balls);
	        if (i == infectedId) {
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

	// GuiCallback functions

	void resetButtonTapped() {
		resetView();
		start();
	}
	
}
