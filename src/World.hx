import Const;

class World {

	var game : Game;
	var map : hxd.res.TiledMap.TiledMapData;
	public var width : Int;
	public var height : Int;
	public var root : h2d.Sprite;
	var layers : Map < String, { name : String, data : Array<Int>, g : h2d.TileGroup, alpha : Float } > ;
	var tiles : Array<h2d.Tile>;

	public function new( r : hxd.res.TiledMap, tiles : hxd.res.Image )  {
		game = Game.inst;
		map = r.toMap();
		root = new h2d.Sprite();
		width = map.width;
		height = map.height;
		var t = tiles.toTile();
		layers = new Map();
		this.tiles = [for( y in 0...t.height >> 4 ) for( x in 0...t.width >> 4 ) t.sub(x * 16, y * 16, 16, 16)];
		for( ld in map.layers ) {
			var l = {
				name : ld.name,
				data : ld.data,
				g : new h2d.TileGroup(t, root),
				alpha : ld.opacity,
			}
			l.g.colorKey = 0x1D8700;
			l.g.alpha = ld.opacity;
			layers.set(ld.name, l);
			rebuildLayer(ld.name);
		}
	}

	function rebuildLayer( name : String ) {
		var l = layers.get(name);
		if( l == null ) return;
		var pos = 0;
		var g = l.g;
		g.clear();
		while( g.numChildren > 0 )
			g.getChildAt(0).remove();

		var bpos = [], bkinds = [];
		for( b in game.buildings ) {
			if( !b.visible ) continue;
			bkinds.push(b.kind);
			bpos.push(Texts.BUILDPOS(b.kind));
		}

		for( y in 0...height )
			for( x in 0...width ) {
				var t = l.data[pos++] - 1;
				if( t < 0 ) continue;
				if( l.name == "Buildings" || l.name == "BuildingsShadows" ) {
					inline function addButton(w, h, b) {
						var i = new h2d.Interactive(w * 16, h * 16, g);
						i.onClick = function(_) onClickBuilding(b);
						i.x = x * 16;
						i.y = y * 16;
					}
					inline function addAnim(n, dx:Float, dy:Float, speed = 1.0) {
						var a = new h2d.Anim(g);
						a.frames = game.anims[n];
						a.x = (x + dx) * 16;
						a.y = (y + dy) * 16;
						a.colorKey = 0x1D8700;
						a.speed = 10 * speed;
						a.currentFrame = Math.random() * a.frames.length;
					}
					var found = false;
					for( p in bpos )
						if( x >= p[0] && y >= p[1] && x < p[0] + p[2] && y < p[1] + p[3] ) {
							if( x == p[4] && y == p[5] ) {
								var k = bkinds[Lambda.indexOf(bpos, p)];
								addButton(p[6], p[7], k);
								switch( k ) {
								case BTavern:
									addAnim(2, 3, 0);
								case BTower:
									addAnim(0, 0, 2);
									addAnim(0, 1, 2);
								case BDungeon:
									addAnim(1, -1, 1);
									addAnim(1, 2, 1);
								case BCastle:
									addAnim(3, 9/16, 3 + 2/16);
								default:
								}
							}
							found = true;
							break;
						}
					if( !found ) continue;
				}
				g.add(x * 16, y * 16, tiles[t]);
			}
	}

	public dynamic function onClickBuilding( b : BuildingKind ) {
		trace(b);
	}

	public function rebuild( speed = 1.0 ) {
		for( l in [layers.get("Buildings"),layers.get("BuildingsShadows"),] ) {
			var old = l.g;
			var i = 0;
			while( i < old.numChildren ) {
				var c = old.getChildAt(i);
				if( Std.is(c, h2d.Interactive) )
					c.remove();
				else
					i++;
			}
			l.g = new h2d.TileGroup(tiles[0]);
			l.g.colorKey = 0x1D8700;
			root.addChildAt(l.g, root.getChildIndex(old));
			rebuildLayer(l.name);
			l.g.alpha = 0;
			var t = new haxe.Timer(10);
			t.run = function() {
				l.g.alpha += 0.05 * speed;
				if( l.g.alpha > l.alpha ) {
					l.g.alpha = l.alpha;
					old.alpha -= 0.05 * speed;
					if( old.alpha < 0 ) old.alpha = 0;
				}
				if( l.g.alpha == l.alpha && old.alpha == 0 ) {
					old.remove();
					t.stop();
				}
			};
		}
	}



}