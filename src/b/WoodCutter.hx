package b;
import Const;

class WoodCutter extends Building {

	public function new()  {
		super(BWoodCutter);
	}
	
	override function getTexts() {
		return [
			"Just tell me to cut some tree and I'll do it for you. Simply ask.",
			"I'll cut any tree you want. Just ask.",
			"I was having a nap, is that time to cut wood already?",
		];
	}
	
	override function getActions() : Array<Building.Action> {
		return [{
			item : null,
			text : "Cut Wood",
			callb : function() {
				start(30, function() game.checkAdd(Wood));
			},
		}];
	}
	
}