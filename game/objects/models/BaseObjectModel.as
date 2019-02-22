/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 14:39
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.objects.models
{
    import com.levelupers.marmalade_factory.events.GameData;
    import com.levelupers.marmalade_factory.events.GameEvent;

    import flash.events.EventDispatcher;
    import flash.geom.Point;

    public class BaseObjectModel extends EventDispatcher
    {
        public static const SELECTION_ON        :String = 'selectionOn';
        public static const SELECTION_OFF       :String = 'selectionOff';
        public static const SELECTION_GLOW      :String = 'selectionGlow';

        private var _position                   :Point;
        private var _color                      :uint;
        private var _readyForDelete             :Boolean;

        public function BaseObjectModel(color:uint)
        {
            _color = color;

            _readyForDelete = false;
        }

        public function updatePosition(posX:uint, posY:uint, delay:Number = .0, event:String = null):void
        {
            if (!_position || _position.x != posX || _position.y != posY)
                setPosition(posX, posY);

            if (event)
                dispatchEvent(new GameEvent(event, new GameData(delay)));
        }

        public function destroy(delay:Number = .0, playSound:Boolean = true):void
        {
            clear();

            if (playSound)
                dispatchEvent(new GameEvent(GameEvent.DESTROY_OBJECT, new GameData(delay)));
            else
                dispatchEvent(new GameEvent(GameEvent.DELETE_OBJECT, new GameData(delay)));
        }

        public function clear():void
        {
            _readyForDelete = true;
        }

        public function showHideView(value:Boolean):void
        {
            if (value)
                dispatchEvent(new GameEvent(GameEvent.SHOW_OBJECT));
            else
                dispatchEvent(new GameEvent(GameEvent.HIDE_OBJECT));
        }

        public function addSelection(type:String):void
        {
            switch (type)
            {
                case SELECTION_ON:
                    dispatchEvent(new GameEvent(GameEvent.ADD_SELECTION));
                    break;
                case SELECTION_OFF:
                    dispatchEvent(new GameEvent(GameEvent.REMOVE_SELECTION));
                    break;
                case SELECTION_GLOW:
                    dispatchEvent(new GameEvent(GameEvent.REMOVE_SELECT_ANIMATION));
                    break;
            }
        }

        protected function setPosition(posX:uint, posY:uint):void
        {
            _position = new Point(posX, posY);
        }

        public function get color():uint
        {
            return _color;
        }

        public function get position():Point
        {
            return _position;
        }

        public function get readyForDelete():Boolean
        {
            return _readyForDelete;
        }

        public function playWaitIdle():void
        {
            dispatchEvent(new GameEvent(GameEvent.PLAY_WAIT_IDLE));
        }
    }
}
