package b;
import Const;

class Miner extends Building {

	public function new() {
		super(BMiner);
	}

	
	override function getTexts() {
		return [
			"I'll mine down to the bedrock if you ask me, Milady.",
			"How far do you want me to mine today?",
			"I'm sure one day I'll find a Diamond as beautiful as your, your Grace",
		];
	}
	
	override function getActions() : Array<Building.Action> {
		return [{
			item : null,
			text : "Mine Ore",
			callb : function() {
				start(40, function() game.checkAdd(Std.random(10) == 0 && !game.has(Diamond) ? Diamond : Ore));
			},
		}];
	}
}