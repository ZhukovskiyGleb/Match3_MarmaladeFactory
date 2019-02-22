/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 02.06.14
 * Time: 14:47
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.utils
{
    import flash.net.SharedObject;
    import flash.utils.Dictionary;

    public class GameResult
    {
        public static const TYPE_TOTAL                  :String = 'TOTAL';
        public static const TYPE_MAX                    :String = 'MAX';
        public static const TYPE_AVERAGE                :String = 'AVERAGE';

        public static const TOTAL_SCORE                 :String = 'score';
        public static const ELEMENTS_DESTROYED          :String = 'elements';
        public static const MAX_CHAIN_LENGTH            :String = 'chains';
        public static const AVERAGE_CHAIN_LENGTH       :String = 'average';
        public static const IMPROVED_ELEMENTS_CREATED   :String = 'improved';

        private var _params:Dictionary;

        private var _sharedObject:SharedObject;

        public function GameResult()
        {
            _sharedObject = SharedObject.getLocal("bestResults");
            _params = new Dictionary();
        }

        public function addParam(param:String, value:int, type:String = TYPE_TOTAL):void
        {
            if (value == 0)
                return;

            if (_params[param] == null)
                _params[param] = 0;

            switch (type)
            {
                case TYPE_TOTAL:
                    _params[param] += value;
                    break;
                case TYPE_MAX:
                    _params[param] = Math.max(value, _params[param]);
                    break;
                case TYPE_AVERAGE:
                    if (_params[param] == 0)
                        _params[param] = value;
                    else
                        _params[param] = int((value + _params[param]) / 2);
                    break;
            }

            if (!_sharedObject.data[param] || _params[param] > _sharedObject.data[param])
            {
                _sharedObject.data[param] = _params[param];
            }
        }

        public function getParam(param:String):int
        {
            return (_params[param] == null) ? 0 : _params[param];
        }

        public function getBestParam(param:String):int
        {
            return (_sharedObject.data[param] == null) ? 0 : _sharedObject.data[param];
        }
    }
}
