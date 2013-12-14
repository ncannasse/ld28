package b;
import Const;

class Tavern extends Building {

	public function new() {
		super(BTavern);
	}
	
	override function getTexts() {
		return [
			"Uh Oh Princess! Ya got wheat? Will make booze for u, ok?",
			"Boooze ?",
			"My Queen is Booze. But I like you too.",
		];
	}
	
	override function getActions() {
		return [{
			item : Wheat,
			text : "Malt Beer",
			enable : game.has(Wheat),
			callb : function() {
				game.use(Wheat);
				start(6, function() game.checkAdd(Beer));
				unlock(BTower);
			},
		}];
	}
		
	
}