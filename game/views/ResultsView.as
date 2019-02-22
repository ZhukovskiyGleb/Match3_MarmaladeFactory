/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 02.06.14
 * Time: 13:22
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.views
{
    import assets.images.BackgroundStaticAsset;
    import assets.results.ResultFieldAsset;
    import assets.sounds.ClickSound;
    import assets.windows.ResultsWindowAsset;

    import com.levelupers.marmalade_factory.utils.GameResult;
    import com.levelupers.marmalade_factory.utils.Localization;
    import com.levelupers.marmalade_factory.utils.LocalizeButton;
    import com.levelupers.marmalade_factory.utils.TFSearcher;
    import com.levelupers.utils.sound.SoundController;
    import com.levelupers.utils.sound.SoundManager;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class ResultsView extends BaseWindowView
    {
        public static const CONTINUE_PRESS  :String = 'continuePressEvent';

        private var _background             :Sprite;
        private var _asset                  :ResultsWindowAsset;
        private var _gameResult             :GameResult;

        private var _button                 :LocalizeButton;

        public function ResultsView(gameResult:GameResult)
        {
            _gameResult = gameResult;
            _background = addChild(new BackgroundStaticAsset()) as Sprite;
            _asset = addChild(new ResultsWindowAsset()) as ResultsWindowAsset;

            _button = new LocalizeButton(_asset.continueButton, Localization.BUTTON_RESTART_TEXT);
            _button.onClick(buttonClick);

            _asset.closeButton.addEventListener(MouseEvent.CLICK, clickHandler);

            Localization.localize(_asset.titleField, Localization.RESULTS_TITLE_TEXT);
            Localization.localize(_asset.nowTitle, Localization.RESULTS_NOW_TEXT);
            Localization.localize(_asset.bestTitle, Localization.RESULTS_BEST_TEXT);

            setField(_asset.scoreField,         Localization.RESULTS_SCORE_TEXT,            GameResult.TOTAL_SCORE);
            setField(_asset.maxChainField,      Localization.RESULTS_MAX_CHAIN_TEXT,        GameResult.MAX_CHAIN_LENGTH);
            setField(_asset.averageChainField,  Localization.RESULTS_AVERAGE_CHAIN_TEXT,    GameResult.AVERAGE_CHAIN_LENGTH);
            setField(_asset.elementsField,      Localization.RESULTS_ELEMENTS_TEXT,         GameResult.ELEMENTS_DESTROYED);
            setField(_asset.improvedField,      Localization.RESULTS_IMPROVED_TEXT,         GameResult.IMPROVED_ELEMENTS_CREATED);

            SoundController.initSoundButton(_asset.musicSwitcher);
            SoundController.initEffectsButton(_asset.sfxSwitcher);

            super();
        }

        private function setField(field:ResultFieldAsset, titleKey:String, param:String):void
        {
//            , _gameResult.get(GameResult.TOTAL_SCORE)
            Localization.localize(field.title, titleKey);

            TFSearcher.findInObject(field.value).text = _gameResult.getParam(param).toString();
            field.best.text = _gameResult.getBestParam(param).toString();
        }

        private function buttonClick():void
        {
            dispatchEvent(new Event(CONTINUE_PRESS));
        }

        override protected function addedToStageHandler(event:Event):void
        {
            _asset.x = stage.stageWidth  / 2;
            _asset.y = stage.stageHeight / 2;

            super.addedToStageHandler(event);
        }

        override public function clear():void
        {
            removeChild(_background);
            _background = null;

            _asset.closeButton.removeEventListener(MouseEvent.CLICK, clickHandler);

            _button.clear();

            removeChild(_asset);
            _asset = null;
        }

        private function clickHandler(event:MouseEvent):void
        {
            SoundManager.play(ClickSound);
            dispatchEvent(new Event(CONTINUE_PRESS));
        }
    }
}
