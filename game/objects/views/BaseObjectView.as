/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 14:39
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.objects.views
{
    import assets.sounds.DestroySound;
    import assets.sounds.DropSound;
    import assets.sounds.SpecialActivateSound;

    import com.greensock.TweenMax;
    import com.levelupers.marmalade_factory.Game.modules.GameField;
    import com.levelupers.marmalade_factory.Game.modules.StateMachine;
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;
    import com.levelupers.marmalade_factory.configs.ColorsConfig;
    import com.levelupers.marmalade_factory.configs.ObjectsConfig;
    import com.levelupers.marmalade_factory.events.GameEvent;
    import com.levelupers.marmalade_factory.utils.CacheMovieClip;
    import com.levelupers.utils.sound.SoundManager;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    public class BaseObjectView extends StateMachine
    {
        protected const VIEWS_MAP:Object =
        {
            SimpleObjectModel       :   {
                                            (ColorsConfig.BLUE.toString())   :  ObjectsConfig.SIMPLE_BLUE_OBJECT_VIEWS,
                                            (ColorsConfig.GREEN.toString())  :  ObjectsConfig.SIMPLE_GREEN_OBJECT_VIEWS,
                                            (ColorsConfig.ORANGE.toString()) :  ObjectsConfig.SIMPLE_ORANGE_OBJECT_VIEWS,
                                            (ColorsConfig.PURPLE.toString()) :  ObjectsConfig.SIMPLE_PURPLE_OBJECT_VIEWS,
                                            (ColorsConfig.RED.toString())    :  ObjectsConfig.SIMPLE_RED_OBJECT_VIEWS,
                                            (ColorsConfig.YELLOW.toString()) :  ObjectsConfig.SIMPLE_YELLOW_OBJECT_VIEWS
                                        },
            VerticalObjectModel     :   {
                                            (ColorsConfig.BLUE.toString())   :  ObjectsConfig.VERTICAL_BLUE_OBJECT_VIEWS,
                                            (ColorsConfig.GREEN.toString())  :  ObjectsConfig.VERTICAL_GREEN_OBJECT_VIEWS,
                                            (ColorsConfig.ORANGE.toString()) :  ObjectsConfig.VERTICAL_ORANGE_OBJECT_VIEWS,
                                            (ColorsConfig.PURPLE.toString()) :  ObjectsConfig.VERTICAL_PURPLE_OBJECT_VIEWS,
                                            (ColorsConfig.RED.toString())    :  ObjectsConfig.VERTICAL_RED_OBJECT_VIEWS,
                                            (ColorsConfig.YELLOW.toString()) :  ObjectsConfig.VERTICAL_YELLOW_OBJECT_VIEWS
                                        },
            HorisontalObjectModel   :   {
                                            (ColorsConfig.BLUE.toString())   :  ObjectsConfig.HORISONTAL_BLUE_OBJECT_VIEWS,
                                            (ColorsConfig.GREEN.toString())  :  ObjectsConfig.HORISONTAL_GREEN_OBJECT_VIEWS,
                                            (ColorsConfig.ORANGE.toString()) :  ObjectsConfig.HORISONTAL_ORANGE_OBJECT_VIEWS,
                                            (ColorsConfig.PURPLE.toString()) :  ObjectsConfig.HORISONTAL_PURPLE_OBJECT_VIEWS,
                                            (ColorsConfig.RED.toString())    :  ObjectsConfig.HORISONTAL_RED_OBJECT_VIEWS,
                                            (ColorsConfig.YELLOW.toString()) :  ObjectsConfig.HORISONTAL_YELLOW_OBJECT_VIEWS
                                        }
        };

        protected const OBJECTS_MAP:Object =
        {

        };

        protected var _alphaTween:TweenMax;

        private var _moveTween:TweenMax;

        public function BaseObjectView(model:BaseObjectModel)
        {
            _model = model;

            _model.addEventListener(GameEvent.SHOW_OBJECT,              model_showHideObjectEventHandler);
            _model.addEventListener(GameEvent.HIDE_OBJECT,              model_showHideObjectEventHandler);

            _model.addEventListener(GameEvent.ADD_SELECTION,            model_addRemoveSelectionEventHandler);
            _model.addEventListener(GameEvent.REMOVE_SELECTION,         model_addRemoveSelectionEventHandler);
            _model.addEventListener(GameEvent.REMOVE_SELECT_ANIMATION,  model_addRemoveSelectionEventHandler);

            _model.addEventListener(GameEvent.DESTROY_OBJECT,           model_destroyObjectEventHandler);
            _model.addEventListener(GameEvent.DELETE_OBJECT,            model_destroyObjectEventHandler);

            _model.addEventListener(GameEvent.DROP_OBJECT,              model_dropObjectEventHandler);
            _model.addEventListener(GameEvent.MOVE_OBJECT,              model_moveObjectEventHandler);

            _model.addEventListener(GameEvent.PLAY_WAIT_IDLE,           model_playWaitIdleEventHandler);
        }

        public function create():void
        {
            var modelName:String = getQualifiedClassName(_model);
            modelName = modelName.split('.').pop().split(':').pop();

            for (var modelClass:String in VIEWS_MAP)
            {
                if (modelName == modelClass)
                {
                    _views = VIEWS_MAP[modelClass][_model.color];
                    break;
                }
            }

            if (!_views)
                throw new Error('View not find!');

            _view = new Sprite();

            addChild(_view);
        }

        public function clear(playSound:Boolean):void
        {
            if (!_view)
                return;

            if (playSound)
            {
                if (this is SimpleObjectView)
                    SoundManager.play(DestroySound);
                else
                    SoundManager.play(SpecialActivateSound);
            }

            removeChild(_view);
            _view = null;

            if (parent)
                parent.removeChild(this);

            _model.removeEventListener(GameEvent.SHOW_OBJECT,               model_showHideObjectEventHandler);
            _model.removeEventListener(GameEvent.HIDE_OBJECT,               model_showHideObjectEventHandler);

            _model.removeEventListener(GameEvent.ADD_SELECTION,             model_addRemoveSelectionEventHandler);
            _model.removeEventListener(GameEvent.REMOVE_SELECTION,          model_addRemoveSelectionEventHandler);
            _model.removeEventListener(GameEvent.REMOVE_SELECT_ANIMATION,   model_addRemoveSelectionEventHandler);

            _model.removeEventListener(GameEvent.DESTROY_OBJECT,            model_destroyObjectEventHandler);
            _model.removeEventListener(GameEvent.DELETE_OBJECT,             model_destroyObjectEventHandler);

            _model.removeEventListener(GameEvent.DROP_OBJECT,               model_dropObjectEventHandler);
            _model.removeEventListener(GameEvent.MOVE_OBJECT,               model_moveObjectEventHandler);

            _model.removeEventListener(GameEvent.PLAY_WAIT_IDLE,            model_playWaitIdleEventHandler);

            _model = null;
        }

        public function getPositionY():uint
        {
            if (!_model)
                return 0;

            return _model.position.y ;
        }

        private function model_showHideObjectEventHandler(event:GameEvent):void
        {
            if (!_view)
                return;

            if (event.type == GameEvent.SHOW_OBJECT)
            {
                if (_view.alpha != 1)
                {
                    playState(STATE_AWAKE, PLAY_ONCE_AND_NEXT, STATE_STAND);
                    _alphaTween.kill();
                    _view.alpha = 1;
                }
            }
            else
            {
                playState(STATE_ASLEEP, PLAY_ONCE_AND_NEXT, STATE_DREAM);
                _alphaTween = TweenMax.to(_view, .5, {alpha: .6});
            }
        }

        private function model_addRemoveSelectionEventHandler(event:GameEvent):void
        {
            if (!_view)
                return;
            switch (event.type)
            {
                case GameEvent.ADD_SELECTION:
                    playState(STATE_SELECT);
                    _view.filters = [new GlowFilter(0xFFFFFF, 1, 10, 10, 2)];
                    break;
                case GameEvent.REMOVE_SELECTION:
                    playState(STATE_STAND);
                    _view.filters = [];
                    break;
//                case GameEvent.REMOVE_SELECT_ANIMATION:
//                    playState(STATE_STAND);
//                    break;
            }
        }

        private function model_destroyObjectEventHandler(event:GameEvent):void
        {
            TweenMax.to(this, event.data.delay, {onComplete: clear, onCompleteParams: [(event.type == GameEvent.DESTROY_OBJECT)]});
        }

        private function model_dropObjectEventHandler(event:GameEvent):void
        {
            if (_moveTween)
                _moveTween.kill();

            var position:Point = GameField.getViewCoordinates(_model.position);
            _moveTween = TweenMax.to(this, event.data.delay, {y: position.y, onComplete: completeDrop });
        }

        private function completeDrop():void
        {
            SoundManager.play(DropSound);
            playState(STATE_DROP, PLAY_ONCE_AND_NEXT, STATE_STAND);
        }

        private function model_playWaitIdleEventHandler(event:GameEvent):void
        {
            var waitStates:Array = [STATE_WAIT_1, STATE_WAIT_2, STATE_WAIT_3];
            if (_model.position.y != 0)
                waitStates.push(STATE_WAIT_4);

            playState(waitStates[uint(Math.random() * waitStates.length)], PLAY_ONCE_AND_NEXT, STATE_STAND);
        }

        private function model_moveObjectEventHandler(event:GameEvent):void
        {
            if (_moveTween)
                _moveTween.kill();

            var position:Point = GameField.getViewCoordinates(_model.position);
            _moveTween = TweenMax.to(this, event.data.delay, {y: position.y, x: position.x});
        }
    }
}
