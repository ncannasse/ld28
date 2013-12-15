package b;

class Fisher extends Building {

	public function new() {
		super(BFisher);
	}
	
	override function getTexts() {
		return [
			"I want fish. It's mine.",
			"Fish are mine. My fishes. Mine.",
		];
	}
	
	override function getActions() : Array<Building.Action> {
		return [{
			item : Wood,
			text : "Fish",
			enable : game.has.bind(Wood),
			callb : function() {
				game.use(Wood);
				start(25, function() spawn(Fish));
			},
		}];
	}
}