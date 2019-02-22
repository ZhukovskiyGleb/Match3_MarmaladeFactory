/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 14:26
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.models
{
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.HorisontalObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.SimpleObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.VerticalObjectModel;
    import com.levelupers.marmalade_factory.configs.ColorsConfig;
    import com.levelupers.marmalade_factory.configs.DelaysConfig;
    import com.levelupers.marmalade_factory.events.GameData;
    import com.levelupers.marmalade_factory.events.GameEvent;

    public class ServicesModel extends BaseWindowModel
    {
        protected var _availableColors      :uint;
        protected var _field                :Vector.<Vector.<BaseObjectModel>>;

        protected var _lockedColor          :int = -1;

        protected var _fieldSize            :uint;

        public function ServicesModel()
        {
            super();
        }

        protected function getObject(posX:uint, posY:uint):BaseObjectModel
        {
            if (!_field || _field.length <= posX || _field[posX].length <= posY)
                throw new Error('Incorrect position!');

            return _field[posX][posY];
        }

        protected function createSimpleObject(color:int = ColorsConfig.NO_COLOR):SimpleObjectModel
        {
            if (color == ColorsConfig.NO_COLOR)
            {
                color = getRandomColor();
            }
            return new SimpleObjectModel(color);
        }

        protected function createSpecialObject(color:int = ColorsConfig.NO_COLOR):BaseObjectModel
        {
            if (color == ColorsConfig.NO_COLOR)
            {
                color = getRandomColor();
            }

            if (Math.random() < .5)
                return new VerticalObjectModel(color);
            else
                return new HorisontalObjectModel(color);
        }

        protected function createVector(targetVector:Vector.<BaseObjectModel>, objectsVector:Vector.<BaseObjectModel>):Vector.<BaseObjectModel>
        {
            var result:Vector.<BaseObjectModel> = new Vector.<BaseObjectModel>();
            result = result.concat(targetVector);
            for each (var object:BaseObjectModel in objectsVector)
            {
                if (result.indexOf(object) == -1)
                    result.push(object);
            }
            return result;
        }

        protected function getObjectsByColor(color:uint):Vector.<BaseObjectModel>
        {
            var result:Vector.<BaseObjectModel> = new Vector.<BaseObjectModel>();

            for (var i:uint = 0; i < _fieldSize; i++)
            {
                for (var j:uint = 0; j < _fieldSize; j++)
                {
                    if (_field[i][j].color == color)
                        result.push(_field[i][j]);
                }
            }

            return result;
        }

        protected function getEmptySpaces():uint
        {
            var result:uint;
            for (var i:uint = 0; i < _fieldSize; i++)
            {
                for (var j:uint = 0; j < _fieldSize; j++)
                {
                    if (_field[i][j] is SimpleObjectModel)
                        result ++;
                }
            }

            return result;
        }

        protected function hideObjectsByColor(color:uint):void
        {
            for (var i:uint = 0; i < _fieldSize; i++)
            {
                for (var j:uint = 0; j < _fieldSize; j++)
                {
                    if (_field[i][j].color != color)
                        _field[i][j].showHideView(false);
                }
            }
        }

        protected function showObjects():void
        {
            for (var i:uint = 0; i < _fieldSize; i++)
            {
                for (var j:uint = 0; j < _fieldSize; j++)
                {
                    _field[i][j].showHideView(true);
                }
            }
        }

        protected function shiftColumn(col:uint):uint
        {
            var dropLength:uint;

            var column:Vector.<BaseObjectModel> = _field[col];

            var step:uint = column.length;

            for (var i:int = column.length - 1; i >= 0; i --)
            {
                if (column[i].readyForDelete)
                {
                    column.splice(i, 1);
                    column.unshift(null);
                    dropLength ++;
                    i ++;
                }
                else if (column[i].position.y != i)
                {
                    var delay:Number = DelaysConfig.DROP_START_DELAY + (i - column[i].position.y) * DelaysConfig.DROP_ADD_DELAY;
                    column[i].updatePosition(column[i].position.x, i, delay, GameEvent.DROP_OBJECT);
                }

                step --;

                if (step == 0)
                    break;
            }

            return dropLength;
        }

        protected function getRandomObjects(amount:uint):Vector.<BaseObjectModel>
        {
            var result:Vector.<BaseObjectModel> = new Vector.<BaseObjectModel>();

            while (amount > 0)
            {
                var posX:uint;
                var posY:uint;
                var object:BaseObjectModel;

                do
                {
                    posX = Math.random() * _fieldSize;
                    posY = Math.random() * _fieldSize;
                    object = getObject(posX, posY);
                }
                while (!(object is SimpleObjectModel) || result.indexOf(object) != -1);

                result.push(object);

                amount --;
            }

            return result;
        }

        protected function addEffect(effect:String, object:BaseObjectModel = null, delay:Number = .0, params:Array = null):void
        {
            dispatchEvent(new GameEvent(GameEvent.ADD_EFFECT, new GameData(effect, object, delay, params)));
        }

        protected function getRandomColor():uint
        {
//            do
//            {
//                var color:uint =  uint(Math.random() * Math.min(ColorsConfig.MAX_COLORS, _availableColors));
//            }
//            while (color == _lockedColor);
            var color:uint =  uint(Math.random() * Math.min(ColorsConfig.MAX_COLORS, _availableColors));

            return color;
        }
    }
}
