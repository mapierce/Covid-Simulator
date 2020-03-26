import controlP5.*;

class Gui {

	private GuiCallback delegate;
	private ControlP5 cp5;
	private Button startButton;
	private Button resetButton;
	private Textlabel moveInfectedSliderLabel;
	private Slider moveInfectedSlider;
	private Textlabel ballCountTextFieldLabel;
	private Textfield ballCountTextField;
	private Textfield secondsInputTextField;
	private Textlabel generalMovementSliderLabel;
	private Slider generalMovementSlider;
	private Textlabel superSpreaderSliderLabel;
	private Slider superSpreaderSlider;
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
		setupStartButton();
		setupResetButton();
		setupMoveOnInfectedSlider();
		setupBallCountInput();
		setupTimeInput();
		setupGeneralMovementSlider();
		setupSuperSpreaderSlider();
	}

	void setupStartButton() {
		startButton = cp5.addButton("START")
			.setFont(SFFont_14)
			.setPosition((Constants.View.SCREEN_WIDTH / 2) - (Constants.Gui.START_BUTTON_WIDTH / 2), Constants.View.SCREEN_HEIGHT / 2)
			.setSize(Constants.Gui.START_BUTTON_WIDTH, Constants.Gui.START_BUTTON_HEIGHT)
			.onPress(new CallbackListener() {
		    	public void controlEvent(CallbackEvent event) {
		    		delegate.startButtonTapped();
		    	}
		    });
	}

	void setupResetButton() {
		resetButton = cp5.addButton("RESET")
			.setFont(SFFont_14)
			.setPosition((Constants.View.SCREEN_WIDTH - Constants.Gui.RESET_BUTTON_WIDTH - Constants.Gui.STANDARD_PADDING), (Constants.View.BOTTOM_LINE_POS + Constants.Gui.STANDARD_PADDING))
			.setSize(Constants.Gui.RESET_BUTTON_WIDTH, (Constants.View.SCREEN_HEIGHT - Constants.View.BOTTOM_LINE_POS - (2 * Constants.Gui.STANDARD_PADDING)))
			.onPress(new CallbackListener () {
				public void controlEvent(CallbackEvent event) {
					delegate.resetButtonTapped();
				}
			});
	}

	void setupMoveOnInfectedSlider() {
		moveInfectedSliderLabel = cp5.addTextlabel("stopMovingInfectedLabel")
			.setText("Slow infected movement by %:")
			.setPosition(Constants.Gui.STANDARD_PADDING, Constants.View.BOTTOM_LINE_POS + Constants.Gui.TOP_LABEL_PADDING)
			.setColorValue(Constants.Color.BLACK)
			.setFont(SFFont_14);
		moveInfectedSlider = cp5.addSlider("infectedSlider")
			.setLabel("")
			.setRange(0, 100)
			.setValue(25)
			.setPosition(Constants.Gui.COL_ONE_CONTROL_X, Constants.View.BOTTOM_LINE_POS + (Constants.Gui.STANDARD_PADDING * 2))
			.setSize(Constants.Gui.INPUT_WIDTH, Constants.Gui.INPUT_HEIGHT);
	}

	void setupGeneralMovementSlider() {
		generalMovementSliderLabel = cp5.addTextlabel("generalMovementSliderLabel")
			.setText("% of people allowed to move:")
			.setPosition(Constants.Gui.STANDARD_PADDING, moveInfectedSliderLabel.getPosition()[1] + Constants.Gui.LABEL_SPACING)
			.setColorValue(Constants.Color.BLACK)
			.setFont(SFFont_14);
		generalMovementSlider = cp5.addSlider("generalMovementSlider")
			.setLabel("")
			.setRange(0, 100)
			.setValue(100)
			.setPosition(Constants.Gui.COL_ONE_CONTROL_X, moveInfectedSlider.getPosition()[1] + Constants.Gui.CONTROL_SPACING)
			.setSize(Constants.Gui.INPUT_WIDTH, Constants.Gui.INPUT_HEIGHT);
	}

	void setupSuperSpreaderSlider() {
		superSpreaderSliderLabel = cp5.addTextlabel("superSPreaderSliderLabel")
			.setText("% of super spreaders (x2 speed):")
			.setPosition(Constants.Gui.STANDARD_PADDING, generalMovementSliderLabel.getPosition()[1] + Constants.Gui.LABEL_SPACING)
			.setColorValue(Constants.Color.BLACK)
			.setFont(SFFont_14);
		superSpreaderSlider = cp5.addSlider("superSpreaderSlider")
			.setLabel("")
			.setRange(0, 100)
			.setValue(0)
			.setPosition(Constants.Gui.COL_ONE_CONTROL_X, generalMovementSlider.getPosition()[1] + Constants.Gui.CONTROL_SPACING)
			.setSize(Constants.Gui.INPUT_WIDTH, Constants.Gui.INPUT_HEIGHT);
	}

	void setupBallCountInput() {
		ballCountTextFieldLabel = cp5.addTextlabel("ballCountLabel")
			.setText("Number of people:")
			.setPosition(moveInfectedSlider.getPosition()[0] + Constants.Gui.INPUT_WIDTH + (Constants.Gui.STANDARD_PADDING * 15), Constants.View.BOTTOM_LINE_POS + Constants.Gui.TOP_LABEL_PADDING)
			.setColorValue(Constants.Color.BLACK)
			.setFont(SFFont_14);
		ballCountTextField = cp5.addTextfield("ballCountInput")
			.setLabel("")
			.setPosition(Constants.Gui.COL_TWO_CONTROL_X, Constants.View.BOTTOM_LINE_POS + Constants.Gui.TOP_LABEL_PADDING)
			.setSize(Constants.Gui.INPUT_WIDTH, Constants.Gui.INPUT_HEIGHT)
			.setFont(SFFont_14)
			.setColorBackground(color(Constants.Color.WHITE))
			.setColor(Constants.Color.BLACK);
		setDefaultBallCount();
	}

	void setupTimeInput() {
		cp5.addTextlabel("secondsInputLabel")
			.setText("Simulation duration (seconds):")
			.setPosition(moveInfectedSlider.getPosition()[0] + Constants.Gui.INPUT_WIDTH + (Constants.Gui.STANDARD_PADDING * 15), ballCountTextField.getPosition()[1] + Constants.Gui.CONTROL_SPACING)
			.setColorValue(Constants.Color.BLACK)
			.setFont(SFFont_14);
		secondsInputTextField = cp5.addTextfield("secondsInput")
			.setLabel("")
			.setPosition(Constants.Gui.COL_TWO_CONTROL_X, ballCountTextField.getPosition()[1] + Constants.Gui.CONTROL_SPACING)
			.setSize(Constants.Gui.INPUT_WIDTH, Constants.Gui.INPUT_HEIGHT)
			.setFont(SFFont_14)
			.setColorBackground(color(Constants.Color.WHITE))
			.setColor(Constants.Color.BLACK);
		setDefaultDuration();
	}

	// GUI getters & setters

	void showResetButton(boolean show) {
		if (show) {
			startButton.show();
		} else {
			startButton.hide();
		}
	}

	float getInfectionMovementReductionPercentage() {
		return moveInfectedSlider.getValue() / 100;
	}

	int getBallCountFromTextField() {
		String ballCountText = ballCountTextField.getText();
		if (Utility.isInteger(ballCountText)) {
			int ballCount = Integer.parseInt(ballCountText);
			int area = (Constants.View.BOTTOM_LINE_POS - Constants.View.TOP_LINE_POS) * Constants.View.SCREEN_WIDTH;
			int totalCircleArea = ((Constants.Simulator.RADIUS * 2) * (Constants.Simulator.RADIUS * 2)) * ballCount;
			if ((float)totalCircleArea/(float)area > 0.5) {
				setDefaultBallCount();
				return Constants.Simulator.DEFAULT_BALL_COUNT;
			} else {
				return ballCount;	
			}
			
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

	float getMovementPercentage() {
		return generalMovementSlider.getValue() / 100;
	}

	float getSuperSpreaderPercentage() {
		return superSpreaderSlider.getValue() / 100;
	}

	// Set default values

	void setDefaultBallCount() {
		ballCountTextField.setText(Integer.toString(Constants.Simulator.DEFAULT_BALL_COUNT));
	}

	void setDefaultDuration() {
		secondsInputTextField.setText(Integer.toString(Constants.Simulator.DEFAULT_TOTAL_SECONDS));
	}

}
