package xGLfonts;
import xGLfonts.structs.FontMetric;
import xGLfonts.structs.FontData;
import xGLfonts.structs.CharCoordinates;
import xGLfonts.structs.CharData;
import xGLfonts.structs.WriteStrResult;

function fontMetrics( font:        FontData
                    , pixelSize:   Float
                    , moreLineGap: Float = 0.0 ): FontMetric {
    
    // We use separate scale for the low case characters
    // so that x-height fits the pixel grid.
    // Other characters use cap-height to fit to the pixels
    var capScale   = pixelSize / font.capHeight;
    var lowScale   = Math.round( font.xHeight * capScale ) / font.xHeight;
    
    // Ascent should be a whole number since it's used to calculate the baseline
    // position which should lie at the pixel boundary
    var ascent      = Math.round( font.ascent * capScale );
    
    // Same for the line height
    var lineHeight = Math.round( capScale * ( font.ascent + font.descent + font.lineGap ) + moreLineGap );
    
    return { capScale:   capScale,
             lowScale:   lowScale,
             pixelSize:  pixelSize,
             ascent:     ascent,
             lineHeight: lineHeight
           };
}


function charRect( pos:         Array<Float>
                 , font:        FontData
                 , fontMetrics: FontMetric
                 , fontChar:    CharData
                 , kern:        Float = 0.0 ): CharCoordinates {
    // Low case characters have first bit set in 'flags'
    var lowcase = ( fontChar.flags & 1 ) == 1;

    // Pen position is at the top of the line, Y goes up
    var baseline = pos[ 1 ] - fontMetrics.ascent;

    // Low case chars use their own scale
    var scale = lowcase ? fontMetrics.lowScale : fontMetrics.capScale;

    // Laying out the glyph rectangle
    var g      = fontChar.rect;
    var bottom = baseline - scale * ( font.descent + font.iy );
    var top    = bottom   + scale * ( font.rowHeight );
    var left   = pos[0]   + font.aspect * scale * ( fontChar.bearingX + kern - font.ix );
    var right  = left     + font.aspect * scale * ( g[2] - g[0] );
    var p: Array<Float> = [ left, top, right, bottom ];

    // Advancing pen position
    var newPosX = pos[0] + font.aspect * scale * ( fontChar.advanceX + kern );

    // Signed distance field size in screen pixels
    //var sdf_size  = 2.0 * font.iy * scale;

    var vertices: Array<Float> = [
        p[0], p[1],  g[0], g[1],  scale,
        p[2], p[1],  g[2], g[1],  scale,
        p[0], p[3],  g[0], g[3],  scale,

        p[0], p[3],  g[0], g[3],  scale,
        p[2], p[1],  g[2], g[1],  scale,
        p[2], p[3],  g[2], g[3],  scale ];

    return { vertices: vertices, pos : [ newPosX, pos[1] ] };
}

function writeString( str: String
                    , font: FontData
                    , fontMetrics: FontMetric
                    , pos: Array<Float>
                    , vertexArray: Array<Float>
                    , strPos:      Int = 0
                    , arrayPos:    Int = 0 ): WriteStrResult {
    var prevChar = " ";  // Used to calculate kerning
    var cpos      = pos;  // Current pen position
    var xMax     = 0.0;  // Max width - used for bounding box
    var scale     = fontMetrics.capScale;
    
    while( strPos < str.length ){
        var glyphFloatCount = 6 * 5; // two rectangles, 5 floats per vertex
        if ( arrayPos + glyphFloatCount >= vertexArray.length ) break;
        
        var schar = str.charAt( strPos );
        strPos++;
        
        if( schar == "\n" ) {
            if ( cpos[0] > xMax ) xMax = cpos[0]; // Expanding the bounding rect
            cpos[0]  = pos[0];                      
            cpos[1] -= fontMetrics.lineHeight;
            prevChar = " ";
            continue;
        }

        if( schar == " " ) {
            cpos[0] += font.spaceAdvance * scale; 
            prevChar = " ";
            continue;
        }
        // Substituting unavailable characters with '?'
        var replacmentChar = '?';// ' ';
        var fontChar = if( font.chars.exists( schar ) ){
            font.chars.get( schar );
        } else {
            font.chars.get( replacmentChar );
        }
        var kernKey = prevChar + schar;
        var kern = if( font.kern.exists( kernKey ) ){
            font.kern.get( kernKey );
        } else {
            0.0;
        }
        
        // calculating the glyph rectangle and copying it to the vertex array
        
        var rect = charRect( cpos, font, fontMetrics, fontChar, kern );
        
        for( i in 0...rect.vertices.length ) {
            vertexArray[ arrayPos ] = rect.vertices[ i ];
            arrayPos++;
        }

        prevChar = schar;
        cpos = rect.pos;
    }
    
    return {
        rect: [ pos[0], pos[1], xMax - pos[0], pos[1] - cpos[1] + fontMetrics.lineHeight ],
        stringPos: strPos,
        arrayPos: arrayPos
    };
}

class TextUtils {
    public function new(){}
    public static
    function fontMetrics( font:        FontData
                        , pixelSize:   Float
                        , moreLineGap: Float = 0.0 ): FontMetric {
        return fontMetrics( font, pixelSize, moreLineGap );
    }
    public static
    function charRect( pos:         Array<Float>
                    , font:        FontData
                    , fontMetrics: FontMetric
                    , fontChar:    CharData
                    , kern:        Float = 0.0 ): CharCoordinates {
        return charRect( pos, font, fontMetrics, fontChar, kern );
    }
    public static
    function writeString( str: String
        , font: FontData
        , fontMetrics: FontMetric
        , pos: Array<Float>
        , vertexArray: Array<Float>
        , strPos:      Int = 0
        , arrayPos:    Int = 0 ): WriteStrResult {
        return writeString( str, font, fontMetrics, pos, vertexArray, strPos, arrayPos );
    }
}
//https://github.com/astiopin/webgl_fonts/blob/master/src/main.js