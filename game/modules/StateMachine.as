/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 29.05.14
 * Time: 11:15
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.modules
{
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;
    import com.levelupers.marmalade_factory.utils.CacheMovieClip;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    public class StateMachine extends Sprite
    {
        public static const STATE_STAND         :String = 'stand';
        public static const STATE_WAIT_1        :String = 'wait1';
        public static const STATE_WAIT_2        :String = 'wait2';
        public static const STATE_WAIT_3        :String = 'wait3';
        public static const STATE_WAIT_4        :String = 'wait4';
        public static const STATE_ASLEEP        :String = 'asleep';
        public static const STATE_DREAM         :String = 'dream';
        public static const STATE_AWAKE         :String = 'awake';
        public static const STATE_SELECT        :String = 'select';
        public static const STATE_DROP          :String = 'drop';

        protected const PLAY_REPEAT         :uint = 0;
        protected const PLAY_ONCE_AND_STOP  :uint = 1;
        protected const PLAY_ONCE_AND_NEXT  :uint = 2;

        protected var _view                 :Sprite;
        protected var _model                :BaseObjectModel;

        protected var _views                :Object;

        private var _nextState              :String;
        private var _activeStates           :Vector.<String>;

        private var _currentPlayType        :uint;

        public function StateMachine()
        {

        }

        protected function activateStates(...states):void
        {
            _activeStates = new Vector.<String>();

            for each (var state:String in states)
            {
                _activeStates.push(state);
            }
        }

        public function playState(state:String, playType:uint = PLAY_REPEAT, nextState:String = null ):void
        {
            if (!_view || !_activeStates || _activeStates.indexOf(state) == -1)
                return;

            while(_view.numChildren > 0)
            {
                _view.removeChildAt(0);
            }

            var ObjectClass:Class = _views[state] as Class;
            var cache:MovieClip = new ObjectClass() as MovieClip;

            _view.addChild(cache);

            _currentPlayType = playType;

            if (_currentPlayType != PLAY_REPEAT)
                cache.addEventListener(Event.ENTER_FRAME, enterFrameHandler);

            if (_currentPlayType == PLAY_ONCE_AND_NEXT)
                _nextState = nextState;
            else
                nextState = null;
        }

        private function enterFrameHandler(event:Event):void
        {
            var view:MovieClip = event.currentTarget as MovieClip;

            if (_currentPlayType != PLAY_REPEAT && view.currentFrame == view.totalFrames)
            {
                view.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
                if (_nextState)
                    playState(_nextState);
                else
                    view.stop();
            }
        }
    }
}
