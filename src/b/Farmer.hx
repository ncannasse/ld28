package b;
import Const;

class Farmer extends Building {

	public function new() {
		super(BFarmer);
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