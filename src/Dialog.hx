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
	
	public function new(width:Int, height:Int, text : String) {
		super();
		if( text == null ) text = "NULL";
		game = Game.inst;
		game.scene.add(this, 1);
		bg = new h2d.ScaleGrid(Res.ui.toTile(), 5, 5, this);
		bg.colorKey = 0xFF00FF;
		tf = new h2d.Text(game.font, this);
		tf.y = 5;
		tf.x = 7;
		tf.dropShadow = { dx : 0, dy : 1, color : 0, alpha : 0.3 };
		int = new h2d.Interactive(0,0,this);
		int.onClick = function(_) click();
		this.width = width;
		this.height = height;
		this.text = text;
	}
	
	function updateText() {
		if( textPos == text.length ) {
			timer.stop();
			onReady();
			return;
		}
		textPos++;
		tf.text = text.substr(0, textPos);
	}
	
	public function click() {
		if( textPos == text.length ) onClick() else if( textPos < text.length ) { textPos = text.length; tf.text = text; timer.stop(); onReady(); };
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