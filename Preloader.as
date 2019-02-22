package com.levelupers.marmalade_factory
{

    import assets.images.BackgroundStaticAsset;
    import assets.sounds.MainThemeSound;
    import assets.windows.PreloaderAsset;

    import com.greensock.TweenMax;
    import com.levelupers.marmalade_factory.utils.Analytics;
    import com.levelupers.marmalade_factory.utils.Localization;
    import com.levelupers.marmalade_factory.utils.LocalizeButton;
    import com.levelupers.utils.sound.SoundManager;
    import com.levelupers.utils.sound.StreamChannel;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.external.ExternalInterface;

    /**
	 * ...
	 * @author Zhukovskiy Gleb
	 */
	public class Preloader extends Sprite
	{
		private var _progress:uint;
        private var _background:BackgroundStaticAsset;
        private var _asset:PreloaderAsset;
        private var _assetContainer:Sprite;
        private var _readyButton:LocalizeButton;

		public function Preloader() 
		{
            Localization.select_lang(Localization.EN);

            _background = new BackgroundStaticAsset();
            _asset = new PreloaderAsset();

			if (stage) {
                _assetContainer = new Sprite();
				stage.scaleMode = StageScaleMode.EXACT_FIT;
				stage.align = StageAlign.TOP_LEFT;
                stage.addChild(_background);
                _assetContainer.addChild(_asset);
                _asset.x = stage.stageWidth / 2;
                _asset.y = stage.stageHeight / 2;
                stage.addChild(_assetContainer);
			}

            _readyButton = new LocalizeButton(_asset.playButton, Localization.BUTTON_PLAY_TEXT, true);
            _readyButton.visible = false;

			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);

            if (ExternalInterface.available)
                Analytics.instance.init(stage, false);
//            else
//                Analytics.instance.init(stage);

            Analytics.instance.reportGameOpened();

//            Gamixy.showAdvertisement(_assetContainer, 14);
            Gamixy.showMoreGamesPanel(stage);
		}
		
		private function ioError(event:IOErrorEvent):void
		{
			throw new Error(event.text);
		}
		
		private function checkFrame(event:Event):void
		{
            _progress = loaderInfo.bytesTotal / ((loaderInfo.bytesLoaded + 1) / 100) + 1;
            _asset.progressBar.progress.gotoAndStop(_progress);

			if (_progress >= 100)
			{
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);

            _readyButton.visible = true;
            _readyButton.alpha = 0;
            TweenMax.to(_readyButton,.5, {alpha: 1});
            _readyButton.onClick(buttonClicked);
		}

        private function buttonClicked():void
        {
            _readyButton.clear();
//            startup();
            Gamixy.showAnimation(stage, startup);
        }
		
		private function startup():void 
		{
            Analytics.instance.reportGameStarted();

            SoundManager.play(MainThemeSound, 0, int.MAX_VALUE, 3, .75, StreamChannel.BACKGROUND);

            stage.removeChild(_background);
            stage.removeChild(_assetContainer);
            _background = null;
            _asset = null;

			addChild(new Marmalade_factory());
		}

	}
	
}