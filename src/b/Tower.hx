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
	
	override function getActions() {
		var actions = new Array<Building.Action>();
		actions.push({
			item : Beer,
			text : "Recruit",
			enable : game.has.bind(Beer),
			callb : function() {
				game.use(Beer);
				start(10, function() spawn(Soldier));
				unlock(BDungeon);
			},
		});
		if( game.buildings.exists(BStables) ) {
			actions.push({
				item : Horse,
				text : "Recruit Knight",
				enable : game.has.bind(Horse),
				callb : function() {
					game.use(Horse);
					start(5, function() spawn(Knight));
				},
			});
		}
		return actions;
	}
	
	
}