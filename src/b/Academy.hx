package b;

class Academy extends Building {
	
	var hpLevel = 10;

	public function new() {
		super(BAcademy);
	}
	
	override function getTexts() {
		return [
			"Spend your treasures here, your Highness, we will make sure to teach you proper fighting.",
			"I can see your Highness is improving her fighting skills. You have a good teacher.",
			"Once I was a child, I could level up simply be training myself. Today everyone is talking about monetization...",
		];
	}
	
	override function getActions() {
		var actions = new Array<Building.Action>();
		actions.push({
			item : Gold,
			text : "HP+"+hpLevel,
			enable : function() return game.has(Gold),
			callb : function() {
				game.use(Gold);
				start(10+hpLevel/10,function() {
					game.stats.maxLife += hpLevel;
					game.announce("Max HP has increased to " + game.stats.maxLife, Hp, 0xFFFF00);
					if( hpLevel < 50 ) hpLevel += 10;
				});
			},
		});
		
		actions.push({
			item : Diamond,
			text : "Att+"+(Std.int(game.stats.att*0.5)),
			enable : function() return game.has(Diamond),
			callb : function() {
				game.use(Diamond);
				start(10,function() {
					game.stats.att *= 1.5;
					game.announce("Max attack has increased to " + Std.int(game.stats.att), Sword, 0xFFFF00);
				});
			},
		});
		
		actions.push({
			item : Cucumber,
			text : "Def+"+(Std.int(game.stats.def*0.25)),
			enable : function() return game.has(Cucumber),
			callb : function() {
				game.use(Cucumber);
				start(10,function() {
					game.stats.def *= 1.25;
					game.announce("Max defense has increased to " + Std.int(game.stats.def), Shield, 0xFFFF00);
				});
			},
		});
		
		if( game.stats.fireLevel < 2 ) {
			actions.push({
				item : Knight,
				enable : game.has.bind(Knight),
				text : "Fire+",
				callb : function() {
					game.use(Knight);
					start(30,function() {
						game.stats.fireLevel++;
						switch( game.stats.fireLevel ) {
						case 1:
							game.announce("You fire range has increased", Hp, 0xFFFF00);
						case 2:
							game.announce("You fire rate has increased", Hp, 0xFFFF00);
						}
					});
				},
			});
		}
		
		return actions;
	}
	
}