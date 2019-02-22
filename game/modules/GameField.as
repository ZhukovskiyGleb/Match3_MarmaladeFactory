/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 12:58
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.modules
{
    import assets.fields.Field6Asset;
    import assets.fields.Field7Asset;
    import assets.fields.Field8Asset;
    import assets.fields.Field9Asset;
    import assets.sounds.LevelDoneSound;

    import com.greensock.TweenMax;
    import com.greensock.easing.Back;
    import com.greensock.easing.Expo;
    import com.levelupers.marmalade_factory.configs.DelaysConfig;
    import com.levelupers.marmalade_factory.configs.GameConfig;
    import com.levelupers.marmalade_factory.events.GameData;
    import com.levelupers.marmalade_factory.events.GameEvent;
    import com.levelupers.utils.sound.SoundManager;

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class GameField extends Sprite
    {
        protected static const POSITION      :Point = new Point(500, 300);
        protected static const MINIMIZED_SIZE:Point = new Point(150, 150);

        private const FIELD_ASSETS  :Object =
        {
            6: Field6Asset,
            7: Field7Asset,
            8: Field8Asset,
            9: Field9Asset
        };

        private var _view                   :Sprite;
        protected var _effectsLayer         :Sprite;
        protected var _globalEffectsLayer   :Sprite;
        protected var _objectsLayer         :Sprite;
        protected var _connectorsLayer      :Sprite;
        protected var _specialTargetsLayer  :Sprite;

        protected var _objectsMask          :Sprite;
        protected var _targetsMask          :Sprite;

        private var _moveState              :Boolean = false;

        private var _prevMousePosition      :Point;

        protected static var _fieldSize              :uint;

        public static function getViewCoordinates(position:Point):Point
        {
            return new Point(
                    (position.x - _fieldSize / 2 + .5) * GameConfig.CELL_SIZE,
                    (position.y - _fieldSize / 2 + .5) * GameConfig.CELL_SIZE
            );
        }

        public function GameField()
        {
            _specialTargetsLayer        = addChild(new Sprite()) as Sprite;
            _connectorsLayer            = addChild(new Sprite()) as Sprite;
            _objectsLayer               = addChild(new Sprite()) as Sprite;
            _effectsLayer               = addChild(new Sprite()) as Sprite;
            _globalEffectsLayer         = addChild(new Sprite()) as Sprite;

            addEventListener(MouseEvent.MOUSE_DOWN, mouseActionHandler);
            addEventListener(MouseEvent.MOUSE_MOVE, mouseActionHandler);
            addEventListener(MouseEvent.MOUSE_UP,   mouseActionHandler);

            mouseChildren       = false;
        }

        public function updateSize(size:uint):void
        {
            var prevSize:Point;
            _fieldSize = size;

            if (_view)
            {
                prevSize = new Point(_view.width, _view.height);
                removeChild(_view);
            }

            _view = new (FIELD_ASSETS[size] as Class)() as Sprite;
            addChildAt(_view, 0);

            _view.x = POSITION.x;
            _view.y = POSITION.y;

            if (prevSize)
            {
                _view.width = prevSize.x;
                _view.height = prevSize.y;
                TweenMax.to(_view, DelaysConfig.MINIMIZE_FIELD_DELAY, {width: MINIMIZED_SIZE.x, height: MINIMIZED_SIZE.y, ease: Back.easeIn, onComplete: maximizeField});
                TweenMax.to(_objectsLayer, DelaysConfig.MINIMIZE_FIELD_DELAY, {width: MINIMIZED_SIZE.x, ease: Back.easeIn, height: MINIMIZED_SIZE.y});
            }

            _specialTargetsLayer.x = _effectsLayer.x = _connectorsLayer.x = _objectsLayer.x = POSITION.x;
            _specialTargetsLayer.y = _effectsLayer.y = _connectorsLayer.y = _objectsLayer.y = POSITION.y;

            _objectsMask = new Sprite();

            _objectsMask.graphics.beginFill(0xFFFFFF);
            _objectsMask.graphics.drawRect(fieldPointX - 5, fieldPointY - 5, _fieldSize * GameConfig.CELL_SIZE + 10, _fieldSize * GameConfig.CELL_SIZE + 10);
            _objectsMask.graphics.endFill();

            _objectsLayer.mask = _objectsMask;

            _targetsMask = new Sprite();

            _targetsMask.graphics.beginFill(0xFFFFFF);
            _targetsMask.graphics.drawRoundRect(fieldPointX, fieldPointY, _fieldSize * GameConfig.CELL_SIZE - 1, _fieldSize * GameConfig.CELL_SIZE, 15, 15);
            _targetsMask.graphics.endFill();

            _specialTargetsLayer.mask = _targetsMask;
        }

        private function maximizeField():void
        {
            SoundManager.play(LevelDoneSound);
            TweenMax.to(_view, DelaysConfig.MAXIMIZE_FIELD_DELAY, {delay: DelaysConfig.SHUFFLING_FIELD_DELAY, scaleX: 1, scaleY: 1});
            TweenMax.to(_objectsLayer, DelaysConfig.MAXIMIZE_FIELD_DELAY, {delay: DelaysConfig.SHUFFLING_FIELD_DELAY, scaleX: 1, scaleY: 1});
        }

        public function clear():void
        {
            removeChild(_view);
            _view = null;

            removeChild(_objectsLayer);
            _objectsLayer = null;

            removeChild(_connectorsLayer);
            _connectorsLayer = null;

            removeChild(_effectsLayer);
            _effectsLayer = null;

            removeChild(_specialTargetsLayer);
            _specialTargetsLayer = null;

            removeEventListener(MouseEvent.MOUSE_DOWN, mouseActionHandler);
            removeEventListener(MouseEvent.MOUSE_MOVE, mouseActionHandler);
            removeEventListener(MouseEvent.MOUSE_UP,   mouseActionHandler);
        }

        protected static function get fieldPointX():uint
        {
            return POSITION.x - _fieldSize * GameConfig.CELL_SIZE * .5;
        }

        protected static function get fieldPointY():uint
        {
            return POSITION.y - _fieldSize * GameConfig.CELL_SIZE * .5;
        }

        protected function calculateMousePosition(stageX:Number, stageY:Number, type:String):Point
        {
            var posX:uint = (stageX - fieldPointX) / GameConfig.CELL_SIZE;
            var posY:uint = (stageY - fieldPointY) / GameConfig.CELL_SIZE;

            if (_prevMousePosition && _prevMousePosition.x == posX && _prevMousePosition.y == posY)
                return null;

            if (posX >= _fieldSize)
                posX = _fieldSize - 1;

            var maxX:int = (posX + 1) * GameConfig.CELL_SIZE - (stageX - fieldPointX);

            if (type == GameEvent.FIELD_MOVE && (maxX > GameConfig.CELL_SIZE * (1 - GameConfig.CELL_CLICK_PENALTY) || maxX < GameConfig.CELL_SIZE * GameConfig.CELL_CLICK_PENALTY))
                return null;

            if (posY >= _fieldSize)
                posY = _fieldSize - 1;

            var maxY:int = (posY + 1) * GameConfig.CELL_SIZE - (stageY - fieldPointY);

            if (type == GameEvent.FIELD_MOVE && (maxY > GameConfig.CELL_SIZE * (1 - GameConfig.CELL_CLICK_PENALTY) || maxY < GameConfig.CELL_SIZE * GameConfig.CELL_CLICK_PENALTY))
                return null;

            return new Point(posX, posY);
        }

        protected function mouseActionHandler(event:MouseEvent):void
        {
            var eventName:String;
            if (event.type == MouseEvent.MOUSE_DOWN)
            {
                _moveState = true;
                eventName = GameEvent.FIELD_PRESS;
            }
            else if (event.type == MouseEvent.MOUSE_UP)
            {
                _moveState = false;
                eventName = GameEvent.FIELD_RELEASE;
                _prevMousePosition = null;
            }
            else
            {
                if (!_moveState)
                    return;
                eventName = GameEvent.FIELD_MOVE;
            }

            var position:Point = calculateMousePosition(event.stageX, event.stageY, eventName);

            if (!position)
                return;

            if (eventName != GameEvent.FIELD_RELEASE)
                _prevMousePosition = position;

            dispatchEvent(
                    new GameEvent(
                            eventName,
                            new GameData(position)
                    )
            );
        }
    }
}
