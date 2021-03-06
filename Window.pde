class Window implements CompletionCallback, GuiCallback {

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
	            ball.updateLocation(gui.getInfectionMovementReductionPercentage(), gui.getMovementPercentage(), gui.getSuperSpreaderPercentage());
	            ball.checkBoundaryCollision();
	            ball.checkCollision();
	        }
	    }
	    stroke(Constants.Color.BLACK);
        line(0, Constants.View.TOP_LINE_POS, Constants.View.SCREEN_WIDTH, Constants.View.TOP_LINE_POS);
        line(0, Constants.View.BOTTOM_LINE_POS, Constants.View.SCREEN_WIDTH, Constants.View.BOTTOM_LINE_POS);
    	updateCountText();
        chart.display(healthyCount, infectedCount, recoveredCount, simulationComplete);
        handleResetOverlay();
	}

	// Create visual components

	ArrayList<Ball> createBalls() {
	    ArrayList<Ball> balls = new ArrayList<Ball>();
	    balls.add(new Ball(random(Constants.View.SCREEN_WIDTH), random(Constants.View.TOP_LINE_POS, Constants.View.BOTTOM_LINE_POS), ballCount));
	    while(balls.size() < ballCount) {
	        Ball newBall = new Ball(random(Constants.View.SCREEN_WIDTH), random(Constants.View.TOP_LINE_POS, Constants.View.BOTTOM_LINE_POS), ballCount);
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
			rect(0, Constants.View.TOP_LINE_POS, Constants.View.SCREEN_WIDTH, Constants.View.BOTTOM_LINE_POS - Constants.View.TOP_LINE_POS);
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
	    fill(Constants.Color.COVID_GREEN);
	    textSize(25);
	    text("Healthy: " + healthyCount, Constants.Gui.STANDARD_PADDING, 27);
	    fill(Constants.Color.COVID_RED);
	    textSize(25);
	    text("Infected: " + infectedCount, Constants.Gui.STANDARD_PADDING, 57);
	    fill(Constants.Color.COVID_PURPLE);
	    textSize(25);
	    text("Recovered: " + recoveredCount, Constants.Gui.STANDARD_PADDING, 87);
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

	void startButtonTapped() {
		resetView();
		start();
	}

	void resetButtonTapped() {
		simulationComplete = true;
		resetView();
	}

}
