package b;
import Const;

class Farmer extends Building {

	public function new() {
		super(BFarmer);
	}
	
	override function getTexts() {
		return [
			"Farmer : I'm glad you are safe, your Majesty.\nI'm just a poor farmer but I'll help your the best I can.",
			"I'll plant these seeds for you",
			"Want food ?",
			"I'm tired of farming, but I'll make some efforts for your Majesty.",
		];
	}
	
	override function getActions() {
		return [{
			item : Seed,
			text : "Plant Seed",
			enable : game.has(Seed),
			callb : function() {
				game.use(Seed);
				start(4, function() game.unlockBuilding(BWheat));
			},
		}];
	}
	
}