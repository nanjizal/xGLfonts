package xGLfonts.structs;

@:structInit
class WriteStrResult {
    public var rect:      Array<Float>;
    public var stringPos: Int;
    public var arrayPos:  Int;
    public function new( rect:      Array<Float>
                       , stringPos: Int
                       , arrayPos:  Int ){
        this.rect      = rect;
        this.stringPos = stringPos;
        this.arrayPos  = arrayPos;
    }
}