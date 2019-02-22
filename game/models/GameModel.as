/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 11:27
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.models
{
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;
    import com.levelupers.marmalade_factory.configs.GameConfig;
    import com.levelupers.marmalade_factory.events.GameEvent;
    import com.levelupers.marmalade_factory.utils.Analytics;
    import com.levelupers.marmalade_factory.utils.SoundSequence;

    import flash.geom.Point;

    public class GameModel extends MathModel
    {
        protected var _colorSelected:Boolean = false;

        public function GameModel()
        {

        }

        public function startGame():void
        {
            updateFieldSize();
            setWaitingTimer(true);

            _moves = GameConfig.START_MOVES;
            _level = 1;

            dispatchEvent(new GameEvent(GameEvent.UPDATE_GUI));

            SoundSequence.refresh();

            Analytics.instance.reportLevelStarted(_level);
        }

        public function fieldMove(position:Point):void
        {
            if (!_colorSelected || _lockControl)
                return;

            checkPointForSelection(position);
        }

        public function fieldPress(position:Point):void
        {
            if (_colorSelected || _lockControl)
                return;

            _colorSelected = true;

            setWaitingTimer(false);

            var object:BaseObjectModel = getObject(position.x, position.y);

            hideObjectsByColor(object.color);

            addToSelected(object);
        }

        public function fieldRelease():void
        {
            if (_lockControl)
                return;

            _colorSelected = false;

            setWaitingTimer(true);

            showObjects();

            checkSelectedObjects();

            SoundSequence.refresh();
        }
    }
}
