Window window;

void settings() {
    size(Constants.View.SCREEN_WIDTH, Constants.View.SCREEN_HEIGHT);
}

void setup() {
    frameRate(Constants.View.FRAME_RATE);
    window = new Window(this);
    window.setup();
    window.resetView();
}

void draw() {
    background(240);
    window.drawWindow(mouseX, mouseY);
}