package b;
import Const;

class Tower extends Building {
	
	public function new() {
		super(BTower);
	}
	
	override function getTexts() {
		return [
			"We will fight evil for you, but we need something to help us fight fear. Got anything?",
			"Beer will help us fight darkness.",
			"In the name of beer, I'll fight evil for you Milady",
			"I'm freezing. Is winter coming?",
		];
	}
	
	override function getActions() : Array<Building.Action> {
		return [{
			item : Beer,
			text : "Recruit",
			enable : game.has.bind(Beer),
			callb : function() {
				game.use(Beer);
				start(10, function() game.checkAdd(Soldier));
				unlock(BDungeon);
			},
		}];
	}
	
	
}