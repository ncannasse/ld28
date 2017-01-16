class Title extends hxd.App {

	var bg : h2d.Sprite;
	var time = 0.;
	var b : h2d.Bitmap;
	var start : h2d.Text;
	var stime = 0.;
	var alphaMap : h3d.shader.AlphaMap;

	override function init() {
		s2d.setFixedSize(Const.W, Const.H + 12);
		bg = new h2d.Sprite(s2d);
		bg.scale(2);
		var b1 = new h2d.Bitmap(Res.title.toTile(), bg);
		b = new h2d.Bitmap(Res.title2.toTile(), bg);

		alphaMap = b.addShader(new h3d.shader.AlphaMap(Res.clouds.toTexture()));

		b.color.set(0.4, 0.4, 0.4, 1);
		var t = new h2d.Bitmap(Res.titleText.toTile(), s2d);
		t.x = -40;
		t.y = -70;
		start = new h2d.Text(Res.Minecraftia.build(8, { antiAliasing : false } ), s2d);
		start.text = "Click to Start";
		start.x = Std.int((Const.W - start.textWidth) * 0.5);
		start.y = 250;
		start.visible = false;

		var i = new h2d.Interactive(Const.W, Const.H + 12, s2d);
		i.onRelease = function(_) {
			Res.sfx.confirm.play();
			i.remove();
			Game.inst = new Game(engine);
		};
	}

	override function update(dt) {
		time += dt;
		stime += dt;
		if( stime > 30 ) {
			start.visible = !start.visible;
			stime = 0;
		}
		var m = new h3d.Matrix();
		m.identity();
		m.colorContrast(-0.4);
		m.colorLightness(-0.2);
		b.colorMatrix = m;
		var a = time * 0.005;
		var px = Std.int(Math.cos(a) * Const.W * 0.5);
		var py = Std.int(Math.sin(a) * (Const.H - 30) * 0.5);
		bg.x = -(px + (Const.W >> 1));
		bg.y = -(py + (Const.H >> 1));
		alphaMap.uvDelta.x -= -0.6 * dt / alphaMap.texture.width;
		alphaMap.uvDelta.y += 0.2 * dt / alphaMap.texture.height;
		alphaMap.texture.wrap = Repeat;
	}

}