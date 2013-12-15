package b;
import Const;

class Miner extends Building {

	var count = 0;
	
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
				start(40, function() { spawn(count % 3 == 2 ? Diamond : Ore); count++; });
			},
		}];
	}
}