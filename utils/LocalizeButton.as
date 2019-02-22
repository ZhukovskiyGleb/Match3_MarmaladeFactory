/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 22.04.14
 * Time: 16:04
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.utils
{
    import assets.sounds.ClickSound;

    import com.levelupers.marmalade_factory.utils.TFSearcher;
    import com.levelupers.utils.sound.SoundManager;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class LocalizeButton
    {
        private var _view:MovieClip;
        private var _key:String;
        private var _onClickCallback:Function;

        private var _muted:Boolean;

        public function LocalizeButton(view:MovieClip, key:String, muted:Boolean = false)
        {
            _view = view;
            _key = key;
            _muted = muted;

            _view.buttonMode = true;

            _view.addEventListener(MouseEvent.MOUSE_OVER, view_mouseOverHandler);
            _view.addEventListener(MouseEvent.MOUSE_OUT, view_mouseOutHandler);
            _view.addEventListener(MouseEvent.MOUSE_DOWN, view_mouseDownHandler);
            _view.addEventListener(MouseEvent.MOUSE_UP, view_mouseUpHandler);

            stateOut();
        }

        public function clear():void
        {
            _view.removeEventListener(MouseEvent.MOUSE_OVER, view_mouseOverHandler);
            _view.removeEventListener(MouseEvent.MOUSE_OUT, view_mouseOutHandler);
            _view.removeEventListener(MouseEvent.MOUSE_DOWN, view_mouseDownHandler);
            _view.removeEventListener(MouseEvent.MOUSE_UP, view_mouseUpHandler);

            _view = null;
        }

        public function updateKey(key:String):void
        {
            _key = key;
            setText();
        }

        public function onClick(callback:Function):void
        {
            _onClickCallback = callback;
        }

        private function setText():void
        {
            Localization.localize(TFSearcher.findInObject(_view), _key);
        }

        private function stateOut():void
        {
            _view.gotoAndStop(1);
            setText();
        }

        private function stateOver():void
        {
            _view.gotoAndStop(2);
            setText();
        }

        private function statePress():void
        {
            _view.gotoAndStop(3);
            setText();
        }



        private function view_mouseOverHandler(event:MouseEvent):void
        {
            stateOver();
        }

        private function view_mouseOutHandler(event:MouseEvent):void
        {
            stateOut();
        }

        private function view_mouseDownHandler(event:MouseEvent):void
        {
            statePress();

            if (!_muted)
                SoundManager.play(ClickSound);

            _view.removeEventListener(MouseEvent.MOUSE_OVER, view_mouseOverHandler);
        }

        private function view_mouseUpHandler(event:MouseEvent):void
        {
            stateOver();
            _view.addEventListener(MouseEvent.MOUSE_OVER, view_mouseOverHandler);

            if (_onClickCallback != null)
                _onClickCallback.call();
        }

        public function get visible():Boolean
        {
            return _view.visible;
        }

        public function set visible(value:Boolean):void
        {
            _view.visible = value;
        }

        public function get alpha():Number
        {
            return _view.alpha;
        }

        public function set alpha(value:Number):void
        {
			if (_view)
				_view.alpha = value;
        }
    }
}
