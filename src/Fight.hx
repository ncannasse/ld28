enum Collide {
	No;
	Block;
	Lava;
}

class Fight {

	public static var inst : Fight;
	
	public var root : h2d.Sprite;
	public var sprites : h2d.Sprite;
	var level : Int;
	public var width : Int;
	public var height : Int;
	public var anims : Array<Array<h2d.Tile>>;
	public var game : Game;
	public var hero : ent.Hero;
	public var exit : ent.Exit;
	public var col : Array<Array<Collide>>;
	public var entities : Array<ent.Entity>;
	var scroll : h2d.TileColorGroup;
	
	public function new(level) {
		inst = this;
		this.level = level;
		root = new h2d.Sprite();
		sprites = new h2d.Sprite();
		game = Game.inst;
		game.fight = this;
		
		root.x = 4 * 16;
		root.y = 2 * 16;
		
		anims = [];
		var et = Res.entities.toTile();
		for( frames in [3,2,3,3,4,4,2,5,4] )
			anims.push([for( i in 0...frames ) et.sub(i * 16, anims.length * 16, 16, 16, -8, -16)]);
			
		entities = [];
		
		var bg = new h2d.Bitmap(h2d.Tile.fromColor(0xC0000000, 1000, 1000),root);
		bg.x = -200;
		bg.y = -200;
		var i = new h2d.Interactive(1000, 1000, bg);
		i.cursor = Default;
		
		
		game.scene.add(root, 2);
		
		var t = Res.dungeon.toTile();
		var tiles = [for( y in 0...t.height >> 4 ) for( x in 0...t.width >> 4 ) t.sub(x * 16, y * 16, 16, 16)];
		var map = Res.load("level" + level + ".tmx").toTiledMap().toMap();
		width = map.width;
		height = map.height;

		var mask = new h2d.Mask(16 * 16, 14 * 16, root);
		scroll = new h2d.TileColorGroup(t, mask);
		for( x in 0...width )
			for( y in 0...height ) {
				var l = 0.2 + ((x+y)&1) * 0.1;
				scroll.addColor(x * 16, y * 16, l, l, l, 1, tiles[1]);
			}

		col = [for( x in 0...width ) [for( y in 0...height ) No]];
		
		var MOBS = Type.allEnums(ent.Mob.Kind);
		for( l in map.layers ) {
			var pos = 0;
			if( l.data == null ) {
				for( o in l.objects ) {
					switch( o.name ) {
					case "start":
						hero = new ent.Hero(0, o.x / 16, o.y / 16);
					case "monster":
						new ent.Mob(MOBS[Std.parseInt(o.type)], o.x / 16, o.y / 16);
					case "exit":
						exit = new ent.Exit(4, o.x / 16, o.y / 16);
					default:
						trace(o.name);
					}
				}
				continue;
			}
			if( l.name == "col" ) {
				for( y in 0...height )
					for( x in 0...width ) {
						var t = l.data[pos++] - 1;
						if( t < 0 ) continue;
						col[x][y] = switch( t ) {
						case 16: Block;
						case 32:
							var a = new h2d.Anim(root);
							a.x = x * 16;
							a.y = y * 16;
							a.speed = 10;
							a.colorKey = 0x1D8700;
							a.frames = game.anims[0];
							a.currentFrame = Math.random() * a.frames.length;
							No;
						case 48:
							var a = new h2d.Anim(root);
							a.x = x * 16;
							a.y = y * 16;
							a.speed = 10;
							a.colorKey = 0x1D8700;
							a.frames = game.anims[4];
							a.currentFrame = Math.random() * a.frames.length;
							Lava;
						default:
							throw "COL#" + t;
						}
					}
				continue;
			}
			var g = new h2d.TileGroup(t, root);
			g.colorKey = 0x333333;
			g.alpha = l.opacity;
			for( y in 0...height )
				for( x in 0...width ) {
					var t = l.data[pos++] - 1;
					if( t < 0 ) continue;
					g.add(x * 16, y * 16, tiles[t]);
				}
		}
		if( exit != null ) sprites.addChildAt(exit.mc, 0);
		entities.remove(hero);
		entities.unshift(hero);
		hero.life = game.stats.life;
		root.addChild(sprites);
		
		var g = new h2d.ScaleGrid(Res.fightUI.toTile(), 5, 5);
		g.width = width * 16 + 2;
		g.height = height * 16 + 2;
		g.x = g.y = -1;
		g.colorKey = 0xFF00FF;
		root.addChild(g);
	}
	
	public function end( win : Bool ) {
		if( root.parent == null ) return;
		root.remove();
		game.fight = null;
		if( win ) game.announce("Level " + level + " completed !", Sword, 0xFF00) else game.announce("Try again after healing", Sword, 0xFF0000);
	}
	
	public function update(dt:Float) {
		if( Game.DEBUG && hxd.Key.isDown(hxd.Key.SHIFT) )
			dt *= 0.1;
		var hasMonster = false;
		for( e in entities.copy() ) {
			e.update(dt);
			if( Std.is(e, ent.Mob) )
				hasMonster = true;
		}
		game.stats.life = hero.life;
		if( !hasMonster && exit != null )
			exit.open();
	}
	
}