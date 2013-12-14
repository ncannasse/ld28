package b;

class Wheat extends Building {

	public function new() {
		super(BWheat);
	}
	
	override function click() {
		if( pending != null )
			return;
		Res.sfx.confirm.play();
		start(1,function() {
			if( !game.checkAdd(Wheat) )
				return;
			if( !game.has(Seed) )
				game.add(Seed,true);
			game.buildings.remove(BWheat);
			game.world.rebuild(2);
		});
		unlock(BTavern);
	}
	
}