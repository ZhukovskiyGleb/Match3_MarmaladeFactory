/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 11:24
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.controllers
{
    import com.levelupers.marmalade_factory.Game.Root;
    import com.levelupers.marmalade_factory.Game.models.GameModel;
    import com.levelupers.marmalade_factory.Game.modules.GameInterface;
    import com.levelupers.marmalade_factory.Game.views.GameView;
    import com.levelupers.marmalade_factory.utils.Analytics;

    import flash.events.Event;

    public class GameController extends BaseWindowController
    {
        public function GameController(data:Object = null)
        {
            _model      = new GameModel();
            _view       = new GameView(_model as GameModel);
            (_view as GameView).show();

            (_view as GameView).gui.addEventListener(GameInterface.INFO_PRESS,      infoPressEventHandler);
            (_view as GameView).gui.addEventListener(GameInterface.RESTART_PRESS,   restartPressEventHandler);
        }

        override protected function show():void
        {

        }

        override public function create():void
        {
            gameModel   .startGame();
        }

        override public function clear():void
        {
            (_view as GameView).gui.removeEventListener(GameInterface.INFO_PRESS,       infoPressEventHandler);
            (_view as GameView).gui.removeEventListener(GameInterface.RESTART_PRESS,    restartPressEventHandler);

            _view.clear();
            _view = null;

            _model.clear();
            _model = null;
        }

        private function get gameModel():GameModel
        {
            return _model as GameModel;
        }

        private function get gameView():GameView
        {
            return _view as GameView;
        }

        private function infoPressEventHandler(event:Event):void
        {
            if (!(_model as GameModel).gameFinished)
                Root.instance.selectWindow(TutorialController, true, true);
        }

        private function restartPressEventHandler(event:Event):void
        {
            if (!(_model as GameModel).gameFinished)
            {
                (_model as GameModel).breakGame();
                Analytics.instance.reportGameBreak();
            }
        }
    }
}
