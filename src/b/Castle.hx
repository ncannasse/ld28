package b;

class Castle extends Building {

	public var level : Int = 0;
	
	public function new() {
		super(BCastle);
		if( Game.DEBUG ) level = 1;
	}
	
	override function getTexts() {
		return [
			"This is your castle Princess, but it has been invaded by the Evil one. You must deliver the poor Hero which got captured inside!",
			"If your life is good enough, kill all the evil monsters, Princess!",
			"Hurry up! The poor Hero is waiting for you to save him, Princess!",
		];
	}
	
	override function getActions() : Array<Building.Action> {
		return [ {
			item : Sword,
			text : "Level " + (level == 0 ? 1 : level),
			enable : function() return level > 0,
			callb : function() {
				new Fight(level);
			},
		}];
	}
}