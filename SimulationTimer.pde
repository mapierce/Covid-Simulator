class SimulationTimer {

	private int startTime;
	private boolean countStarted = false;

	void updateWithCounts(int healthy, int infected, int recovered) {
		if (healthy < 400 && recovered == 0 && !countStarted) {
			countStarted = true;
			println("Simulation timer started...");
			startTime = millis();
		} 
		if (infected == 0 && countStarted) {
			countStarted = false;
			println("Simulation timer ended...");
			println("Total time to complete simulation: " + (millis() - startTime) / 1000 + " seconds.");
		}
	}

}