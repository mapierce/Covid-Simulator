import controlP5.*;

class Gui {

	private GuiCallback delegate;
	private ControlP5 cp5;
	private Button resetButton;
	private Textlabel moveInfectedToggleLabel;
	private Toggle moveInfectedToggle;
	private Textlabel ballCountTextFieldLabel;
	private Textfield ballCountTextField;
	private Textfield secondsInputTextField;
	private PFont SFFont_25;
	private PFont SFFont_14;

	Gui(PApplet applet, GuiCallback delegate) {
		this.cp5 = new ControlP5(applet);
		this.delegate = delegate;
		this.SFFont_25 = loadFont("SFProDisplay-Light-25.vlw");
		this.SFFont_14 = loadFont("SFProDisplay-Light-14.vlw");
	}

	// GUI setup

	void setupGui() {
		setupResetButton();
		setupMoveOnInfectedToggle();
		setupBallCountInput();
		setupTimeInput();
	}

	void setupResetButton() {
		resetButton = cp5.addButton("START")
			.setFont(SFFont_14)
			.setPosition((Constants.View.SCREEN_WIDTH / 2) - (Constants.Gui.RESET_BUTTON_WIDTH / 2), Constants.View.SCREEN_HEIGHT / 2)
			.setSize(Constants.Gui.RESET_BUTTON_WIDTH, Constants.Gui.RESET_BUTTON_HEIGHT).onPress(new CallbackListener() {
		    	public void controlEvent(CallbackEvent event) {
		    		delegate.resetButtonTapped();
		    	}
		    });
	}

	void setupMoveOnInfectedToggle() {
		moveInfectedToggleLabel = cp5.addTextlabel("stopMovingInfectedLabel")
			.setText("Stop moving when infected:")
			.setPosition(Constants.Gui.COL_ONE_LABEL_X, Constants.View.BOTTOM_LINE_POS + Constants.Gui.TOP_LABEL_PADDING)
			.setColorValue(Constants.Color.BLACK)
			.setFont(SFFont_14);
		moveInfectedToggle = cp5.addToggle("infectedToggle")
			.setPosition(Constants.Gui.COL_ONE_CONTROL_X, Constants.View.BOTTOM_LINE_POS + Constants.Gui.TOP_CONTROL_PADDING)
			.setSize(Constants.Gui.INPUT_WIDTH, Constants.Gui.INPUT_HEIGHT)
			.setLabel("")
			.setValue(true)
			.setMode(ControlP5.SWITCH)
			.setColorBackground(color(Constants.Color.WHITE))
			.setColorForeground(Constants.Color.COVID_GREEN)
			.setColorActive(Constants.Color.COVID_GREEN);
	}

	void setupBallCountInput() {
		ballCountTextFieldLabel = cp5.addTextlabel("ballCountLabel")
			.setText("Number of people:")
			.setPosition(Constants.Gui.COL_ONE_LABEL_X, moveInfectedToggleLabel.getPosition()[1] + Constants.Gui.LABEL_SPACING)
			.setColorValue(Constants.Color.BLACK)
			.setFont(SFFont_14);
		ballCountTextField = cp5.addTextfield("ballCountInput")
			.setLabel("")
			.setPosition(Constants.Gui.COL_ONE_CONTROL_X, moveInfectedToggle.getPosition()[1] + Constants.Gui.CONTROL_SPACING)
			.setSize(Constants.Gui.INPUT_WIDTH, Constants.Gui.INPUT_HEIGHT)
			.setFont(SFFont_14)
			.setColorBackground(color(Constants.Color.WHITE))
			.setColor(Constants.Color.BLACK);
		setDefaultBallCount();
	}

	void setupTimeInput() {
		cp5.addTextlabel("secondsInputLabel")
			.setText("Simulation duration (seconds):")
			.setPosition(Constants.Gui.COL_ONE_LABEL_X, ballCountTextFieldLabel.getPosition()[1] + Constants.Gui.LABEL_SPACING)
			.setColorValue(Constants.Color.BLACK)
			.setFont(SFFont_14);
		secondsInputTextField = cp5.addTextfield("secondsInput")
			.setLabel("")
			.setPosition(Constants.Gui.COL_ONE_CONTROL_X, ballCountTextField.getPosition()[1] + Constants.Gui.CONTROL_SPACING)
			.setSize(Constants.Gui.INPUT_WIDTH, Constants.Gui.INPUT_HEIGHT)
			.setFont(SFFont_14)
			.setColorBackground(color(Constants.Color.WHITE))
			.setColor(Constants.Color.BLACK);
		setDefaultDuration();
	}

	// GUI getters & setters

	void showResetButton(boolean show) {
		if (show) {
			resetButton.show();
		} else {
			resetButton.hide();
		}
	}

	boolean moveOnInfectedToggleValue() {
		return (moveInfectedToggle.getValue() == 1.0);
	}

	int getBallCountFromTextField() {
		String ballCountText = ballCountTextField.getText();
		if (Utility.isInteger(ballCountText)) {
			return Integer.parseInt(ballCountText);
		} else {
			setDefaultBallCount();
			return Constants.Simulator.DEFAULT_BALL_COUNT;
		}
	}

	int getDurationFromTextField() {
		String secondsText = secondsInputTextField.getText();
		if (Utility.isInteger(secondsText)) {
			return Integer.parseInt(secondsText);
		} else {
			setDefaultDuration();
			return Constants.Simulator.DEFAULT_TOTAL_SECONDS;
		}
	}

	// Set default values

	void setDefaultBallCount() {
		ballCountTextField.setText(Integer.toString(Constants.Simulator.DEFAULT_BALL_COUNT));
	}

	void setDefaultDuration() {
		secondsInputTextField.setText(Integer.toString(Constants.Simulator.DEFAULT_TOTAL_SECONDS));
	}

}