package b;
import Const;

class Tavern extends Building {

	public function new() {
		super(BTavern);
	}
	
	override function getActions() {
		return [{
			item : Wheat,
			text : "Malt Beer",
			enable : game.has(Wheat),
			callb : function() {
				game.use(Wheat);
				start(6, function() game.checkAdd(Beer));
			},
		}];
	}
		
	
}