/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 02.06.14
 * Time: 13:21
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.controllers
{
    import assets.sounds.FinalThemeSound;
    import assets.sounds.MainThemeSound;
    import assets.windows.TutorialWindowAsset;

    import com.levelupers.marmalade_factory.Game.Root;
    import com.levelupers.marmalade_factory.utils.Analytics;
    import com.levelupers.marmalade_factory.utils.GameResult;
    import com.levelupers.marmalade_factory.Game.views.ResultsView;

    import com.levelupers.marmalade_factory.Game.views.TutorialView;
    import com.levelupers.utils.sound.SoundManager;
    import com.levelupers.utils.sound.StreamChannel;

    import flash.events.Event;

    public class ResultsController extends BaseWindowController
    {
        private var _gameResult     :GameResult;

        public function ResultsController(data:Object = null)
        {
            _gameResult = data as GameResult;
            _view = new ResultsView(_gameResult);
            _view.addEventListener(ResultsView.CONTINUE_PRESS, view_continuePressEventHandler);

            SoundManager.play(FinalThemeSound, 0, int.MAX_VALUE, 0, .75, StreamChannel.BACKGROUND);

            super(data);
        }

        override public function create():void
        {

        }

        override public function clear():void
        {
            _view.removeEventListener(ResultsView.CONTINUE_PRESS, view_continuePressEventHandler);

            _view.clear();
            _view = null;
        }

        private function view_continuePressEventHandler(event:Event):void
        {
            Analytics.instance.reportGameRestarted();

            SoundManager.play(MainThemeSound, 0, int.MAX_VALUE, 0, .75, StreamChannel.BACKGROUND);
            Root.instance.selectWindow(GameController);
        }

        private function get currentView():ResultsView
        {
            return _view as ResultsView;
        }
    }
}
