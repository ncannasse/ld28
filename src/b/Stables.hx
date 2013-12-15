package b;

class Stables extends Building {

	public function new() {
		super(BStables);
	}
	
	override function getTexts() {
		return [
			"We will raise powerful Horses if we can feed them with wheat.",
			"I love horses. You love them too, right?",
			"Horses are the best friends of humans. Just after cows.",
		];
	}
	
	override function getActions() : Array<Building.Action> {
		return [{
			item : Wheat,
			text : "Raise Horse",
			enable : game.has.bind(Wheat),
			callb : function() {
				game.use(Wheat);
				start(20, function() spawn(Horse));
			},
		}];
	}
			
}