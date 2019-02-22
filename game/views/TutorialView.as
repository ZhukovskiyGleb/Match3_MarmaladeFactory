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
    import assets.sounds.ClickSound;
    import assets.windows.TutorialPage1Asset;
    import assets.windows.TutorialPage2Asset;
    import assets.windows.TutorialWindowAsset;

    import com.levelupers.marmalade_factory.utils.Localization;

    import com.levelupers.marmalade_factory.utils.LocalizeButton;
    import com.levelupers.utils.sound.SoundController;
    import com.levelupers.utils.sound.SoundManager;

    import flash.display.MovieClip;

    import flash.display.Sprite;

    import flash.events.Event;
    import flash.events.MouseEvent;

    public class TutorialView extends BaseWindowView
    {
        public static const CONTINUE_PRESS  :String = 'continuePressEvent';
        public static const CLOSE_PRESS     :String = 'closePressEvent';
        public static const COUNTER_PRESS   :String = 'counterPressEvent';

        private var _background             :Sprite;
        private var _asset                  :TutorialWindowAsset;
        private var _inGame                 :Boolean;
        private var _pageAsset              :MovieClip;

        private var _button                 :LocalizeButton;

        public function TutorialView(inGame:Boolean)
        {
            _inGame = inGame;
            _asset = addChild(new TutorialWindowAsset()) as TutorialWindowAsset;
            if (_inGame)
            {
                _background = addChildAt(new Sprite(), 0) as Sprite;
                _asset.sfxSwitcher.visible = false;
                _asset.musicSwitcher.visible = false;
            }
            else
            {
                _background = addChildAt(new BackgroundStaticAsset(), 0) as Sprite;
                SoundController.initSoundButton(_asset.musicSwitcher);
                SoundController.initEffectsButton(_asset.sfxSwitcher);
            }

            _button = new LocalizeButton(_asset.continueButton, Localization.BUTTON_NEXT_TEXT);
            _button.onClick(buttonClick);

            _asset.closeButton.addEventListener(MouseEvent.CLICK, clickHandler);
            _asset.pageCounter.addEventListener(MouseEvent.CLICK, counterClickHandler);

            _asset.pageCounter.buttonMode = true;

            Localization.localize(_asset.titleField, Localization.TUTORIAL_TITLE_TEXT)

            super();
        }

        private function buttonClick():void
        {
            dispatchEvent(new Event(CONTINUE_PRESS));
        }

        public function selectPage(page:uint):void
        {
            _asset.pageCounter.gotoAndStop(page);

            if (_pageAsset)
                removeChild(_pageAsset);

            if (page == 1)
            {
                _pageAsset = new TutorialPage1Asset();
                Localization.localize(_asset.infoField, Localization.TUTORIAL_INFO_PAGE1_TEXT);
                _button.updateKey(Localization.BUTTON_NEXT_TEXT);
            }
            else if (page == 2)
            {
                _pageAsset = new TutorialPage2Asset();
                Localization.localize(_asset.infoField, Localization.TUTORIAL_INFO_PAGE2_TEXT);
                _button.updateKey(Localization.BUTTON_PLAY_TEXT);
            }
            addChild(_pageAsset);

            if (stage)
            {
                _pageAsset.x = stage.stageWidth / 2;
                _pageAsset.y = stage.stageHeight / 2 + 50;
            }
        }

        override protected function addedToStageHandler(event:Event):void
        {
            _asset.x = stage.stageWidth  / 2;
            _asset.y = stage.stageHeight / 2;

            _pageAsset.x = stage.stageWidth / 2;
            _pageAsset.y = stage.stageHeight / 2 + 50;

            if (_inGame)
            {
                _background.graphics.lineStyle(0);
                _background.graphics.beginFill(0x000000,.5);
                _background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
                _background.graphics.endFill();
            }

            super.addedToStageHandler(event);
        }

        override public function clear():void
        {
            removeChild(_background);
            _background = null;

            _asset.closeButton.removeEventListener(MouseEvent.CLICK, clickHandler);
            _asset.pageCounter.removeEventListener(MouseEvent.CLICK, counterClickHandler);

            _button.clear();

            removeChild(_asset);
            _asset = null;
        }

        private function clickHandler(event:MouseEvent):void
        {
            SoundManager.play(ClickSound);
            dispatchEvent(new Event(CLOSE_PRESS));
        }

        private function counterClickHandler(event:MouseEvent):void
        {
            SoundManager.play(ClickSound);
            dispatchEvent(new Event(COUNTER_PRESS));
        }
    }
}
