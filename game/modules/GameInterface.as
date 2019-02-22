/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 12:45
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.modules
{
    import assets.gui.GameInterfaceAsset;

    import com.greensock.TweenMax;
    import com.levelupers.marmalade_factory.Game.models.GameModel;
    import com.levelupers.marmalade_factory.Game.views.GameView;
    import com.levelupers.marmalade_factory.utils.Localization;
    import com.levelupers.marmalade_factory.utils.TFSearcher;
    import com.levelupers.utils.sound.SoundController;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class GameInterface extends GameInterfaceAsset
    {
        public static const INFO_PRESS      :String = 'infoPressEvent';
        public static const RESTART_PRESS   :String = 'restartPressEvent';

        private const POSITION              :Point = new Point(22, 22);

        private var _model                  :GameModel;
        private var _score                  :uint;

        private var _levelTF                :TextField;
        private var _scoreTF                :TextField;
        private var _movesTF                :TextField;

        public function GameInterface(gameView:GameView, model:GameModel)
        {
            gameView.addChild(this);
            this.x = POSITION.x;
            this.y = POSITION.y;

            _model = model;

            Localization.localize(levelTitle, Localization.GUI_LEVEL_TEXT);
            Localization.localize(scoreTitle, Localization.GUI_SCORE_TEXT);
            Localization.localize(movesTitle, Localization.GUI_MOVES_TEXT);

            _levelTF = TFSearcher.findInObject(levelValue);
            _scoreTF = TFSearcher.findInObject(scoreValue);
            _movesTF = TFSearcher.findInObject(movesValue);

            infoButton.addEventListener(MouseEvent.CLICK,       infoButton_clickHandler);
            restartButton.addEventListener(MouseEvent.CLICK,    restartButton_clickHandler);

            SoundController.initSoundButton(musicSwitcher);
            SoundController.initEffectsButton(sfxSwitcher);

            update();
        }

        private function updateLevel(value:uint):void
        {
            _levelTF.text = value.toString();
        }

        private function updateScore(value:uint):void
        {
            if (value == _score && value != 0)
                return;

            if (value < _score)
                score = value;
            else
                TweenMax.to(this, 1, {score: value});
        }

        private function updateTurns(value:uint):void
        {
            _movesTF.text = value.toString();
        }

        public function clear():void
        {
            if (parent)
                parent.removeChild(this);

            infoButton.removeEventListener(MouseEvent.CLICK,    infoButton_clickHandler);
            restartButton.removeEventListener(MouseEvent.CLICK, restartButton_clickHandler);
        }

        public function update():void
        {
            updateLevel(_model.level);
            updateScore(_model.score);
            updateTurns(_model.moves);
        }

        public function get score():uint
        {
            return _score;
        }

        public function set score(value:uint):void
        {
            _scoreTF.text = value.toString();

            while (_scoreTF.textWidth >= scoreValue.width - 102)
            {
                var textFormat:TextFormat = _scoreTF.getTextFormat();
                textFormat.size = uint(textFormat.size) - 1;
                _scoreTF.setTextFormat(textFormat);

                _scoreTF.y = - _scoreTF.textHeight * 1.60;
            }

            _score = value;
        }

        private function infoButton_clickHandler(event:MouseEvent):void
        {
            dispatchEvent(new Event(INFO_PRESS));
        }

        private function restartButton_clickHandler(event:MouseEvent):void
        {
            dispatchEvent(new Event(RESTART_PRESS));
        }
    }
}
