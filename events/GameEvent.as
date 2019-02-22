/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 15:22
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.events
{
    import flash.events.Event;

    public class GameEvent extends Event
    {

        public static const COMPLETE                        :String = 'completeEvent';

        public static const CREATE_OBJECT                   :String = 'createObjectEvent';
        public static const CREATE_OBJECT_AT_PLACE          :String = 'createObjectAtPlaceEvent';
        public static const DESTROY_OBJECT                  :String = 'destroyObjectEvent';
        public static const DELETE_OBJECT                   :String = 'deleteObjectEvent';
        public static const DROP_OBJECT                     :String = 'dropObjectEvent';
        public static const MOVE_OBJECT                     :String = 'moveObjectEvent';

        public static const UPDATE_FIELD_SIZE               :String = 'updateFieldSizeEvent';

        public static const FIELD_PRESS                     :String = 'fieldPressEvent';
        public static const FIELD_MOVE                      :String = 'fieldMoveEvent';
        public static const FIELD_RELEASE                   :String = 'fieldReleaseEvent';

        public static const SHOW_OBJECT                     :String = 'showObjectEvent';
        public static const HIDE_OBJECT                     :String = 'hideObjectEvent';

        public static const ADD_SELECTION                   :String = 'addSelectionEvent';
        public static const REMOVE_SELECTION                :String = 'removeSelectionEvent';
        public static const REMOVE_SELECT_ANIMATION         :String = 'removeSelectAnimationEvent';

        public static const ADD_CONNECTOR                   :String = 'addConnectorEvent';
        public static const REMOVE_CONNECTOR                :String = 'removeConnectorEvent';

        public static const ADD_SPECIAL                     :String = 'addSpecialEvent';
        public static const REMOVE_SPECIAL                  :String = 'removeSpecialEvent';

        public static const PLAY_WAIT_IDLE                  :String = 'playWaitIdleEvent';

        public static const UPDATE_DEPTHS                   :String = 'updateDepthsEvent';

        public static const ADD_EFFECT                      :String = 'addEffectEvent';

        public static const UPDATE_SPECIAL_TARGETS          :String = 'updateSpecialTargetsEvent';

        public static const UPDATE_GUI                      :String = 'updateGUIEvent';

        public static const HIDE_GAME                       :String = 'hideGameEvent';

        public static const SHAKE_FIELD                     :String = 'shakeFieldEvent';

        private var _data                                   :GameData;

        public function GameEvent(type:String, data:GameData = null)
        {
            _data = data;

            super(type, false, false);
        }

        public function get data():GameData
        {
            return _data;
        }
    }
}
