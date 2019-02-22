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

    public class VerticalObjectView extends BaseObjectView
    {
        public function VerticalObjectView(model:BaseObjectModel)
        {
            activateStates(STATE_STAND, STATE_SELECT);
            super(model);
        }

        override public function create():void
        {
            super.create();

            playState(STATE_STAND);
        }
    }
}
