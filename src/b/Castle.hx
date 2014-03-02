package b;

class Castle extends Building {

	public var maxLevel : Int = 0;
	var wonLevel : Int = 0;
	
	public function new() {
		super(BCastle);
		if( Game.DEBUG ) {
			maxLevel = 4;
			wonLevel = 4;
		}
	}
	
	override function getTexts() {
		return [
			"This is your castle Princess, but it has been invaded by the Evil one. You must deliver the poor Hero which got captured inside!",
			"If your life is good enough, kill all the evil monsters, Princess!",
			"Hurry up! The poor Hero is waiting for you to save him, Princess!",
		];
	}
	
	public function endFight( level : Int, win : Bool ) {
		if( win ) {
			if( level > wonLevel ) wonLevel = level;
			spawn(Gold);
			game.unlockBuilding(BBuilder);
			game.stats.xp++;
			if( wonLevel == 5 ) game.victory();
			Res.sfx.won.play();
		} else {
			Res.sfx.lost.play();
			game.announce("Try again after healing", Sword, 0xFF0000);
		}
	}
	
	override function getActions() {
		var actions = new Array<Building.Action>();
		for( i in 0...(maxLevel == 0 ? 1 : maxLevel) ) {
			var level = i + 1;
			actions.push({
				item : Sword,
				text : "Level " + level,
				enable : function() return maxLevel >= level && wonLevel >= level - 1,
				callb : function() {
					new Fight(level);
				},
			});
		}
		return actions;
	}
	
}