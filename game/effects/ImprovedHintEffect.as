/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 03.06.14
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.effects
{
    import assets.effects.MedleyAsset;

    import com.greensock.TweenMax;
    import com.greensock.easing.Cubic;
    import com.levelupers.marmalade_factory.configs.EffectsConfig;
    import com.levelupers.marmalade_factory.utils.TFSearcher;

    import flash.display.MovieClip;
    import flash.filters.GlowFilter;

    public class ImprovedHintEffect extends BaseImprovedEffect
    {
        private var _text:String;
        private var _color:uint;

        public function ImprovedHintEffect()
        {
            super();
        }

        override public function play():void
        {
            if (_text == EffectsConfig.MEDLEY_EFFECT)
            {
                _view = new MedleyAsset();
                _view.filters = [new GlowFilter(0xFFFFFF, 1, 10, 10)];
            }
            else
            {
                _view = new (EffectsConfig.HINT_ASSETS[_color] as Class)() as MovieClip;
                TFSearcher.findInObject(_view).text = _text;
            }
            addChild(_view);

            _view.scaleX = _view.scaleY = 0;
            TweenMax.to(_view, .25, {scaleX: .8, scaleY: .8});
            TweenMax.to(_view, 1.0, {delay: .25, y: -25, onComplete: complete});
            TweenMax.to(_view, 0.5, {delay: .75, alpha: 0, ease: Cubic.easeOut});
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
                }
                else if (object is String)
                {
                    _text = String(object);
                }
            }
        }
    }
}
