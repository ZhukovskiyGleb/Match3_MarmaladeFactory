/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 15:24
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.events
{
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;

    import flash.geom.Point;

    public class GameData
    {

        private var _position       :Point;
        private var _delay          :Number = .0;
        private var _amount         :int;
        private var _object         :BaseObjectModel;
        private var _targets        :Vector.<BaseObjectModel>;
        private var _message        :String;
        private var _params         :Array;

        public function GameData(...params)
        {
            for each (var param:* in params)
            {
                if (param is Point)
                    _position = param as Point;
                else if (param is BaseObjectModel)
                        _object = param as BaseObjectModel;
                else if (param is Vector.<BaseObjectModel>)
                    _targets = param as Vector.<BaseObjectModel>;
                else if (param is String)
                    _message = param as String;
                else if (param is Number)
                    _delay = Number(param);
                else if (param is int)
                    _amount = int(param);
                else if (param is Array)
                    _params = param as Array;
            }
        }

        public function get position():Point
        {
            return _position;
        }

        public function get delay():Number
        {
            return _delay;
        }

//        public function get amount():int
//        {
//            return _amount;
//        }

        public function get object():BaseObjectModel
        {
            return _object;
        }

        public function get targets():Vector.<BaseObjectModel>
        {
            return _targets;
        }

        public function get message():String
        {
            return _message;
        }

        public function get params():Array
        {
            return _params;
        }
    }
}
