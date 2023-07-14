package xGLfonts.structs;
/*
@:structInit
class CharRect{
    public var x: Float;
    public var y: Float;
    public var width: Float;
    public var height: Float;
    public function new( x: Float, y: Float, width: Float, height: Float ){
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}
*/
@:structInit
class CharData{
    public var codePoint: Int; 
    public var rect: Array<Float>;
    public var bearingX: Float; 
    public var bearingY: Float;
    public var advanceX: Float; 
    public var flags: Int; //?
    public function new( codePoint:   Int
                       , rect:        Array<Float>
                       , bearingX:    Float
                       , bearingY:    Float
                       , advanceX:    Float
                       , flags:       Int ){
        this.codePoint  = codePoint;
        this.rect       = rect;
        this.bearingX   = bearingX;
        this.bearingY   = bearingY;
        this.advanceX   = advanceX;
        this.flags      = flags;
    }
}