/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 11:18
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.views
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;

    public class BaseWindowView extends Sprite
    {
        public function BaseWindowView()
        {
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }

        public function clear():void
        {

        }

        protected function addedToStageHandler(event:Event):void
        {
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

            scrollRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        }
    }
}
