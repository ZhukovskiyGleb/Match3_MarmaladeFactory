package com.levelupers.marmalade_factory {

    import com.levelupers.marmalade_factory.Game.Root;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;

    [Frame(factoryClass='com.levelupers.marmalade_factory.Preloader')]
    [SWF(width="800", height="600", backgroundColor="#FFFFFF", frameRate="30")]
    public class Marmalade_factory extends Sprite
    {
        public function Marmalade_factory()
        {
            if (stage)
                startGame();
            else
                addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }

        private function startGame():void
        {
            Root.instance.init(stage);
        }

        private function addedToStageHandler(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            startGame();
        }
    }
}
