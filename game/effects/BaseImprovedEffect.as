/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 30.05.14
 * Time: 10:57
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.effects
{
    import com.levelupers.marmalade_factory.events.GameEvent;

    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class BaseImprovedEffect extends MovieClip
    {
        protected var _view:Sprite;

        public function BaseImprovedEffect()
        {
            super();
        }

        public function setData(params:Array):void
        {

        }

        protected function complete():void
        {
            removeChild(_view);
            _view = null;
            dispatchEvent(new GameEvent(GameEvent.COMPLETE));
        }
    }
}
