import Const;

@:publicFields
class Game extends hxd.App {

	public static inline var DEBUG = false;
	public static inline var ADMIN = false;

	public var scene : h2d.Scene;
	public var font : h2d.Font;
	public var world : World;
	public var buildings : Map<BuildingKind,Building>;
	public var curDialog : h2d.Object;
	public var inventory : Array<Bool>;
	var anims : Array<Array<h2d.Tile>>;
	var items : Array<h2d.Tile>;
	var invSpr : h2d.Object;
	var updates : Array < { function update(dt:Float) : Void; }>;
	var curAnnounce : h2d.Object;
	var stats : { life : Float, maxLife : Int, att : Float, def : Float, lifeText : h2d.Text, regen : Float, xp : Int, fireLevel : Int };
	var fight : Fight;
	var knownItems : Array<Bool>;

	override function init() {
		scene = s2d;
		updates = [];
		buildings = new Map();
		s2d.setFixedSize(Const.W, Const.H + 12);
		world = new World(Res.map, Res.tiles);
		s2d.add(world.root, 0);
		font = Res.minecraftia_regular_6.toFont();

		var atile = Res.sprites.toTile();
		anims = [];
		for( frames in [5,5,5,4,4,4] )
			anims.push([for( i in 0...frames ) atile.sub(i * 16, anims.length * 16, 16, 16)]);

		var itemsTile = Res.items.toTile();
		items = [for( i in 0...Unknown.getIndex()+1 ) itemsTile.sub(i * 10, 0, 10, 10)];

		knownItems = [true];
		inventory = [true];

		if( DEBUG ) {
			inventory = [true, true, true, true, true, true, true, true];
			for( b in BuildingKind.createAll() )
				unlockBuilding(b);
			stats.xp = 1;
			stats.def *= 1.25;
			stats.maxLife += 30;
			stats.life = stats.maxLife;
			new Fight(2);
		} else {
			dialog(Texts.WELCOME, Res.sfx.speak00, function() {
				unlockBuilding(BFarmer);
				Res.sfx.done.play();
			});
		}

		while( inventory.length < Hp.getIndex() )
			inventory.push(false);
		updateInventory();

		world.onClickBuilding = function(b) {
			var bd = buildings.get(b);
			if( bd != null ) bd.click();
		};
	}

	function victory() {
		var bg = new h2d.Bitmap(Res.victory.toTile());
		s2d.add(bg, 5);
		bg.alpha = 0;
		var i = new h2d.Interactive(1000, 1000, bg);
		var u = new Update();
		var anims = [];
		var e = Res.entities.toTile();
		var f = [for( i in 0...10 ) e.sub((i & 1) * 16, 16, 16, 16)];
		for( i in 0...3 )
			f.push(e.sub(i * 16, 32, 16, 16));
		var mask = new h2d.Mask(400, 100, bg);
		mask.y = Const.H - mask.height;
		var text = new h2d.Object(mask);
		var py = 0;
		for( line in Texts.VICTORY ) {
			var l = new h2d.Text(font, text);
			l.text = line;
			l.x = Std.int((Const.W - l.textWidth) * 0.5);
			l.y = py;
			py += 10;
		}
		var credits = new h2d.Text(font, bg);
		credits.text = "(C)2013 @ncannasse, made in 48h for LD#28";
		credits.y = Const.H;
		credits.x = 5;
		text.y = 100;
		u.update = function(dt) {
			if( bg.alpha < 0.8 )
				bg.alpha += 0.004 * dt;
			else {
				if( text.y > -150 )
					text.y -= 0.1 * dt;
				else
					credits.visible = true;
				if( Math.random() < 0.1 ) {
					var a = new h2d.Anim(bg);
					a.play(f);
					a.speed = 15;
					a.loop = false;
					a.x = 10 + Std.random(350);
					a.y = 10 + Std.random(280);
					a.colorKey = 0x333333;
					anims.push(a);
				}
				for( a in anims )
					if( a.currentFrame + 0.01 > a.frames.length ) {
						a.remove();
						anims.remove(a);
					}
			}
		};
	}

	function updateInventory() {
		if( invSpr != null ) invSpr.remove();
		invSpr = new h2d.Object();
		invSpr.y = Const.H;
		new h2d.Bitmap(h2d.Tile.fromColor(0,Const.W,12), invSpr);
		s2d.add(invSpr, 3);
		var tip = new h2d.Text(font, invSpr);
		tip.visible = false;
		tip.y = -12;
		tip.dropShadow = { dx : 0, dy : 1, color : 0, alpha : 0.5 };
		for( i in 0...inventory.length ) {
			if( !inventory[i] ) {
				if( !knownItems[i] ) {
					var s = new h2d.Bitmap(items[Unknown.getIndex()], invSpr);
					s.x = i * 13;
					s.y = 1;
				}
				continue;
			}
			var s = new h2d.Bitmap(items[i], invSpr);
			s.x = i * 13;
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
		for( i in 0...inventory.length ) {
			if( !inventory[i] ) continue;
			var o = new h2d.Bitmap(Res.one.toTile(), invSpr);
			o.colorKey = 0;
			o.x = i * 13 + 8;
			o.y = 7;
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
			Res.sfx.cancel.play();
			announce("You already got one " + Texts.ITEMNAME(i), i, 0xFF0000);
			return false;
		}
		return true;
	}

	function add(i:Item,silent=false) {
		if( has(i) ) throw "assert";
		if( !silent ) announce("You got " + Texts.ITEMNAME(i), i);
		Res.sfx.item.play();
		inventory[i.getIndex()] = true;
		knownItems[i.getIndex()] = true;
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
		var a = new h2d.Bitmap(h2d.Tile.fromColor(0,size,10,0x60/255));
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
				Std.instance(bi, std.b.Castle).maxLevel++;
				announce("New Castle Level available!", Sword, 0xFF80FF);
			default:
			}
			for( b in buildings ) b.refresh();
			return;
		}

		announce("You got " + Texts.BUILDNAME(b));
		Res.sfx.confirm.stop();
		Res.sfx.build.play();

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
			stats = { life : 100., maxLife : 100, att : 10, def : 10, lifeText : null, regen : 5., xp : 0, fireLevel : 0 };
			updateInventory();
			new b.Castle();
		case BAcademy: new b.Academy();
		case BStables: new b.Stables();
		case BFisher: new b.Fisher();
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
		dt *= 60;
		if( fight != null )
			fight.update(dt);
		if( Game.ADMIN && hxd.Key.isDown(hxd.Key.SHIFT) )
			dt *= 10;
		for( a in updates )
			a.update(dt);
		for( b in buildings )
			b.update(dt);
		if( stats != null ) {
			if( fight == null ) stats.life += stats.regen * (has(Amulet) ? 5 : 1) * dt / 60;
			if( stats.life > stats.maxLife ) stats.life = stats.maxLife;
			var txt = Std.int(stats.life) + (stats.life == stats.maxLife ? "" : "/" + stats.maxLife);
			stats.lifeText.text = txt;
		}
	}

	public static var inst : Game;
	static function main() {
		hxd.Res.initEmbed( { compressSounds : true } );
		new Title();
	}

}