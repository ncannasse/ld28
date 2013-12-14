package b;
import Const;

class Dungeon extends Building
{

	public var level : Float;

	public function new()
	{
		super(BDungeon);
		level = 0;
	}

	override function getTexts() {
		return [
			"A dark place that only brave soldiers will enter.\nFight monsters and earn gold there!",
			"Monsters are awaiting for your next sacrifice",
			"You can hear screams. Human ones.",
		];
	}
	
	
	override function getActions() : Array<Building.Action> {
		return [{
			item : Soldier,
			text : "Level 1"+(level <= 0 || level > 1 ? "" : " "+Std.int(level*100)+"%"),
			enable : game.has.bind(Soldier),
			callb : function() {
				game.use(Soldier);
				start(15, function() {
					level += 0.3334;
					game.checkAdd(Gold);
				});
				unlock(BBuilder);
			},
		}];
	}
	
}