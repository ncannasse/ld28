
class Update {

	public function new() {
		Game.inst.updates.push(this);
	}
	
	public function stop() {
		Game.inst.updates.remove(this);
	}
	
	public dynamic function update(dt:Float) {
	}
	
}