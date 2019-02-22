/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 14:24
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.models
{
    import com.greensock.TweenMax;
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.HorisontalObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.SimpleObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.VerticalObjectModel;
    import com.levelupers.marmalade_factory.configs.DelaysConfig;
    import com.levelupers.marmalade_factory.configs.EffectsConfig;
    import com.levelupers.marmalade_factory.configs.GameConfig;
    import com.levelupers.marmalade_factory.configs.ObjectsConfig;
    import com.levelupers.marmalade_factory.events.GameData;
    import com.levelupers.marmalade_factory.events.GameEvent;
    import com.levelupers.marmalade_factory.utils.Analytics;

    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.utils.Timer;

    public class PuzzleModel extends ServicesModel
    {

        protected var _lockControl          :Boolean;
        protected var _animateTimer         :Timer;
        protected var _specialModels        :Vector.<BaseObjectModel>;

        protected var _level                :uint;
        protected var _score                :uint;
        protected var _moves                :uint;

        public function PuzzleModel()
        {
            _specialModels = new Vector.<BaseObjectModel>();
            unlockControl();
        }

        override public function clear():void
        {
            for (var i:uint = 0; i < _fieldSize; i++)
            {
                for (var j:uint = 0; j < _fieldSize; j++)
                {
                    _field[i][j].destroy(0, false);
                }
            }

            setWaitingTimer(false);

            _animateTimer = null;

            super.clear();
        }

        protected function updateFieldSize(fieldNum:uint = 0):void
        {
            if (GameConfig.FIELD_SIZES.length <= fieldNum)
                return;

            var size:uint = GameConfig.FIELD_SIZES[fieldNum];

            var prevSize:uint = _fieldSize;

            if (GameConfig.FIELD_SIZES.indexOf(size) == -1)
                throw new Error('Incorrect field size!');

            _fieldSize = size;

            _availableColors = GameConfig.AVAILABLE_COLORS[fieldNum];

            dispatchEvent(new GameEvent(GameEvent.UPDATE_FIELD_SIZE, new GameData(size)));

            var i:uint;
            var j:uint;
            var createTime:Number = .0;

            if (_field)
            {
                var specials:uint;
                for (i = 0; i < prevSize; i++)
                {
                    for (j = 0; j < prevSize; j++)
                    {
                        _field[i][j].destroy(DelaysConfig.MINIMIZE_FIELD_DELAY, false);
                        if (_field[i][j] is VerticalObjectModel || _field[i][j] is HorisontalObjectModel)
                            specials ++;
                    }
                }
                addEffect(EffectsConfig.TYPE_MIX, null, DelaysConfig.MINIMIZE_FIELD_DELAY / 2);
                createTime = DelaysConfig.MINIMIZE_FIELD_DELAY;
            }
            var object:BaseObjectModel;
            _field = new Vector.<Vector.<BaseObjectModel>>();
            for (i = 0; i < _fieldSize; i++)
            {
                _field[i] = new Vector.<BaseObjectModel>();
                for (j = 0; j < _fieldSize; j++)
                {
                    object = createSimpleObject();
                    object.updatePosition(i, j);
                    setObject(object, createTime, GameEvent.CREATE_OBJECT_AT_PLACE);
                }
            }

            var emptySpaces:uint = getEmptySpaces();
            while (specials > 0 && emptySpaces > 0)
            {
                do
                {
                    var posX:uint = Math.random() * _fieldSize;
                    var posY:uint = Math.random() * _fieldSize;
                }
                while(!(_field[posX][posY] is SimpleObjectModel));

                if (Math.random() < .5)
                    object = new VerticalObjectModel(_field[posX][posY].color);
                else
                    object = new HorisontalObjectModel(_field[posX][posY].color);

                _field[posX][posY].destroy(DelaysConfig.MINIMIZE_FIELD_DELAY, false);
                object.updatePosition(posX, posY);
                setObject(object, DelaysConfig.MINIMIZE_FIELD_DELAY, GameEvent.CREATE_OBJECT_AT_PLACE);

                specials --;
                emptySpaces --;
            }
        }

        protected function destroyObjects(targets:Vector.<BaseObjectModel>):void
        {
            var delay:Number = DelaysConfig.DESTROY_DELAY;

            for each (var object:BaseObjectModel in targets)
            {
                object.destroy(delay);
                addEffect(EffectsConfig.TYPE_SPLASH, object, delay, [object.color]);
                delay += DelaysConfig.DESTROY_DELAY;
            }

            decreaseTurns();
            lockControl();

            TweenMax.to(this, delay + .1, {onComplete: dropObjects});
        }

        private function dropObjects():void
        {
            var maxDelay:Number = .0;
            var object:BaseObjectModel;

            for (var i:uint = 0; i < _fieldSize; i++)
            {
                var dropLength:uint = shiftColumn(i);
                var delay:Number = DelaysConfig.DROP_START_DELAY + dropLength * DelaysConfig.DROP_ADD_DELAY;
                maxDelay = Math.max(maxDelay, delay);
                for (var j:uint = 0; j < dropLength; j++)
                {
                    if (_field[i][j] == null)
                    {
                        object = createSimpleObject();
                        var position:Point = new Point(i, j - dropLength);
                        object.updatePosition(i, j);
                        setObject(object, 0, GameEvent.CREATE_OBJECT, position);
                        object.updatePosition(i, j, delay, GameEvent.DROP_OBJECT);
                    }
                }
            }
            maxDelay += .1;
            var addDelay:Number = .0;
            var emptySpaces:uint = getEmptySpaces();
            var targetObject:BaseObjectModel;
            while (_specialModels.length > 0 && emptySpaces > 0)
            {
                addDelay = DelaysConfig.SPECIAL_FLY_DELAY;
                do
                {
                    var posX:uint = Math.random() * _fieldSize;
                    var posY:uint = Math.random() * _fieldSize;
                    targetObject = getObject(posX, posY);
                }
                while (!(targetObject is SimpleObjectModel) || (targetObject.position.x == _specialModels[0].position.x && targetObject.position.y == _specialModels[0].position.y));

                addEffect(EffectsConfig.TYPE_SPECIAL, _specialModels[0], maxDelay, [targetObject]);

                dispatchEvent(new GameEvent(GameEvent.REMOVE_SPECIAL, new GameData(_specialModels[0], maxDelay)));
                _specialModels.shift();

                targetObject.destroy(addDelay + maxDelay);

                var specialObject:BaseObjectModel = createSpecialObject(targetObject.color);
                specialObject.updatePosition(targetObject.position.x, targetObject.position.y);
                setObject(specialObject, addDelay + maxDelay, GameEvent.CREATE_OBJECT_AT_PLACE);

                emptySpaces --;
            }

            if (!checkForEndGame(addDelay + maxDelay))
            {
                addDelay += checkLevelDone(addDelay + maxDelay);
                TweenMax.to(this, addDelay + maxDelay, {onComplete:checkForStalemate});
            }

            dispatchEvent(new GameEvent(GameEvent.UPDATE_DEPTHS));
        }

        private function checkForStalemate():void
        {
            var result:Boolean = false;
            mainCycle: for (var i:uint = 0; i < _fieldSize; i++)
            {
                for (var j:uint = 0; j < _fieldSize; j++)
                {
                    var equals:uint = 0;
                    for each (var side:Array in ObjectsConfig.SIDES)
                    {
                        var posX:int = i + side[0];
                        var posY:int = j + side[1];

                        if (posX < 0 || posX >= _fieldSize || posY < 0 || posY >= _fieldSize)
                            continue;

                        if (_field[posX][posY].color == _field[i][j].color)
                            equals ++;

                        if (equals >= 2)
                        {
                            result = true;
                            break mainCycle;
                        }
                    }
                }
            }
            if (result)
                unlockControl();
            else
                stalemateShuffle();
        }

        private function stalemateShuffle():void
        {
            var maxDelay:Number = .0;
            var object:BaseObjectModel;
            for (var i:uint = 0; i < _fieldSize; i++)
            {
                for (var j:uint = 0; j < _fieldSize; j++)
                {
                    do
                    {
                        var posX:uint = Math.random() * _fieldSize;
                        var posY:uint = Math.random() * _fieldSize;
                    }
                    while (posX == i && posY == j);

                    var deltaX:int = posX - i;
                    var deltaY:int = posY - j;
                    var delay:Number = Math.sqrt((deltaX * deltaX) + (deltaY * deltaY)) * .1;
                    maxDelay = Math.max(delay, maxDelay);

                    object = _field[posX][posY];
                    _field[i][j].updatePosition(posX, posY, delay, GameEvent.MOVE_OBJECT);
                    object.updatePosition(i, j, delay, GameEvent.MOVE_OBJECT);
                    _field[posX][posY] = _field[i][j];
                    _field[i][j] = object;
                }
            }
            TweenMax.to(this, maxDelay, {onComplete:checkForStalemate});
        }

        private function checkLevelDone(delay:Number):Number
        {
            if (_score < GameConfig.SCORE_FOR_LEVEL[_level])
                return .0;

            var nextSize:uint = _level;
            if (nextSize < GameConfig.FIELD_SIZES.length)
            {
                TweenMax.to(this, delay + .1, {onComplete: updateFieldSize, onCompleteParams: [nextSize]});
                levelUp();
                return DelaysConfig.MINIMIZE_FIELD_DELAY + DelaysConfig.SHUFFLING_FIELD_DELAY + DelaysConfig.MAXIMIZE_FIELD_DELAY;
            }
            return .0;
        }

        private function checkForEndGame(delay:Number):Boolean
        {
            if (_moves <= 0)
            {
                TweenMax.to(this, delay, {onComplete: finisGame});
                return true;
            }

            return false;
        }

        protected function finisGame(specials:Vector.<BaseObjectModel> = null):void
        {

        }

        private function lockControl():void
        {
            _lockControl = true;
//            Mouse.hide();
        }

        private function  unlockControl():void
        {
            _lockControl = false;
//            Mouse.show();
        }

        protected function setWaitingTimer(activate:Boolean):void
        {
            if (activate)
            {
                _animateTimer = new Timer(GameConfig.MIN_WAIT_TIME + uint(Math.random() * GameConfig.ADD_WAIT_TIME), 1);
                _animateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, animateTimer_timerCompleteHandler);
                _animateTimer.start();
            }
            else if (_animateTimer)
            {
                _animateTimer.stop();
                _animateTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, animateTimer_timerCompleteHandler);
                _animateTimer = null;
            }

        }

        protected function setObject(object:BaseObjectModel, delay:Number = .0, event:String = GameEvent.CREATE_OBJECT, startPosition:Point = null):void
        {
            _field[object.position.x][object.position.y] = object;

            dispatchEvent(new GameEvent(event, new GameData(object, delay, startPosition)));
        }

        protected function decreaseTurns():void
        {
            if (_moves > 0)
            {
                _moves --;
                dispatchEvent(new GameEvent(GameEvent.UPDATE_GUI));
            }
        }

        protected function addScore(value:uint):void
        {
            _score += value;
            dispatchEvent(new GameEvent(GameEvent.UPDATE_GUI));
        }

        protected function levelUp():void
        {
            _level ++;

            Analytics.instance.reportLevelFinished();
            Analytics.instance.reportLevelStarted(_level);

            dispatchEvent(new GameEvent(GameEvent.UPDATE_GUI));
        }

        private function animateTimer_timerCompleteHandler(event:TimerEvent):void
        {
            if (!_animateTimer)
                return;

            setWaitingTimer(false);

            var targets:Vector.<BaseObjectModel> = getRandomObjects(GameConfig.MIN_ANIMATE_OBJECTS + uint(Math.random() * GameConfig.ADD_ANIMATE_OBJECTS));

            for each (var target:BaseObjectModel in targets)
            {
                target.playWaitIdle();
            }

            setWaitingTimer(true);
        }

        public function get moves():uint
        {
            return _moves;
        }

        public function get score():uint
        {
            return _score;
        }

        public function get level():uint
        {
            return _level;
        }
    }
}
