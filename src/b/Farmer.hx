package b;
import Const;

class Farmer extends Building {

	public function new() {
		super(BFarmer);
	}
	
	override function getTexts() {
		return [
			"I'm glad you are safe, your Majesty.\nI'm just a poor farmer but I'll help your the best I can.",
			"I'll plant these seeds for you",
			"Want food ?",
			"I'm tired of farming, but I'll make some efforts for your Majesty.",
		];
	}
	
	override function getActions() {
		var actions = new Array<Building.Action>();
		actions.push({
			item : Seed,
			text : "Plant Seed",
			enable : game.has.bind(Seed),
			callb : function() {
				game.use(Seed);
				start(4, function() game.unlockBuilding(BWheat));
			},
		});
		if( game.buildings.exists(BShop) ) {
			actions.push( {
				item : Plow,
				text : "Use Plow",
				enable : game.has.bind(Plow),
				callb : function() {
					game.use(Plow);
					start(4, function() {
						var b = game.buildings.get(BWheat);
						if( !b.visible && b.pending != null )
							b.pending.time = b.pending.max;
						game.unlockBuilding(BWheat);
					});
				}
			});
		}
		return actions;
	}
	
}