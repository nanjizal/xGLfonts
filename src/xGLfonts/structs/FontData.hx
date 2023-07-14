package xGLfonts.structs;
import xGLfonts.structs.CharData;
// TODO: Consider magic.. how to parseJSON to FontData.
typedef FontDef = {
    var font: FontData;
}
@:structInit
class FontData {
    public var ix:           Float;
    public var iy:           Float;
    public var aspect:       Float;
    public var rowHeight:    Float;
    public var ascent:       Float;
    public var descent:      Float;
    public var lineGap:      Float;
    public var capHeight:    Float;
    public var xHeight:      Float;
    public var spaceAdvance: Float;
    public var chars:        haxe.ds.StringMap<CharData>;
    public var kern:         haxe.ds.StringMap<Float>;
    public function new( ix: Float, iy: Float
                       , aspect:        Float
                       , rowHeight:     Float
                       , ascent:        Float
                       , descent:        Float
                       , lineGap:       Float
                       , capHeight:     Float
                       , xHeight:       Float
                       , spaceAdvance:  Float
                       , chars:         haxe.ds.StringMap<CharData> 
                       , kern:          haxe.ds.StringMap<Float>
                       ){
        this.ix           = ix;
        this.iy           = iy;
        this.aspect       = aspect;
        this.rowHeight    = rowHeight;
        this.ascent       = ascent;
        this.descent      = descent;
        this.lineGap      = lineGap;
        this.capHeight    = capHeight;
        this.xHeight      = xHeight;
        this.spaceAdvance = spaceAdvance;
        this.chars        = chars;
        this.kern         = kern;
    }
}