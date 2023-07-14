package xGLfonts.structs;
@:structInit
class CharCoordinates {
    public var vertices: Array<Float>;
    public var pos:       Array<Float>;
    public function new( vertices: Array<Float>, pos: Array<Float> ){
        this.vertices = vertices;
        this.pos = pos;
    }
}