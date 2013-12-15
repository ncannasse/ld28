package b;

class Wheat extends Building {

	public var level = 5;
	
	public function new() {
		super(BWheat);
	}
	
	override function update(dt:Float) {
		if( !visible ) dt *= level / 5;
		super.update(dt);
	}
	
	override function click() {
		if( pending != null )
			return;
		Res.sfx.confirm.play();
		start(1, function() {
			if( !game.checkAdd(Wheat) )
				return;
			spawn(Wheat);
			if( !game.has(Seed) && Std.random(3) == 0 )
				haxe.Timer.delay(spawn.bind(Seed), 1500);
			visible = false;
			game.world.rebuild(2);
			start(60, function() {
				visible = true;
				game.world.rebuild(2);
			});
		});
		unlock(BTavern);
	}
	
}