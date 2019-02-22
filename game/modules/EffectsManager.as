/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 29.05.14
 * Time: 13:58
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.modules
{
    import com.greensock.TweenMax;
    import com.levelupers.marmalade_factory.Game.effects.BaseImprovedEffect;
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;
    import com.levelupers.marmalade_factory.configs.EffectsConfig;
    import com.levelupers.marmalade_factory.events.GameEvent;

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.geom.Point;

    public class EffectsManager extends GameField
    {
        private const EFFECTS_MAP:Object =
        {
            (EffectsConfig.TYPE_SPLASH.toString())      : EffectsConfig.SPLASH_EFFECT,
            (EffectsConfig.TYPE_MIX.toString())         : EffectsConfig.MIX_EFFECT,
            (EffectsConfig.TYPE_SPECIAL.toString())     : EffectsConfig.SPECIAL_EFFECT,
            (EffectsConfig.TYPE_HINT.toString())        : EffectsConfig.HINT_EFFECT
        };

        protected var _effectViews:Vector.<MovieClip>;

        public function EffectsManager()
        {
            _effectViews = new Vector.<MovieClip>();
            super();
        }

        public function addEffect(effect:String, object:BaseObjectModel = null, delay:Number = .0, improvedParams:Array = null):void
        {
            var view:MovieClip;
            if (object && EFFECTS_MAP[effect][object.color])
                view = new (EFFECTS_MAP[effect][object.color] as Class)() as MovieClip;
            else
                view = new (EFFECTS_MAP[effect] as Class)() as MovieClip;

            _effectViews.push(view);

            view.stop();
            view.visible = false;

            if (improvedParams)
                (view as BaseImprovedEffect).setData(improvedParams);

            var position:Point;
            if (object)
            {
                _effectsLayer.addChild(view);
                position = getViewCoordinates(object.position);
            }
            else
            {
                position = new Point(POSITION.x, POSITION.y);
                _globalEffectsLayer.addChild(view);
            }

            view.x = position.x;
            view.y = position.y;

            TweenMax.to(view, delay, {onComplete: showEffect, onCompleteParams: [view]});
        }

        private function showEffect(view:MovieClip):void
        {
            view.visible = true;
            view.play();

            if (view is BaseImprovedEffect)
                view.addEventListener(GameEvent.COMPLETE, view_completeEventHandler);
            else
                view.addEventListener(Event.ENTER_FRAME, view_enterFrameHandler);
        }

        private function removeEffect(view:MovieClip):void
        {
            if (view is BaseImprovedEffect)
                view.removeEventListener(GameEvent.COMPLETE, view_completeEventHandler);
            else
                view.removeEventListener(Event.ENTER_FRAME, view_enterFrameHandler);

            if (view.parent)
                view.parent.removeChild(view);

            if (_effectViews)
                _effectViews.splice(_effectViews.indexOf(view), 1);

            view = null;
        }

        private function view_enterFrameHandler(event:Event):void
        {
            var view:MovieClip = event.currentTarget as MovieClip;

            if (view.currentFrame == view.totalFrames)
            {
                removeEffect(view);
            }
        }

        private function view_completeEventHandler(event:GameEvent):void
        {
            removeEffect(event.currentTarget as MovieClip);
        }

        override public function clear():void
        {
            for each (var view:MovieClip in _effectViews)
            {
                removeEffect(view);
            }

            _effectViews = null;

            super.clear();
        }
    }
}
