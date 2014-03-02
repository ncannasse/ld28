class Dialog extends h2d.Sprite {

	var game : Game;
	var bg : h2d.ScaleGrid;
	var tf : h2d.Text;
	var timer : haxe.Timer;
	var int : h2d.Interactive;
	public var width(default, set) : Int;
	public var height(default, set) : Int;
	public var text(default, set) : String;
	var textPos : Int;
	var sfx : hxd.res.Sound;
	
	public function new(width:Int, height:Int, text : String,sfx:hxd.res.Sound) {
		super();
		this.sfx = sfx;
		if( sfx != null ) {
			sfx.loop = true;
			sfx.play();
		}
		if( text == null ) text = "NULL";
		game = Game.inst;
		game.scene.add(this, 1);
		bg = new h2d.ScaleGrid(Res.ui.toTile(), 5, 5, this);
		bg.colorKey = 0xFF00FF;
		tf = new h2d.Text(game.font, this);
		tf.y = 5;
		tf.x = 7;
		tf.dropShadow = { x : 0, y : 1, color : 0, alpha : 0.3 };
		int = new h2d.Interactive(0,0,this);
		int.onClick = function(_) click();
		this.width = width;
		this.height = height;
		this.text = text;
	}
	
	override function onDelete() {
		super.onDelete();
		if( sfx != null )
			sfx.stop();
		timer.stop();
	}
	
	function updateText() {
		if( textPos == text.length ) {
			timer.stop();
			onReady();
			if( sfx != null ) sfx.stop();
			return;
		}
		if( sfx != null ) {
			switch( text.charCodeAt(textPos) ) {
			case " ".code, "\n".code: sfx.volume = 0;
			default: if( sfx.volume == 0 ) sfx.volume = 1 else sfx.volume *= 0.9;
			}
		}
		textPos++;
		tf.text = text.substr(0, textPos);
	}
	
	public function click() {
		if( textPos == text.length ) onClick() else if( textPos < text.length ) { textPos = text.length; tf.text = text; updateText(); };
	}
	
	public dynamic function onClick() {
	}
	
	public dynamic function onReady() {
	}
	
	function set_text(t) {
		text = t;
		timer = new haxe.Timer(30);
		timer.run = updateText;
		tf.text = "";
		textPos = 0;
		return t;
	}
	
	function set_width(w) {
		bg.width = w;
		int.width = w;
		tf.maxWidth = w - 14;
		tf.text = text;
		return width = w;
	}
	
	function set_height(h) {
		bg.height = h;
		int.height = h;
		return height = h;
	}
	
}