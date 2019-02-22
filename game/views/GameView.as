/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 11:26
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.views
{
    import assets.images.BackgroundAsset;

    import com.greensock.TweenMax;
    import com.greensock.easing.Expo;

    import com.levelupers.marmalade_factory.Game.models.GameModel;
    import com.levelupers.marmalade_factory.Game.modules.FieldView;
    import com.levelupers.marmalade_factory.Game.modules.GameField;
    import com.levelupers.marmalade_factory.Game.modules.GameInterface;
    import com.levelupers.marmalade_factory.configs.DelaysConfig;
    import com.levelupers.marmalade_factory.configs.GameConfig;
    import com.levelupers.marmalade_factory.events.GameEvent;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BlurFilter;

    public class GameView extends BaseWindowView
    {

        private var _background             :BackgroundAsset;
        private var _gui                    :GameInterface;
        private var _fieldView              :FieldView;

        private var _model                  :GameModel;

        public function GameView(model:GameModel)
        {
            _model = model;

            _background         = addChild(new BackgroundAsset()) as BackgroundAsset;
            _gui                = new GameInterface(this, _model);
            _fieldView          = new FieldView(this);

//            _background.filters = [new BlurFilter(8, 8)];

            _model.addEventListener(GameEvent.UPDATE_FIELD_SIZE,        model_updateFieldSizeEventHandler);

            _model.addEventListener(GameEvent.UPDATE_GUI,               model_updateGUIEventHandler);

            _model.addEventListener(GameEvent.CREATE_OBJECT,            model_createObjectEventHandler);
            _model.addEventListener(GameEvent.CREATE_OBJECT_AT_PLACE,   model_createObjectEventHandler);

            _model.addEventListener(GameEvent.ADD_CONNECTOR,            model_addConnectorEventHandler);
            _model.addEventListener(GameEvent.REMOVE_CONNECTOR,         model_removeConnectorEventHandler);

            _model.addEventListener(GameEvent.UPDATE_DEPTHS,            model_updateDepthsEventHandler);

            _model.addEventListener(GameEvent.ADD_EFFECT,               model_addEffectEventHandler);

            _model.addEventListener(GameEvent.ADD_SPECIAL,              model_addSpecialEventHandler);
            _model.addEventListener(GameEvent.REMOVE_SPECIAL,           model_removeSpecialEventHandler);

            _model.addEventListener(GameEvent.UPDATE_SPECIAL_TARGETS,   model_updateSpecialTargetsEventHandler);

            _model.addEventListener(GameEvent.HIDE_GAME,                model_hideGameEventHandler);

            _model.addEventListener(GameEvent.SHAKE_FIELD,              model_shakeFieldEventHandler);

            _fieldView.addEventListener(GameEvent.FIELD_PRESS,          fieldView_fieldMouseEventHandler);
            _fieldView.addEventListener(GameEvent.FIELD_MOVE,           fieldView_fieldMouseEventHandler);
            _fieldView.addEventListener(GameEvent.FIELD_RELEASE,        fieldView_fieldMouseEventHandler);

            addEventListener(MouseEvent.MOUSE_UP,                       mouseUpHandler);
            addEventListener(Event.MOUSE_LEAVE,                         mouseLeaveHandler);
        }

        public function show():void
        {
            _fieldView.alpha    = 0;
            _gui.alpha          = 0;
            TweenMax.to(_fieldView, DelaysConfig.HIDE_SHOW_DELAY, {alpha: 1});
            TweenMax.to(_gui,       DelaysConfig.HIDE_SHOW_DELAY, {alpha: 1});
        }

        public function hide():void
        {
            TweenMax.to(_fieldView, DelaysConfig.HIDE_SHOW_DELAY, {alpha: 0});
            TweenMax.to(_gui,       DelaysConfig.HIDE_SHOW_DELAY, {alpha: 0});
        }

        override public function clear():void
        {
            removeChild(_background);
            _background = null;

            _gui.clear();
            _gui = null;

            _model.removeEventListener(GameEvent.UPDATE_FIELD_SIZE,         model_updateFieldSizeEventHandler);

            _model.removeEventListener(GameEvent.UPDATE_GUI,                model_updateGUIEventHandler);

            _model.removeEventListener(GameEvent.CREATE_OBJECT,             model_createObjectEventHandler);
            _model.removeEventListener(GameEvent.CREATE_OBJECT_AT_PLACE,    model_createObjectEventHandler);

            _model.removeEventListener(GameEvent.ADD_CONNECTOR,             model_addConnectorEventHandler);
            _model.removeEventListener(GameEvent.REMOVE_CONNECTOR,          model_removeConnectorEventHandler);

            _model.removeEventListener(GameEvent.UPDATE_DEPTHS,             model_updateDepthsEventHandler);

            _model.removeEventListener(GameEvent.ADD_EFFECT,                model_addEffectEventHandler);

            _model.removeEventListener(GameEvent.ADD_SPECIAL,               model_addSpecialEventHandler);
            _model.removeEventListener(GameEvent.REMOVE_SPECIAL,            model_removeSpecialEventHandler);

            _model.removeEventListener(GameEvent.UPDATE_SPECIAL_TARGETS,    model_updateSpecialTargetsEventHandler);

            _model.removeEventListener(GameEvent.HIDE_GAME,                 model_hideGameEventHandler);

            _model.removeEventListener(GameEvent.SHAKE_FIELD,               model_shakeFieldEventHandler);

            _model = null;

            _fieldView.removeEventListener(GameEvent.FIELD_PRESS,           fieldView_fieldMouseEventHandler);
            _fieldView.removeEventListener(GameEvent.FIELD_MOVE,            fieldView_fieldMouseEventHandler);
            _fieldView.removeEventListener(GameEvent.FIELD_RELEASE,         fieldView_fieldMouseEventHandler);

            _fieldView.clear();
            _fieldView = null;

            removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            removeEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
        }

        private function model_createObjectEventHandler(event:GameEvent):void
        {
            _fieldView.createObjectView(event.data.object, event.data.delay, event.data.position);
        }

        private function fieldView_fieldMouseEventHandler(event:GameEvent):void
        {
            switch (event.type)
            {
                case GameEvent.FIELD_PRESS:
                    _model.fieldPress(event.data.position);
                    break;
                case GameEvent.FIELD_MOVE:
                    _model.fieldMove(event.data.position);
                    break;
                case GameEvent.FIELD_RELEASE:
                    _model.fieldRelease();
                    break;
            }

        }

        private function mouseUpHandler(event:MouseEvent):void
        {
            fieldView_fieldMouseEventHandler(new GameEvent(GameEvent.FIELD_RELEASE));
        }

        private function mouseLeaveHandler(event:Event):void
        {
            fieldView_fieldMouseEventHandler(new GameEvent(GameEvent.FIELD_RELEASE));
        }

        private function model_updateFieldSizeEventHandler(event:GameEvent):void
        {
            _fieldView.updateSize(event.data.delay);
        }

        private function model_addConnectorEventHandler(event:GameEvent):void
        {
            _fieldView.addConnector(event.data.targets);
        }

        private function model_removeConnectorEventHandler(event:GameEvent):void
        {
            _fieldView.removeConnector(event.data.object);
        }

        private function model_updateDepthsEventHandler(event:GameEvent):void
        {
            _fieldView.updateDepths();
        }

        private function model_addEffectEventHandler(event:GameEvent):void
        {
            _fieldView.addEffect(event.data.message, event.data.object, event.data.delay, event.data.params);
        }

        private function model_addSpecialEventHandler(event:GameEvent):void
        {
            _fieldView.addRemoveSpecial(true, event.data.object,  event.data.delay);
        }

        private function model_removeSpecialEventHandler(event:GameEvent):void
        {
            _fieldView.addRemoveSpecial(false, event.data.object, event.data.delay);
        }

        private function model_updateSpecialTargetsEventHandler(event:GameEvent):void
        {
            _fieldView.updateSpecialTargets(event.data.targets);
        }

        private function model_updateGUIEventHandler(event:GameEvent):void
        {
            _gui.update();
        }

        public function get gui():GameInterface
        {
            return _gui;
        }

        private function model_hideGameEventHandler(event:GameEvent):void
        {
            hide();
        }

        private function model_shakeFieldEventHandler(event:GameEvent):void
        {
            var repeatCount:uint = GameConfig.FINAL_SPECIALS_AMOUNT * 4;
            TweenMax.to(_fieldView, .1, {repeat: repeatCount-1, y: _fieldView.y + (1 + /*Math.random() **/ 5), x: _fieldView.x + (1 + /*Math.random() **/ 5), delay: .1 + event.data.delay, ease: Expo.easeInOut});
            TweenMax.to(_fieldView, .1, {y: _fieldView.y, x: _fieldView.x, delay: (repeatCount + 1) * .1 + event.data.delay, ease: Expo.easeInOut});
        }
    }
}
