import Const;

@:publicFields
class Game extends hxd.App {
	
	public static inline var DEBUG = true;
	
	public var scene : h2d.Scene;
	public var font : h2d.Font;
	public var world : World;
	public var buildings : Map<BuildingKind,Building>;
	public var curDialog : h2d.Sprite;
	public var inventory : Array<Bool>;
	var anims : Array<Array<h2d.Tile>>;
	var items : Array<h2d.Tile>;
	var invSpr : h2d.Sprite;
	var updates : Array < { function update(dt:Float) : Void; }>;
	var curAnnounce : h2d.Sprite;
	var stats : { life : Float, maxLife : Int, att : Float, def : Float, lifeText : h2d.Text, regen : Float };
	
	override function init() {
		scene = s2d;
		updates = [];
		buildings = new Map();
		s2d.setFixedSize(Const.W, Const.H + 12);
		world = new World(Res.map, Res.tiles);
		s2d.add(world.root, 0);
		font = Res.Minecraftia.build(8, { antiAliasing : false } );
		
		var atile = Res.sprites.toTile();
		anims = [];
		for( frames in [5,5,5,4] )
			anims.push([for( i in 0...frames ) atile.sub(i * 16, anims.length * 16, 16, 16)]);
		
		var itemsTile = Res.items.toTile();
		items = [for( i in 0...16 ) itemsTile.sub(i * 10, 0, 10, 10)];
		
		inventory = [true];
		updateInventory();
	
		/*
		var iall = new h2d.Interactive(Const.W, Const.H - 8);
		iall.y = 8;
		iall.onClick = function(e:hxd.Event) {
			if( curDialog != null && curDialog.parent == null ) curDialog = null;
			if( curDialog != null )
				curDialog.click();
			else
				e.propagate = true;
		}
		iall.onOver = function(e) { e.cancel = true; e.propagate = true; }
		iall.onOut = function(e) { e.cancel = true; e.propagate = true; }
		iall.onMove = function(e) { e.cancel = true; e.propagate = true; }
		s2d.add(iall, 2);
		*/

		if( DEBUG ) {
			inventory = [true, true, true, true, true, true, true];
			updateInventory();
			for( b in BuildingKind.createAll() ) {
				//if( b.getIndex() > BBuilder.getIndex() ) continue;
				unlockBuilding(b);
			}
		} else {
			dialog(Texts.WELCOME, Res.sfx.speak00, function() {
				unlockBuilding(BFarmer);
				Res.sfx.done.play();
			});
		}
		
		world.onClickBuilding = function(b) {
			var bd = buildings.get(b);
			if( bd != null ) bd.click();
		};
	}
	
	function updateInventory() {
		if( invSpr != null ) invSpr.remove();
		invSpr = new h2d.Sprite();
		invSpr.y = Const.H;
		new h2d.Bitmap(h2d.Tile.fromColor(0xFF000000,Const.W,12), invSpr);
		s2d.add(invSpr, 2);
		var tip = new h2d.Text(font, invSpr);
		tip.visible = false;
		tip.y = -12;
		tip.dropShadow = { dx : 0, dy : 1, color : 0, alpha : 0.5 };
		for( i in 0...inventory.length ) {
			if( !inventory[i] ) continue;
			var s = new h2d.Bitmap(items[i], invSpr);
			s.x = i * 12;
			s.y = 1;
			var int = new h2d.Interactive(8, 8, s);
			int.onOver = function(_) {
				tip.x = s.x + 2;
				tip.text = Texts.ITEMNAME(Item.createAll()[i]);
				tip.visible = true;
			};
			int.onOut = function(_) {
				tip.visible = false;
			};
		}
		if( stats != null ) {
			var ico = new h2d.Bitmap(items[Hp.getIndex()], invSpr);
			ico.x = 238;
			ico.y = 1;
			var t = new h2d.Text(font, invSpr);
			t.text = Std.int(stats.life) + "/" + stats.maxLife;
			t.x = ico.x + 12;
			stats.lifeText = t;
			
			var ico = new h2d.Bitmap(items[Sword.getIndex()], invSpr);
			ico.x = 315;
			ico.y = 1;
			var t = new h2d.Text(font, invSpr);
			t.text = ""+Std.int(stats.att);
			t.x = ico.x + 12;

			var ico = new h2d.Bitmap(items[Shield.getIndex()], invSpr);
			ico.x = 350;
			ico.y = 1;
			var t = new h2d.Text(font, invSpr);
			t.text = ""+Std.int(stats.def);
			t.x = ico.x + 12;
		}
		invSpr.addChild(tip);
	}
	
	function has(i:Item) {
		return inventory[i.getIndex()];
	}
	
	function checkAdd( i : Item ) {
		if( has(i) ) {
			announce("You already got one " + Texts.ITEMNAME(i), i, 0xFF0000);
			return false;
		}
		add(i);
		return true;
	}
	
	function add(i:Item,silent=false) {
		if( has(i) ) throw "assert";
		if( !silent ) announce("You got " + Texts.ITEMNAME(i), i);
		inventory[i.getIndex()] = true;
		updateInventory();
		for( b in buildings )
			b.refresh();
	}
	
	function use(i:Item) {
		if( !inventory[i.getIndex()] )
			throw "assert";
		inventory[i.getIndex()] = false;
		updateInventory();
	}
	
	function announce( t : String, ?icon : Item, ?color : Int ) {
		var tf = new h2d.Text(font);
		tf.text = t;
		tf.dropShadow = { dx : 0, dy : 1, color : 0, alpha : 0.5 };
		var size =  tf.textWidth + 2 + (icon == null ? 0 : 11);
		var a = new h2d.Bitmap(h2d.Tile.fromColor(0x60000000,size,10));
		a.x = Const.W - size;
		a.addChild(tf);
		tf.x = 1;
		tf.y = -1;
		if( color != null )
			tf.textColor = color;
		if( icon != null ) {
			var ic = new h2d.Bitmap(items[icon.getIndex()], a);
			ic.x = 0;
			ic.y = 0;
			ic.colorKey = 0;
			tf.x += 11;
		}
		s2d.add(a, 1);
		a.y = Const.H;
		var py = 0.;
		var s = -1;
		var w = 0.;
		var u = new Update();
		u.update = function(dt) {
			py += s * dt;
			if( py < -10 ) {
				py = -10;
				w += dt;
				if( w > 120 ) s *= -1;
			}
			if( py > 0 ) {
				a.remove();
				u.stop();
			}
			a.y = Const.H + Std.int(py);
		};
		if( curAnnounce != null ) curAnnounce.remove();
		curAnnounce = a;
	}
	
	function unlockBuilding( b : BuildingKind ) {
		var bi = buildings.get(b);
		if( bi != null ) {
			switch( bi.kind ) {
			case BWheat:
				Std.instance(bi, std.b.Wheat).level++;
				announce("Wheat will grow faster", Wheat, 0xFF00);
			case BCastle:
				Std.instance(bi, std.b.Castle).level++;
				announce("New Castle Level available!", Sword, 0xFF80FF);
			default:
			}
			for( b in buildings ) b.refresh();
			return;
		}
			
		announce("You got " + Texts.BUILDNAME(b));
			
		var b = switch( b ) {
		case BFarmer: new b.Farmer();
		case BWheat: new b.Wheat();
		case BTavern: new b.Tavern();
		case BTower: new b.Tower();
		case BDungeon: new b.Dungeon();
		case BBuilder: new b.Builder();
		case BWoodCutter: new b.WoodCutter();
		case BMiner: new b.Miner();
		case BShop: new b.Shop();
		case BCastle:
			stats = { life : 100., maxLife : 100, att : 10, def : 10, lifeText : null, regen : 10. };
			updateInventory();
			new b.Castle();
		}
		buildings.set(b.kind, b);
		world.rebuild();
	}
	
	function newPanel(w, h) {
		var g = new h2d.ScaleGrid(Res.ui.toTile(), 5, 5);
		g.width = w;
		g.height = h;
		g.colorKey = 0xFF00FF;
		scene.add(g, 1);
		return g;
	}
	
	function removeDialog() {
		if( curDialog != null ) {
			curDialog.remove();
			curDialog = null;
		}
	}

	
	function dialog( t : Array<String>, sfx, ?onDone ) {
		if( t.length == 0 ) {
			if( onDone != null )
				onDone();
			return;
		}
		var d = new Dialog(Const.W, 50, t[0], sfx);
		d.y = Const.H - d.height;
		d.onClick = function() {
			d.remove();
			curDialog = null;
			var t2 = t.copy();
			t2.shift();
			dialog(t2, sfx, onDone);
		};
		curDialog = d;
	}
	
	override function update(dt:Float) {
		if( stats != null ) {
			var old = Std.int(stats.life);
			stats.life += stats.regen * dt / 60;
			if( stats.life > stats.maxLife ) stats.life = stats.maxLife;
			stats.lifeText.text = Std.int(stats.life) + "/" + stats.maxLife;
		}
		for( a in updates )
			a.update(dt);
		for( b in buildings )
			b.update(dt);
	}
	
	public static var inst : Game;
	static function main() {
		Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create( { compressSounds : true } ));
		inst = new Game();
	}
	
}