// Constants

final int SCREEN_WIDTH = 1000;
final int SCREEN_HEIGHT = 800;
final int FRAME_RATE = 30;

// Variables
int healthyCount;
int recoveredCount;
int infectedCount;
ArrayList<Ball> balls;
Chart chart;

Window window;

// To get runtime
int startTime;
boolean countStarted = false;

void settings() {
    size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
    frameRate(FRAME_RATE);
    window = new Window();
    window.start();
}

void draw() {
    background(240);
    window.drawWindow();
}

void getAverageRunTime() {
    if (healthyCount < 400 && recoveredCount == 0 && !countStarted) {
        countStarted = true;
        println("Started");
        startTime = millis();
    }
    if (infectedCount == 0 && countStarted) {
        countStarted = false;
        println("Ended");
        int now = millis();
        println((now-startTime)/1000);
    }
}
