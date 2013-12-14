class World {

	public var width : Int;
	public var height : Int;
	public var root : h2d.Sprite;
	var layers : Array<h2d.TileGroup>;

	
	public function new( r : hxd.res.TiledMap, tiles : hxd.res.Texture )  {
		var m = r.toMap();
		root = new h2d.Sprite();
		width = m.width;
		height = m.height;
		var t = tiles.toTile();
		layers = [];
		var tiles = [for( y in 0...t.height >> 4 ) for( x in 0...t.width >> 4 ) t.sub(x * 16, y * 16, 16, 16)];
		for( l in m.layers ) {
			var pos = 0;
			var g = new h2d.TileGroup(t, root);
			g.colorKey = 0x1D8700;
			for( y in 0...height )
				for( x in 0...width ) {
					var t = l.data[pos++] - 1;
					if( t < 0 ) continue;
					if( l.name == "Buildings" || l.name == "BuildingsShadows" ) continue;
					g.add(x * 16, y * 16, tiles[t]);
				}
			g.alpha = l.opacity;
		}
	}
	
	
	
}