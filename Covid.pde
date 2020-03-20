final int SCREEN_WIDTH = 1000;
final int SCREEN_HEIGHT = 800;
final int FRAME_RATE = 30;

Window window;

void settings() {
    size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
    frameRate(FRAME_RATE);
    window = new Window(this);
    window.setup();
    window.start();
}

void draw() {
    background(240);
    window.drawWindow();
}
