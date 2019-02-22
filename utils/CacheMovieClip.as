/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 03.06.14
 * Time: 16:52
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.utils
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getDefinitionByName;

    public dynamic class CacheMovieClip extends Sprite {
        private var clip:MovieClip;
        private var bmp:Bitmap;
        public var frames:Vector.<BitmapData>;
        public var offsets:Vector.<Point>;
        public var labels:Vector.<String>;
        public var currentFrame:int;

        public function CacheMovieClip() {
            clip = null;
            addChild(bmp = new Bitmap());
            frames = new Vector.<BitmapData>();
            offsets = new Vector.<Point>();
            labels = new Vector.<String>();
            currentFrame = 1;
        }
        public function free():void {
            if (parent != null) parent.removeChild(this);
            clip = null;
            removeChild(bmp);
            bmp = null;
            frames = null;
            offsets = null;
            labels = null;
        }

        public function buildFromLibrary(className:String):void {
            var cls:Class = getDefinitionByName(className) as Class;
            if(cls != null) buildFromClip(new cls());
        }
        public function buildFromClip(Clip:MovieClip):void {
            if (Clip == null) throw("Clip not found.");
            if (clip != null) {
                clip = null;
                frames = new Vector.<BitmapData>();
                offsets = new Vector.<Point>();
            }

            clip = Clip;
            var r:Rectangle;
            var bd:BitmapData;
            var m:Matrix = new Matrix();

            var i:int;
            var len:int = clip.totalFrames;
            for (i = 1; i <= len; ++i) {
                clip.gotoAndStop(i);
                r = clip.getBounds(clip);
                bd = new BitmapData(Math.max(1, r.width), Math.max(1, r.height), true, 0x00000000);
                m.identity();
                m.translate(-r.x, -r.y);
                m.scale(clip.scaleX, clip.scaleY);
                bd.draw(clip, m);
                frames.push(bd);
                offsets.push(new Point(r.x * clip.scaleX, r.y * clip.scaleY));
                labels.push(clip.currentLabel);
            }

            gotoAndStop(1);
        }

        public function get totalFrames():int {
            return frames.length;
        }
        public function get currentLabel():String {
            if(totalFrames == 0) return "";
            return labels[currentFrame - 1];
        }


        public function gotoAndStop(frame:int):void {
            if (totalFrames == 0) return;
            currentFrame = Math.max(1, Math.min(totalFrames, frame));
            bmp.bitmapData = frames[currentFrame - 1];
            bmp.x = offsets[currentFrame - 1].x;
            bmp.y = offsets[currentFrame - 1].y;
        }

        public function nextFrame():void
        {
            if (totalFrames == 0) return;
            var nextFrame:uint = currentFrame + 1;
            if (nextFrame > totalFrames)
                nextFrame = 1;
            gotoAndStop(nextFrame);
        }

        /* STATIC */
        static private var clips:Object = { };

        static public function getClip(Name:String):CacheMovieClip {
            if(clips[Name] == null) {
                var m:CacheMovieClip = new CacheMovieClip();
                m.buildFromLibrary(Name);
                clips[Name] = m;
            }

            var clip:CacheMovieClip = new CacheMovieClip();
            clip.frames = clips[Name].frames;
            clip.offsets = clips[Name].offsets;
            clip.labels = clips[Name].labels;
            clip.gotoAndStop(1);
            return clip;
        }
    }
}
