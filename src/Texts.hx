import Const;

class Texts {

	public static var WELCOME = [
		"Dear Princess,\nYour Hero has been captured by the Evil, and your Kingdom has vanished.\n",
		"You only have left one wheat seed...\nWill that be enough to finish the game?",
	];
	
	public static function BUILDPOS(b:BuildingKind) {
		return switch( b ) {
		case BFarmer: [21, 8, 3, 2, 21, 8, 2, 2];
		case BWheat: [20, 10, 3, 3, 20, 10, 3, 3];
		case BTavern: [7, 2, 6, 2, 8, 2, 4, 2];
		case BTower: [4, 10, 2, 4, 4, 10, 2, 4];
		case BDungeon: [14, 13, 4, 2, 15, 13, 2, 2];
		}
	}
	
	public static function ITEMNAME(i:Item) {
		return switch( i ) {
		case Seed: "Seed";
		case Wheat: "Wheat";
		case Beer: "Beer";
		case Soldier: "Soldier";
		case Gold: "Gold";
		}
	}
	
	public static function BUILDNAME(i:BuildingKind) {
		return switch( i  ) {
		case BFarmer: "Farm";
		case BWheat: "Wheat Field";
		case BTavern: "Tavern";
		case BTower: "Guards Tower";
		case BDungeon: "Dungeon";
		}
	}
	
}