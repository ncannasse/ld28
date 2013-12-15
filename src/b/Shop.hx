package b;
import Const;

class Shop extends Building {

	var items : Map<Item,Item>;
	
	public function new() {
		super(BShop);
		items = [
			Ore => Plow,
			Diamond => Shoes,
			Fish => Cucumber,
		];
	}

	override function getTexts() {
		return [
			"Will trade anything you want for something you don't need, hopefully.",
			"Anything you wish to exchange, young mistress?",
		];
	}
	
	override function getActions() {
		var actions = new Array<Building.Action>();
		for( i in items.keys() ) {
			var get = items.get(i);
			actions.push({
				item : i,
				enable : game.has.bind(i),
				text : Texts.ITEMNAME(get),
				callb : function() {
					if( !game.checkAdd(get) )
						return;
					game.use(i);
					spawn(get);
				},
			});
		}
		return actions;
	}
}
