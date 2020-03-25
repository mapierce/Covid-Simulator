class Chart {
    
    // Constants
    final int X_POS = 175;
    final int Y_POS = Constants.Gui.STANDARD_PADDING;
    final int CHART_HEIGHT = Constants.View.TOP_LINE_POS - (2 * Constants.Gui.STANDARD_PADDING);

    // Private variables
    private CompletionCallback delegate;
    private PShape healthyArea;
    private PShape infectedArea;
    private PShape recoveredArea;
    private ArrayList<Integer> healthyPoints = new ArrayList<Integer>();
    private ArrayList<Integer> infectedPoints = new ArrayList<Integer>();
    private ArrayList<Integer> recoveredPoints = new ArrayList<Integer>();
    private int chartWidth;
    private int totalItemCount;
    private int totalCalls;
    private float xInterval;
    private boolean completed;

    Chart(int totalItemCount, int duration, CompletionCallback delegate) {
        this.delegate = delegate;
        this.chartWidth = Constants.View.SCREEN_WIDTH - (X_POS + Constants.Gui.STANDARD_PADDING);
    	this.totalItemCount = totalItemCount;
    	this.totalCalls = Constants.View.FRAME_RATE * duration;
    	this.xInterval = (float)chartWidth / (float)totalCalls;
        this.completed = false;
    }
    
    void display(int healthyCount, int infectedCount, int recoveredCount, boolean gameOver) {
    	fill(Constants.Color.WHITE);
        rect(X_POS, Y_POS, chartWidth, CHART_HEIGHT);
        if (!gameOver) {
            updateHealthyPoints(healthyCount);
            updateInfectedPoints(infectedCount);
            updateRecoveredPoints(recoveredCount);
        }
        updateHealthyShape();
        updateInfectedShape();
        updateRecoveredShape();
        shape(healthyArea, X_POS, Y_POS);
        shape(infectedArea, X_POS, Y_POS);
        shape(recoveredArea, X_POS, Y_POS);
    }

    void updateHealthyShape() {
    	float xPos = 0;
    	healthyArea = createShape();
        healthyArea.beginShape();
        healthyArea.fill(Constants.Color.COVID_GREEN);
        healthyArea.vertex(0, 0);
        healthyArea.vertex(0, CHART_HEIGHT);
        xPos = xInterval * healthyPoints.size() < chartWidth ? xInterval * healthyPoints.size() : chartWidth;
    	healthyArea.vertex(xPos, CHART_HEIGHT);
        healthyArea.vertex(xPos, 0);
        healthyArea.endShape(CLOSE);
        if (xPos >= chartWidth && !completed) {
            delegate.simulationComplete();
            completed = true;
        }
    }

    void updateInfectedShape() {
        float xPos = 0;
        infectedArea = createShape();
        infectedArea.beginShape();
        infectedArea.fill(Constants.Color.COVID_RED);
        infectedArea.vertex(xPos, CHART_HEIGHT);
        for(Integer point : infectedPoints) {
        	if (xPos < chartWidth) {
        		xPos += xInterval;	
        	}
            float yPos = CHART_HEIGHT - (((float)point.intValue() / totalItemCount) * CHART_HEIGHT);
            infectedArea.vertex((int)xPos, (int)yPos);
        }
        infectedArea.vertex(xPos, CHART_HEIGHT);
        infectedArea.endShape(CLOSE);
    }

    void updateRecoveredShape() {
    	float xPos = 0;
    	recoveredArea = createShape();
        recoveredArea.beginShape();
        recoveredArea.fill(Constants.Color.COVID_PURPLE);
        recoveredArea.vertex(xPos, 0);
        for(Integer point : recoveredPoints) {
        	if (xPos < chartWidth) {
        		xPos += xInterval;	
        	}
        	float yPos = ((float)point.intValue() / totalItemCount) * CHART_HEIGHT;
        	recoveredArea.vertex((int)xPos, (int)yPos);
        }
        recoveredArea.vertex(xPos, 0);
        recoveredArea.endShape(CLOSE);
    }

    void updateHealthyPoints(int healthyCount) {
    	healthyPoints.add(new Integer(healthyCount));
    }

    void updateInfectedPoints(int infectedCount) {
        infectedPoints.add(new Integer(infectedCount));
    }

    void updateRecoveredPoints(int recoveredCount) {
    	recoveredPoints.add(new Integer(recoveredCount));
    }
    
}
