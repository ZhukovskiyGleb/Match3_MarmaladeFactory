/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 11:13
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.controllers
{
    import com.levelupers.marmalade_factory.Game.models.BaseWindowModel;
    import com.levelupers.marmalade_factory.Game.views.BaseWindowView;

    import flash.events.Event;

    public class BaseWindowController
    {

        protected var _view               :BaseWindowView;
        protected var _model              :BaseWindowModel;
        protected var _data               :Object;

        public function BaseWindowController(data:Object = null)
        {
            if (_view)
                _view.addEventListener(Event.ADDED_TO_STAGE, view_addedToStageHandler);

            _data = data;
        }

        protected function show():void
        {

        }

        public function create():void
        {

        }

        public function clear():void
        {

        }

        public function get view():BaseWindowView
        {
            return _view;
        }

        private function view_addedToStageHandler(event:Event):void
        {
            _view.removeEventListener(Event.ADDED_TO_STAGE, view_addedToStageHandler);
            show();
        }
    }
}
