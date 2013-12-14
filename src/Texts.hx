import Const;

class Texts {

	public static var WELCOME = [
		"Dear Princess,\nYour Hero has been captured by the Evil, and your Kingdom has vanished.\n",
		"You only have left one wheat seed...\nWill that be enough to finish the game?",
	];
	
	public static var BUILDINGS = [
		BFarmer => [
			"Farmer : I'm glad you are safe, your Majesty.\nI'm just a poor farmer but I'll help your the best I can.",
			"I'll plant these seeds for you",
			"Want food ?",
			"I'm tired of farming, but I'll make some efforts for your Majesty.",
		],
		BTavern => [
			"Uh Oh Princess! Ya got wheat? Will make booze for u, ok?",
			"Boooze ?",
			"My Queen is Booze. But I like you too.",
		],
	];
	
	public static function BUILDPOS(b:BuildingKind) {
		return switch( b ) {
		case BFarmer: [21, 8, 3, 2, 21, 8, 2, 2];
		case BWheat: [20, 10, 3, 3, 20, 10, 3, 3];
		case BTavern: [7, 2, 6, 2, 8, 2, 4, 2];
		}
	}
	
	public static function ITEMNAME(i:Item) {
		return switch( i ) {
		case Seed: "Seed";
		case Wheat: "Wheat";
		case Beer: "Beer";
		}
	}
	
	public static function BUILDNAME(i:BuildingKind) {
		return switch( i  ) {
		case BFarmer: "Farm";
		case BWheat: "Wheat Field";
		case BTavern: "Tavern";
		}
	}
	
}