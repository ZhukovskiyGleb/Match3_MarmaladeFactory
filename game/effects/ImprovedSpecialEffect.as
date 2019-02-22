/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 30.05.14
 * Time: 10:58
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.effects
{
    import assets.effects.SpecialAsset;
    import assets.sounds.SpecialCreateSound;

    import com.greensock.TweenMax;
    import com.greensock.easing.Cubic;
    import com.levelupers.marmalade_factory.Game.modules.GameField;
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;
    import com.levelupers.marmalade_factory.configs.DelaysConfig;
    import com.levelupers.utils.sound.SoundManager;

    import flash.geom.Point;

    public class ImprovedSpecialEffect extends BaseImprovedEffect
    {
        private var _targetPoint:Point;

        public function ImprovedSpecialEffect()
        {
            _view = new SpecialAsset();
            addChild(_view);
            super();
        }

        override public function play():void
        {
            TweenMax.to(this, DelaysConfig.SPECIAL_FLY_DELAY, {x: _targetPoint.x, y: _targetPoint.y, ease: Cubic.easeInOut, onComplete: complete});
            SoundManager.play(SpecialCreateSound);
        }

        override public function stop():void
        {

        }

        override public function setData(params:Array):void
        {
            for each (var object:* in params)
            {
                if (object is BaseObjectModel)
                {
                    _targetPoint = GameField.getViewCoordinates((object as BaseObjectModel).position);
                    return;
                }
            }
        }
    }
}
