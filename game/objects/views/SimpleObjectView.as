/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 28.05.14
 * Time: 16:49
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.objects.views
{
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;

    public class SimpleObjectView extends BaseObjectView
    {
        public function SimpleObjectView(model:BaseObjectModel)
        {
            activateStates(STATE_STAND, STATE_WAIT_1, STATE_WAIT_2, STATE_WAIT_3, STATE_WAIT_4, STATE_ASLEEP, STATE_DREAM, STATE_AWAKE, STATE_SELECT, STATE_DROP);
            super(model);
        }

        override public function create():void
        {
            super.create();

            playState(STATE_STAND);
        }
    }
}
