/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 02.06.14
 * Time: 13:21
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.controllers
{
    import com.levelupers.marmalade_factory.Game.Root;
    import com.levelupers.marmalade_factory.Game.views.TutorialView;
    import com.levelupers.marmalade_factory.utils.Analytics;

    import flash.events.Event;

    public class TutorialController extends BaseWindowController
    {
        private var _inGame                 :Boolean;
        private var _currentPage            :uint;
        static private var _page1Clicked    :Boolean = false;
        static private var _page2Clicked    :Boolean = false;

        public function TutorialController(data:Object = null)
        {
            _inGame = (data as Boolean);
            _view = new TutorialView(_inGame);
            _view.addEventListener(TutorialView.CLOSE_PRESS,    view_closePressEventHandler);
            _view.addEventListener(TutorialView.CONTINUE_PRESS, view_continuePressEventHandler);
            _view.addEventListener(TutorialView.COUNTER_PRESS,  view_counterPressEventHandler);
            _currentPage = 1;

            super(data);
        }

        override public function create():void
        {
            currentView.selectPage(_currentPage);
        }

        override public function clear():void
        {
            _view.removeEventListener(TutorialView.CLOSE_PRESS,    view_closePressEventHandler);
            _view.removeEventListener(TutorialView.CONTINUE_PRESS, view_continuePressEventHandler);
            _view.removeEventListener(TutorialView.COUNTER_PRESS,  view_counterPressEventHandler);

            _view.clear();
            _view = null;
        }

        private function closeTutorial():void
        {
            if (_inGame)
                Root.instance.closeTopWindow();
            else
                Root.instance.selectWindow(GameController);
        }

        private function view_closePressEventHandler(event:Event):void
        {
            closeTutorial();
        }

        private function view_continuePressEventHandler(event:Event):void
        {
            if (_currentPage == 1 && !_page1Clicked)
            {
                _page1Clicked = true;
                Analytics.instance.reportTutorialSkipped(_currentPage);
            }
            else if (_currentPage == 2 && !_page2Clicked)
            {
                _page2Clicked = true;
                Analytics.instance.reportTutorialSkipped(_currentPage);
            }

            _currentPage ++;
            if (_currentPage <= 2)
                currentView.selectPage(_currentPage);
            else
                closeTutorial();
        }

        private function get currentView():TutorialView
        {
            return _view as TutorialView;
        }

        private function view_counterPressEventHandler(event:Event):void
        {
            if (_currentPage == 1)
                _currentPage = 2;
            else
                _currentPage = 1;

            currentView.selectPage(_currentPage);
        }
    }
}
