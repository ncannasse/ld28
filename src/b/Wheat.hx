package b;

class Wheat extends Building {

	public function new() {
		super(BWheat);
	}
	
	override function click() {
		if( pending != null )
			return;
		start(1,function() {
			if( !game.checkAdd(Wheat) )
				return;
			if( !game.has(Seed) )
				game.add(Seed,true);
			game.buildings.remove(BWheat);
			game.world.rebuild();
		});
		unlock(BTavern);
	}
	
}