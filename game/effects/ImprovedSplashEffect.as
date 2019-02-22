/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 03.06.14
 * Time: 17:17
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.effects
{
    import com.levelupers.marmalade_factory.configs.EffectsConfig;
    import com.levelupers.marmalade_factory.utils.CacheMovieClip;

    import flash.events.Event;

    import flash.utils.getQualifiedClassName;

    public class ImprovedSplashEffect extends BaseImprovedEffect
    {
        private var _color:uint;

        public function ImprovedSplashEffect()
        {
            super();
        }

        override public function play():void
        {
            var cache:CacheMovieClip = new CacheMovieClip();
            cache.buildFromLibrary(getQualifiedClassName(EffectsConfig.SPLASH_ASSETS[_color] as Class));

            _view = cache;
            addChild(_view);

            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }

        override public function stop():void
        {

        }

        override public function setData(params:Array):void
        {
            for each (var object:* in params)
            {
                if (object is uint)
                {
                    _color = uint(object);
                    return;
                }
            }
        }

        private function enterFrameHandler(event:Event):void
        {
            if ((_view as CacheMovieClip).currentFrame >= (_view as CacheMovieClip).totalFrames)
            {
                removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
                complete();
            }
            else
                (_view as CacheMovieClip).gotoAndStop((_view as CacheMovieClip).currentFrame + 1);
        }
    }
}
