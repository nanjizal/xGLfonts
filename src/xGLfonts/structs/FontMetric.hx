package xGLfonts.structs;

@:structInit
class FontMetric{
    public var capScale:   Float;
    public var lowScale:   Float;
    public var pixelSize:  Float; // may need to be Int
    public var ascent:     Int;
    public var lineHeight: Int;
    public function new( capScale:   Float
                       , lowScale:   Float
                       , pixelSize:  Float
                       , ascent:     Int
                       , lineHeight: Int ){
        this.capScale   = capScale;
        this.lowScale   = lowScale;
        this.pixelSize  = pixelSize;
        this.ascent     = ascent;
        this.lineHeight = lineHeight;
    }
}

