package b;

class Wheat extends Building {

	public function new() {
		super(BWheat);
	}
	
	override function click() {
		if( !game.checkAdd(Wheat) )
			return;
		if( !game.has(Seed) )
			game.add(Seed,true);
		game.buildings.remove(BWheat);
		game.world.rebuild();
		haxe.Timer.delay(game.unlockBuilding.bind(BTavern), 1000);
	}
	
}