package b;
import Const;

class Builder extends Building {

	var buildings : Map< BuildingKind, { item : Item, n : Int, ?req : BuildingKind } >;
	
	public function new() {
		super(BBuilder);
		buildings = [
			BWoodCutter => { item : Gold, n : 1 },
			BMiner => { item : Gold, n : 2 },
			BShop => { item : Wood, n : 3, req : BWoodCutter },
		];
	}
	
	override function getTexts() {
		return [
			"In exchance for furnitures I'll set new buildings for your Highness.\nYou can spend resources in several times.",
			"Where do you want to spend your furnitures, your Highness?",
			"One day I'll build a Palace for you, your Highness.",
		];
	}
			
	override function getActions() {
		var actions = new Array<Building.Action>();
		for( b in buildings.keys() ) {
			if( game.buildings.exists(b) ) continue;
			var inf = buildings.get(b);
			if( inf.req != null && !game.buildings.exists(inf.req) ) continue;
			actions.push({
				item : inf.item,
				text : "x" + inf.n + " " + Texts.BUILDNAME(b),
				enable : game.has.bind(inf.item),
				callb : function() {
					game.use(inf.item);
					inf.n--;
					if( inf.n == 0 )
						game.unlockBuilding(b);
					else
						game.announce("The build of " + Texts.BUILDNAME(b) + " has progressed", 0x00FF00);
				},
			});
		}
		return actions;
	}
	
}