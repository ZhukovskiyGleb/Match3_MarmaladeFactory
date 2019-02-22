/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 14:50
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.configs
{
    import assets.objects.HorisontalObjectBlueAsset;
    import assets.objects.HorisontalObjectBlueSelectAsset;
    import assets.objects.HorisontalObjectBlueStandAsset;
    import assets.objects.HorisontalObjectGreenAsset;
    import assets.objects.HorisontalObjectGreenSelectAsset;
    import assets.objects.HorisontalObjectGreenStandAsset;
    import assets.objects.HorisontalObjectOrangeAsset;
    import assets.objects.HorisontalObjectOrangeSelectAsset;
    import assets.objects.HorisontalObjectOrangeStandAsset;
    import assets.objects.HorisontalObjectPurpleAsset;
    import assets.objects.HorisontalObjectPurpleSelectAsset;
    import assets.objects.HorisontalObjectPurpleStandAsset;
    import assets.objects.HorisontalObjectRedAsset;
    import assets.objects.HorisontalObjectRedSelectAsset;
    import assets.objects.HorisontalObjectRedStandAsset;
    import assets.objects.HorisontalObjectYellowAsset;
    import assets.objects.HorisontalObjectYellowSelectAsset;
    import assets.objects.HorisontalObjectYellowStandAsset;
    import assets.objects.SimpleObjectBlueAsleepAsset;
    import assets.objects.SimpleObjectBlueAsset;
    import assets.objects.SimpleObjectBlueAwakeAsset;
    import assets.objects.SimpleObjectBlueDreamAsset;
    import assets.objects.SimpleObjectBlueDropAsset;
    import assets.objects.SimpleObjectBlueSelectAsset;
    import assets.objects.SimpleObjectBlueStandAsset;
    import assets.objects.SimpleObjectBlueWait1Asset;
    import assets.objects.SimpleObjectBlueWait2Asset;
    import assets.objects.SimpleObjectBlueWait3Asset;
    import assets.objects.SimpleObjectBlueWait4Asset;
    import assets.objects.SimpleObjectGreenAsleepAsset;
    import assets.objects.SimpleObjectGreenAsset;
    import assets.objects.SimpleObjectGreenAwakeAsset;
    import assets.objects.SimpleObjectGreenDreamAsset;
    import assets.objects.SimpleObjectGreenDropAsset;
    import assets.objects.SimpleObjectGreenSelectAsset;
    import assets.objects.SimpleObjectGreenStandAsset;
    import assets.objects.SimpleObjectGreenWait1Asset;
    import assets.objects.SimpleObjectGreenWait2Asset;
    import assets.objects.SimpleObjectGreenWait3Asset;
    import assets.objects.SimpleObjectGreenWait4Asset;
    import assets.objects.SimpleObjectOrangeAsleepAsset;
    import assets.objects.SimpleObjectOrangeAsset;
    import assets.objects.SimpleObjectOrangeAwakeAsset;
    import assets.objects.SimpleObjectOrangeDreamAsset;
    import assets.objects.SimpleObjectOrangeDropAsset;
    import assets.objects.SimpleObjectOrangeSelectAsset;
    import assets.objects.SimpleObjectOrangeStandAsset;
    import assets.objects.SimpleObjectOrangeWait1Asset;
    import assets.objects.SimpleObjectOrangeWait2Asset;
    import assets.objects.SimpleObjectOrangeWait3Asset;
    import assets.objects.SimpleObjectOrangeWait4Asset;
    import assets.objects.SimpleObjectPurpleAsleepAsset;
    import assets.objects.SimpleObjectPurpleAsset;
    import assets.objects.SimpleObjectPurpleAwakeAsset;
    import assets.objects.SimpleObjectPurpleDreamAsset;
    import assets.objects.SimpleObjectPurpleDropAsset;
    import assets.objects.SimpleObjectPurpleSelectAsset;
    import assets.objects.SimpleObjectPurpleStandAsset;
    import assets.objects.SimpleObjectPurpleWait1Asset;
    import assets.objects.SimpleObjectPurpleWait2Asset;
    import assets.objects.SimpleObjectPurpleWait3Asset;
    import assets.objects.SimpleObjectPurpleWait4Asset;
    import assets.objects.SimpleObjectRedAsleepAsset;
    import assets.objects.SimpleObjectRedAsset;
    import assets.objects.SimpleObjectRedAwakeAsset;
    import assets.objects.SimpleObjectRedDreamAsset;
    import assets.objects.SimpleObjectRedDropAsset;
    import assets.objects.SimpleObjectRedSelectAsset;
    import assets.objects.SimpleObjectRedStandAsset;
    import assets.objects.SimpleObjectRedWait1Asset;
    import assets.objects.SimpleObjectRedWait2Asset;
    import assets.objects.SimpleObjectRedWait3Asset;
    import assets.objects.SimpleObjectRedWait4Asset;
    import assets.objects.SimpleObjectYellowAsleepAsset;
    import assets.objects.SimpleObjectYellowAsset;
    import assets.objects.SimpleObjectYellowAwakeAsset;
    import assets.objects.SimpleObjectYellowDreamAsset;
    import assets.objects.SimpleObjectYellowDropAsset;
    import assets.objects.SimpleObjectYellowSelectAsset;
    import assets.objects.SimpleObjectYellowStandAsset;
    import assets.objects.SimpleObjectYellowWait1Asset;
    import assets.objects.SimpleObjectYellowWait2Asset;
    import assets.objects.SimpleObjectYellowWait3Asset;
    import assets.objects.SimpleObjectYellowWait4Asset;
    import assets.objects.VerticalObjectBlueAsset;
    import assets.objects.VerticalObjectBlueSelectAsset;
    import assets.objects.VerticalObjectBlueStandAsset;
    import assets.objects.VerticalObjectGreenAsset;
    import assets.objects.VerticalObjectGreenSelectAsset;
    import assets.objects.VerticalObjectGreenStandAsset;
    import assets.objects.VerticalObjectOrangeAsset;
    import assets.objects.VerticalObjectOrangeSelectAsset;
    import assets.objects.VerticalObjectOrangeStandAsset;
    import assets.objects.VerticalObjectPurpleAsset;
    import assets.objects.VerticalObjectPurpleSelectAsset;
    import assets.objects.VerticalObjectPurpleStandAsset;
    import assets.objects.VerticalObjectRedAsset;
    import assets.objects.VerticalObjectRedSelectAsset;
    import assets.objects.VerticalObjectRedStandAsset;
    import assets.objects.VerticalObjectYellowAsset;
    import assets.objects.VerticalObjectYellowSelectAsset;
    import assets.objects.VerticalObjectYellowStandAsset;

    import com.levelupers.marmalade_factory.Game.modules.StateMachine;

    import com.levelupers.marmalade_factory.Game.objects.models.HorisontalObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.SimpleObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.models.VerticalObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.views.HorisontalObjectView;
    import com.levelupers.marmalade_factory.Game.objects.views.SimpleObjectView;
    import com.levelupers.marmalade_factory.Game.objects.views.VerticalObjectView;

    public class ObjectsConfig
    {
        public static const SIDES:Array =
        [
            [-1, -1], [ 0, -1], [ 1, -1],
            [-1,  0],           [ 1,  0],
            [-1,  1], [ 0,  1], [ 1,  1]
        ];

        public static const OBJECT_VIEWS:Array =
        [
            [SimpleObjectModel,     SimpleObjectView],
            [VerticalObjectModel,   VerticalObjectView],
            [HorisontalObjectModel, HorisontalObjectView]
        ];

        public static const SIMPLE_BLUE_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      SimpleObjectBlueStandAsset,
            (StateMachine.STATE_WAIT_1.toString()):     SimpleObjectBlueWait1Asset,
            (StateMachine.STATE_WAIT_2.toString()):     SimpleObjectBlueWait2Asset,
            (StateMachine.STATE_WAIT_3.toString()):     SimpleObjectBlueWait3Asset,
            (StateMachine.STATE_WAIT_4.toString()):     SimpleObjectBlueWait4Asset,
            (StateMachine.STATE_ASLEEP.toString()):     SimpleObjectBlueAsleepAsset,
            (StateMachine.STATE_DREAM.toString()):      SimpleObjectBlueDreamAsset,
            (StateMachine.STATE_AWAKE.toString()):      SimpleObjectBlueAwakeAsset,
            (StateMachine.STATE_SELECT.toString()):     SimpleObjectBlueSelectAsset,
            (StateMachine.STATE_DROP.toString()):       SimpleObjectBlueDropAsset
        };

        public static const SIMPLE_ORANGE_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      SimpleObjectOrangeStandAsset,
            (StateMachine.STATE_WAIT_1.toString()):     SimpleObjectOrangeWait1Asset,
            (StateMachine.STATE_WAIT_2.toString()):     SimpleObjectOrangeWait2Asset,
            (StateMachine.STATE_WAIT_3.toString()):     SimpleObjectOrangeWait3Asset,
            (StateMachine.STATE_WAIT_4.toString()):     SimpleObjectOrangeWait4Asset,
            (StateMachine.STATE_ASLEEP.toString()):     SimpleObjectOrangeAsleepAsset,
            (StateMachine.STATE_DREAM.toString()):      SimpleObjectOrangeDreamAsset,
            (StateMachine.STATE_AWAKE.toString()):      SimpleObjectOrangeAwakeAsset,
            (StateMachine.STATE_SELECT.toString()):     SimpleObjectOrangeSelectAsset,
            (StateMachine.STATE_DROP.toString()):       SimpleObjectOrangeDropAsset
        };

        public static const SIMPLE_GREEN_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      SimpleObjectGreenStandAsset,
            (StateMachine.STATE_WAIT_1.toString()):     SimpleObjectGreenWait1Asset,
            (StateMachine.STATE_WAIT_2.toString()):     SimpleObjectGreenWait2Asset,
            (StateMachine.STATE_WAIT_3.toString()):     SimpleObjectGreenWait3Asset,
            (StateMachine.STATE_WAIT_4.toString()):     SimpleObjectGreenWait4Asset,
            (StateMachine.STATE_ASLEEP.toString()):     SimpleObjectGreenAsleepAsset,
            (StateMachine.STATE_DREAM.toString()):      SimpleObjectGreenDreamAsset,
            (StateMachine.STATE_AWAKE.toString()):      SimpleObjectGreenAwakeAsset,
            (StateMachine.STATE_SELECT.toString()):     SimpleObjectGreenSelectAsset,
            (StateMachine.STATE_DROP.toString()):       SimpleObjectGreenDropAsset
        };

        public static const SIMPLE_PURPLE_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      SimpleObjectPurpleStandAsset,
            (StateMachine.STATE_WAIT_1.toString()):     SimpleObjectPurpleWait1Asset,
            (StateMachine.STATE_WAIT_2.toString()):     SimpleObjectPurpleWait2Asset,
            (StateMachine.STATE_WAIT_3.toString()):     SimpleObjectPurpleWait3Asset,
            (StateMachine.STATE_WAIT_4.toString()):     SimpleObjectPurpleWait4Asset,
            (StateMachine.STATE_ASLEEP.toString()):     SimpleObjectPurpleAsleepAsset,
            (StateMachine.STATE_DREAM.toString()):      SimpleObjectPurpleDreamAsset,
            (StateMachine.STATE_AWAKE.toString()):      SimpleObjectPurpleAwakeAsset,
            (StateMachine.STATE_SELECT.toString()):     SimpleObjectPurpleSelectAsset,
            (StateMachine.STATE_DROP.toString()):       SimpleObjectPurpleDropAsset
        };

        public static const SIMPLE_RED_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      SimpleObjectRedStandAsset,
            (StateMachine.STATE_WAIT_1.toString()):     SimpleObjectRedWait1Asset,
            (StateMachine.STATE_WAIT_2.toString()):     SimpleObjectRedWait2Asset,
            (StateMachine.STATE_WAIT_3.toString()):     SimpleObjectRedWait3Asset,
            (StateMachine.STATE_WAIT_4.toString()):     SimpleObjectRedWait4Asset,
            (StateMachine.STATE_ASLEEP.toString()):     SimpleObjectRedAsleepAsset,
            (StateMachine.STATE_DREAM.toString()):      SimpleObjectRedDreamAsset,
            (StateMachine.STATE_AWAKE.toString()):      SimpleObjectRedAwakeAsset,
            (StateMachine.STATE_SELECT.toString()):     SimpleObjectRedSelectAsset,
            (StateMachine.STATE_DROP.toString()):       SimpleObjectRedDropAsset
        };

        public static const SIMPLE_YELLOW_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      SimpleObjectYellowStandAsset,
            (StateMachine.STATE_WAIT_1.toString()):     SimpleObjectYellowWait1Asset,
            (StateMachine.STATE_WAIT_2.toString()):     SimpleObjectYellowWait2Asset,
            (StateMachine.STATE_WAIT_3.toString()):     SimpleObjectYellowWait3Asset,
            (StateMachine.STATE_WAIT_4.toString()):     SimpleObjectYellowWait4Asset,
            (StateMachine.STATE_ASLEEP.toString()):     SimpleObjectYellowAsleepAsset,
            (StateMachine.STATE_DREAM.toString()):      SimpleObjectYellowDreamAsset,
            (StateMachine.STATE_AWAKE.toString()):      SimpleObjectYellowAwakeAsset,
            (StateMachine.STATE_SELECT.toString()):     SimpleObjectYellowSelectAsset,
            (StateMachine.STATE_DROP.toString()):       SimpleObjectYellowDropAsset
        };

        public static const VERTICAL_BLUE_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      VerticalObjectBlueStandAsset,
            (StateMachine.STATE_SELECT.toString()):     VerticalObjectBlueSelectAsset
        };

        public static const VERTICAL_ORANGE_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      VerticalObjectOrangeStandAsset,
            (StateMachine.STATE_SELECT.toString()):     VerticalObjectOrangeSelectAsset
        };

        public static const VERTICAL_GREEN_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      VerticalObjectGreenStandAsset,
            (StateMachine.STATE_SELECT.toString()):     VerticalObjectGreenSelectAsset
        };

        public static const VERTICAL_PURPLE_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      VerticalObjectPurpleStandAsset,
            (StateMachine.STATE_SELECT.toString()):     VerticalObjectPurpleSelectAsset
        };

        public static const VERTICAL_RED_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      VerticalObjectRedStandAsset,
            (StateMachine.STATE_SELECT.toString()):     VerticalObjectRedSelectAsset
        };

        public static const VERTICAL_YELLOW_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      VerticalObjectYellowStandAsset,
            (StateMachine.STATE_SELECT.toString()):     VerticalObjectYellowSelectAsset
        };

        public static const HORISONTAL_BLUE_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      HorisontalObjectBlueStandAsset,
            (StateMachine.STATE_SELECT.toString()):     HorisontalObjectBlueSelectAsset
        };

        public static const HORISONTAL_ORANGE_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      HorisontalObjectOrangeStandAsset,
            (StateMachine.STATE_SELECT.toString()):     HorisontalObjectOrangeSelectAsset
        };

        public static const HORISONTAL_GREEN_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      HorisontalObjectGreenStandAsset,
            (StateMachine.STATE_SELECT.toString()):     HorisontalObjectGreenSelectAsset
        };

        public static const HORISONTAL_PURPLE_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      HorisontalObjectPurpleStandAsset,
            (StateMachine.STATE_SELECT.toString()):     HorisontalObjectPurpleSelectAsset
        };

        public static const HORISONTAL_RED_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      HorisontalObjectRedStandAsset,
            (StateMachine.STATE_SELECT.toString()):     HorisontalObjectRedSelectAsset
        };

        public static const HORISONTAL_YELLOW_OBJECT_VIEWS:Object =
        {
            (StateMachine.STATE_STAND.toString()):      HorisontalObjectYellowStandAsset,
            (StateMachine.STATE_SELECT.toString()):     HorisontalObjectYellowSelectAsset
        };
    }
}
