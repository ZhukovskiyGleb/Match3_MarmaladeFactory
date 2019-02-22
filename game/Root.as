/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 10:59
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game
{
    import assets.sounds.DropSound;
    import assets.sounds.FinalThemeSound;
    import assets.sounds.MainThemeSound;

    import com.levelupers.marmalade_factory.Game.controllers.BaseWindowController;
    import com.levelupers.marmalade_factory.Game.controllers.TutorialController;
    import com.levelupers.utils.sound.SoundManager;
    import com.levelupers.utils.sound.SoundMixingRule;

    import flash.display.Stage;

    public class Root
    {
        private static var _instance    :Root;

        private var _stage              :Stage;
        private var _controllers        :Vector.<BaseWindowController>;
        private var _fieldSize          :uint;

        public function Root()
        {

        }

        public function init(stage:Stage):void
        {
            _stage = stage;

            _controllers = new Vector.<BaseWindowController>();

            var rule1:SoundMixingRule = new SoundMixingRule(SoundMixingRule.SKIP_WHEN_GROUP_SOUND_PLAYED);
            rule1.addSounds([DropSound]);

            var rule2:SoundMixingRule = new SoundMixingRule(SoundMixingRule.MUTE_OTHERS);
            rule2.addSounds([MainThemeSound, FinalThemeSound]);

            SoundManager.addRule(rule1);
            SoundManager.addRule(rule2);

            selectWindow(TutorialController);
        }

        public function selectWindow(controllerClass:Class, over:Boolean = false, data:Object = null):void
        {
            if (!over)
                closeTopWindow();

            var controller:BaseWindowController = new (controllerClass as Class)(data) as BaseWindowController;
            controller.create();
            _stage.addChild(controller.view);

            _controllers.push(controller);
        }

        public function closeTopWindow():void
        {
            if (_controllers.length > 0)
            {
                var controller:BaseWindowController = _controllers[_controllers.length - 1];
                _stage.removeChild(controller.view);
                controller.clear();
                controller = null;
                _controllers.pop();
            }
        }

        public static function get instance():Root
        {
            return (_instance) ? _instance : _instance = new Root();
        }

    }
}
