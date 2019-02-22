/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 14:25
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.models
{
    import assets.sounds.SpecialSelectedSound;

    import com.greensock.TweenMax;

    import com.greensock.TweenMax;
    import com.levelupers.marmalade_factory.Game.Root;
    import com.levelupers.marmalade_factory.Game.controllers.ResultsController;
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.HorisontalObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.SimpleObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.VerticalObjectModel;
    import com.levelupers.marmalade_factory.configs.DelaysConfig;
    import com.levelupers.marmalade_factory.configs.EffectsConfig;
    import com.levelupers.marmalade_factory.configs.GameConfig;
    import com.levelupers.marmalade_factory.events.GameData;
    import com.levelupers.marmalade_factory.events.GameEvent;
    import com.levelupers.marmalade_factory.utils.Analytics;
    import com.levelupers.marmalade_factory.utils.GameResult;
    import com.levelupers.marmalade_factory.utils.SoundSequence;
    import com.levelupers.utils.sound.SoundManager;

    import flash.geom.Point;

    public class MathModel extends PuzzleModel
    {
        private var _selected               :Vector.<BaseObjectModel>;
        protected var _gameResult           :GameResult;

        private var _gameFinished           :Boolean = false;
        private var _finalSpecialsCreated   :uint;

        public function MathModel()
        {
            _gameResult = new GameResult();
            _selected = new Vector.<BaseObjectModel>();
        }

        public function breakGame():void
        {
            _gameFinished = true;
            TweenMax.to(this, DelaysConfig.HIDE_SHOW_DELAY, {onComplete: closeGame});
            dispatchEvent(new GameEvent(GameEvent.HIDE_GAME));
        }

        public function closeGame():void
        {
            Root.instance.selectWindow(ResultsController, false, _gameResult);
        }

        protected function checkPointForSelection(position:Point):void
        {
            if (!_selected || _selected.length == 0)
                return;

            var object:BaseObjectModel = getObject(position.x, position.y);
            var prevObject:BaseObjectModel = _selected[_selected.length - 1];

            if (prevObject.position.x == object.position.x && prevObject.position.y == object.position.y)
                return;

            if (_selected.length > 1)
            {
                var prevPrevObject:BaseObjectModel = _selected[_selected.length - 2];

                if (prevPrevObject.position.x == object.position.x && prevPrevObject.position.y == object.position.y)
                {
                    removeFromSelected(prevObject);
                    return;
                }
            }

            if (prevObject.color != object.color)
                return;

            if (Math.abs(prevObject.position.x - object.position.x) > 1 || Math.abs(prevObject.position.y - object.position.y) > 1)
            {
                var result:Boolean = true;
                if (prevObject)
                {
                    var leaveObjects:Vector.<BaseObjectModel> = getColorLine(prevObject, object);
                    if (leaveObjects)
                    {
                        result = false;
                        for (var i:uint = 0; i < leaveObjects.length; i++)
                        {
                            addToSelected(leaveObjects[i]);
                        }
                    }
                }
                if (result)
                    return;
            }

            addToSelected(object);
        }

        private function getColorLine(objectStart:BaseObjectModel, objectFinish:BaseObjectModel):Vector.<BaseObjectModel>
        {
            var result:Vector.<BaseObjectModel> = new Vector.<BaseObjectModel>();
            var i:uint;
            var step:int;
            var length:uint;
            if (objectStart.position.y == objectFinish.position.y)
            {
                step = (objectStart.position.x < objectFinish.position.x) ? 1 : -1;
                length = Math.abs(objectStart.position.x - objectFinish.position.x);
                i = objectStart.position.x + step;

                while (length > 0)
                {
                    if (_field[i][objectStart.position.y].color == objectStart.color && _selected.indexOf(_field[i][objectStart.position.y]) == -1)
                        result.push(_field[i][objectStart.position.y]);
                    else
                        return null;

                    i += step;
                    length --;
                }
            }
            else if (objectStart.position.x == objectFinish.position.x)
            {
                step = (objectStart.position.y < objectFinish.position.y) ? 1 : -1;
                length = Math.abs(objectStart.position.y - objectFinish.position.y);
                i = objectStart.position.y + step;

                while (length > 0)
                {
                    if (_field[objectStart.position.x][i].color == objectStart.color && _selected.indexOf(_field[objectStart.position.x][i]) == -1)
                        result.push(_field[objectStart.position.x][i]);
                    else
                        return null;

                    i += step;
                    length --;
                }
            }
            if (result.length > 0)
                return result;

            return null;
        }

        protected function checkSelectedObjects():void
        {
            if (_selected.length >= GameConfig.MIN_LENGTH)
            {
                _gameResult.addParam(GameResult.MAX_CHAIN_LENGTH, _selected.length, GameResult.TYPE_MAX);
                _gameResult.addParam(GameResult.AVERAGE_CHAIN_LENGTH, _selected.length, GameResult.TYPE_AVERAGE);
                makeChain();
            }

            while (_selected.length > 0)
            {
                removeFromSelected(_selected[_selected.length - 1], false);
            }
        }

        private function makeChain():void
        {
            var specialTargets:Vector.<BaseObjectModel> = getSpecialTargets();

            calculateScore(_selected, specialTargets);

            var toDestroy:Vector.<BaseObjectModel> = createVector(_selected, specialTargets);

            _gameResult.addParam(GameResult.ELEMENTS_DESTROYED,         toDestroy.length, GameResult.TYPE_TOTAL);
            _gameResult.addParam(GameResult.IMPROVED_ELEMENTS_CREATED,  _specialModels.length, GameResult.TYPE_TOTAL);

            destroyObjects(toDestroy);
        }

        private function calculateScore(objects:Vector.<BaseObjectModel>, specialTargets:Vector.<BaseObjectModel>):void
        {
            var basePoints:uint = 100 + _level * 100;
            var addPoints:uint = basePoints * .25;

            var totalScore:uint;
            var specialsAmount:uint;
            var object:BaseObjectModel;
            var increment:uint;
            var i:uint;
            var points:uint;
            var delay:Number = .0;
            for (i = 0; i < objects.length; i ++)
            {
                object = objects[i];
                if (i > 0)
                    increment = (i) / 3;

                if (object is VerticalObjectModel || object is HorisontalObjectModel)
                {
                    specialsAmount ++;
                    increment += 10 * specialsAmount;
                }
                points = basePoints + increment * addPoints;
                totalScore += points;

                delay += DelaysConfig.DESTROY_DELAY;

                addEffect(EffectsConfig.TYPE_HINT, object, delay, [object.color, points.toString()]);
            }

            specialsAmount = 0;

            for (i = 0; i < specialTargets.length; i ++)
            {
                object = specialTargets[i];

                if (objects.indexOf(object) != -1)
                    continue;

                increment = 2;

                if (object is VerticalObjectModel || object is HorisontalObjectModel)
                {
                    specialsAmount ++;
                    increment += 10 * specialsAmount;
                }

                points = increment * addPoints;
                totalScore += points;

                delay += DelaysConfig.DESTROY_DELAY;

                addEffect(EffectsConfig.TYPE_HINT, object, delay, [object.color, points.toString()]);
            }

            addScore(totalScore);
            _gameResult.addParam(GameResult.TOTAL_SCORE, totalScore, GameResult.TYPE_TOTAL);
        }

        protected function addToSelected(object:BaseObjectModel):void
        {
            if (!_selected || _selected.indexOf(object) != -1)
                return;

            _selected.push(object);

            object.addSelection(BaseObjectModel.SELECTION_ON);

            if (_selected.length > 1)
            {
                var lastObjects:Vector.<BaseObjectModel> = new Vector.<BaseObjectModel>();
                lastObjects.push(_selected[_selected.length - 2], _selected[_selected.length - 1]);
                dispatchEvent(new GameEvent(GameEvent.ADD_CONNECTOR, new GameData(lastObjects)));
                _selected[_selected.length - 2].addSelection(BaseObjectModel.SELECTION_GLOW);
            }

            if (_selected.length % GameConfig.OBJECTS_NEED_FOR_SPECIAL == 0)
            {
                _specialModels.push(object);
                dispatchEvent(new GameEvent(GameEvent.ADD_SPECIAL, new GameData(_selected[_selected.length - 1])));
            }

            updateSpecialTargets();

            if (!(object is SimpleObjectModel))
            {
                SoundManager.play(SpecialSelectedSound);
                SoundManager.play(SoundSequence.jellyConnectSound, 0, 0, 0, .01);
            }
            else
                SoundManager.play(SoundSequence.jellyConnectSound, 0, 0, 0, .1);
        }

        protected function removeFromSelected(object:BaseObjectModel, removeSpecial:Boolean = true):void
        {
            if (!_selected || _selected.indexOf(object) == -1)
                return;

            var index:uint = _selected.indexOf(object);
            _selected.splice(index, 1);

            object.addSelection(BaseObjectModel.SELECTION_OFF);

            if (_selected.length > 0 && index > 0)
                dispatchEvent(new GameEvent(GameEvent.REMOVE_CONNECTOR, new GameData(_selected[index - 1])));

            if (_selected.length > 0)
                _selected[index - 1].addSelection(BaseObjectModel.SELECTION_ON);

            if (removeSpecial && (_selected.length + 1) % GameConfig.OBJECTS_NEED_FOR_SPECIAL == 0)
            {
                _specialModels.splice(_specialModels.indexOf(object), 1);
                dispatchEvent(new GameEvent(GameEvent.REMOVE_SPECIAL, new GameData(object)));
            }

            updateSpecialTargets();

            SoundManager.play(SoundSequence.jellyConnectPrevSound, 0, 0, 0, .1);
        }

        private function updateSpecialTargets():void
        {
            var targets:Vector.<BaseObjectModel> = getSpecialTargets();

            if (targets.length > 0)
                targets.push(_selected[_selected.length - 1]);

            dispatchEvent(new GameEvent(GameEvent.UPDATE_SPECIAL_TARGETS, new GameData(targets)));
        }

        private function getSpecialTargets():Vector.<BaseObjectModel>
        {
            var specialAmount:uint;
            var specials:Vector.<BaseObjectModel> = new Vector.<BaseObjectModel>();

            for each (var object:BaseObjectModel in _selected)
            {
                if (object is VerticalObjectModel || object is HorisontalObjectModel)
                {
                    specialAmount ++;
                    specials.push(object);
                }
            }

            var targets:Vector.<BaseObjectModel>  = new Vector.<BaseObjectModel>();

            if (specialAmount > 0)
            {
                if (specialAmount >= 2 || specials[0] is VerticalObjectModel)
                    addVerticalTargets(_selected[_selected.length - 1], targets, specials);

                if (specialAmount >= 2 || specials[0] is HorisontalObjectModel)
                    addHorisontalTargets(_selected[_selected.length - 1], targets, specials);
            }

            return targets;
        }

        private function addVerticalTargets(object:BaseObjectModel, result:Vector.<BaseObjectModel>, specials:Vector.<BaseObjectModel>):void
        {
            var posX:uint = object.position.x;
            var posY:uint;

            for (posY = 0; posY < _fieldSize; posY ++)
            {
                checkSpecialTarget(object, _field[posX][posY], result, true, specials);
            }
        }

        private function addHorisontalTargets(object:BaseObjectModel, result:Vector.<BaseObjectModel>, specials:Vector.<BaseObjectModel>):void
        {
            var posX:uint;
            var posY:uint = object.position.y;

            for (posX = 0; posX < _fieldSize; posX ++)
            {
                checkSpecialTarget(object, _field[posX][posY], result, false, specials);
            }
        }

        private function checkSpecialTarget(object:BaseObjectModel, target:BaseObjectModel, result:Vector.<BaseObjectModel>, isVertical:Boolean, specials:Vector.<BaseObjectModel>):void
        {
            if (object == target || result.indexOf(target) != -1)
                return;

            result.push(target);

            if (specials.indexOf(target) == -1 && (target is VerticalObjectModel || target is HorisontalObjectModel))
            {
                specials.push(target);
                if (isVertical)
                    addHorisontalTargets(target, result, specials);
                else
                    addVerticalTargets(target, result, specials);
            }
        }

        override protected function finisGame(specials:Vector.<BaseObjectModel> = null):void
        {
           if (!_gameFinished)
           {
               _gameFinished = true;

               Analytics.instance.reportGameFinished(_score);

               addEffect(EffectsConfig.TYPE_HINT, null, 0, [EffectsConfig.MEDLEY_EFFECT]);
               var delay:Number = .5;
               dispatchEvent(new GameEvent(GameEvent.SHAKE_FIELD, new GameData(delay)));
               var emptySpaces:uint = getEmptySpaces();
               while (_finalSpecialsCreated < GameConfig.FINAL_SPECIALS_AMOUNT && emptySpaces > 0)
               {
                   do
                   {
                       var posX:uint = Math.random() * _fieldSize;
                       var posY:uint = Math.random() * _fieldSize;
                   }
                   while (_specialModels.indexOf(_field[posX][posY]) != -1);
                   _specialModels.push(_field[posX][posY]);
                   dispatchEvent(new GameEvent(GameEvent.ADD_SPECIAL, new GameData(_field[posX][posY], delay)));
                   delay += DelaysConfig.FINAL_SPECIAL_DELAY;
                   _finalSpecialsCreated ++;
                   emptySpaces --;
               }
               TweenMax.to(this, delay + .1, {onComplete: makeChain});
               return;
           }

           for (var i:uint = 0; i < _fieldSize; i++)
           {
               for (var j:uint = 0; j < _fieldSize; j++)
               {
                   if (_field[i][j] is VerticalObjectModel || _field[i][j] is HorisontalObjectModel)
                   {
                       _selected = new Vector.<BaseObjectModel>();
                       _selected.push(_field[i][j]);
                       makeChain();
                       return;
                   }
               }
           }

           breakGame();
        }

        public function get gameFinished():Boolean
        {
            return _gameFinished;
        }
    }
}
