/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 15.05.14
 * Time: 12:25
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.utils
{
    import com.google.analytics.AnalyticsTracker;
    import com.google.analytics.GATracker;
    import com.google.analytics.core.TrackerMode;
    import com.levelupers.utils.sound.SoundManager;
    import com.levelupers.utils.sound.StreamChannel;

    import flash.display.Stage;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    public class Analytics
    {
        static private const ID                         :String = 'UA-49615259-18';

        static private const CATEGORY_GAME_STATS        :String = 'GAME STATS';
        static private const ACTION_LEVEL_START         :String = 'Level starts';
        static private const ACTION_SESSION_TIME        :String = 'Session length';
        static private const ACTION_TOTAL_POINTS        :String = 'Points scored';
        static private const ACTION_GAME_BREAK          :String = 'Games quited';
        static private const ACTION_GAME_RESTART        :String = 'Games restarted';

        static private const CATEGORY_GAMEPLAY          :String = 'Gameplay';
        static private const ACTION_GAME_OPENED         :String = 'Game loaded';
        static private const ACTION_GAME_STARTED        :String = 'Game started';
        static private const ACTION_GAME_TUTORIAL_1     :String = 'Tutorial page 1 skipped';
        static private const ACTION_GAME_TUTORIAL_2     :String = 'Tutorial page 2 skipped';

        static private const CATEGORY_SOUNDS            :String = 'Sounds';
        static private const ACTION_MUSIC_MODE          :String = 'Music mode';
        static private const ACTION_SFX_MODE            :String = 'SFX mode';

        private static var _instance                    :Analytics;

        private var _tracker                            :AnalyticsTracker;

        private var _soundTracked                       :Boolean = false;
        private var _prevMusicMode                      :Boolean;
        private var _prevSfxMode                        :Boolean;
        private var _currentLevel                       :uint;
        private var _roundStartTime                     :uint;
        private var _statistic                          :Dictionary;

        public function init(stage:Stage, debug:Boolean = true):void
        {
            _tracker    = new GATracker(stage, ID, TrackerMode.AS3, debug);
            _tracker.setDomainName('none');
        }

        public function reportLevelStarted(level:uint):void
        {
            _currentLevel = level;

            if (level == 1)
            {
                _roundStartTime = getTimer();
                _statistic = new Dictionary();
            }

            track(CATEGORY_GAME_STATS, ACTION_LEVEL_START, currentLevel, 1);
        }

        public function reportLevelFinished():void
        {
            if (!_soundTracked || _prevMusicMode != SoundManager.isChannelEnabled(StreamChannel.BACKGROUND))
            {
                _prevMusicMode = SoundManager.isChannelEnabled(StreamChannel.BACKGROUND);
                track(CATEGORY_SOUNDS, ACTION_MUSIC_MODE, musicMode);
            }

            if (!_soundTracked || _prevSfxMode != SoundManager.isChannelEnabled(StreamChannel.SFX))
            {
                _prevSfxMode = SoundManager.isChannelEnabled(StreamChannel.SFX);
                track(CATEGORY_SOUNDS, ACTION_SFX_MODE, sfxMode);
            }

            _soundTracked = true;
        }

        public function reportGameFinished(score:uint):void
        {
            reportLevelFinished();

            track(CATEGORY_GAME_STATS, ACTION_SESSION_TIME, 'Seconds', int((getTimer() - _roundStartTime) / 1000));
            track(CATEGORY_GAME_STATS, ACTION_TOTAL_POINTS, currentLevel, score);
        }

        public function reportGameBreak():void
        {
            track(CATEGORY_GAME_STATS, ACTION_GAME_BREAK, currentLevel, 1);
        }

        public function reportGameRestarted():void
        {
            track(CATEGORY_GAME_STATS, ACTION_GAME_RESTART, null, 1);
        }

        public function reportGameOpened():void
        {
            track(CATEGORY_GAMEPLAY, ACTION_GAME_OPENED, null, 1);
        }

        public function reportGameStarted():void
        {
            track(CATEGORY_GAMEPLAY, ACTION_GAME_STARTED, null, 1);
        }

        public function reportTutorialSkipped(page:uint):void
        {
            if (page == 1)
                track(CATEGORY_GAMEPLAY, ACTION_GAME_TUTORIAL_1, null, 1);
            else if (page == 2)
                track(CATEGORY_GAMEPLAY, ACTION_GAME_TUTORIAL_2, null, 1);
        }

        private function track(category:String, action:String, label:String = null, value:Number = NaN):void
        {
            if (!_tracker)
                return;

            var result:Boolean = _tracker.trackEvent(category, action, label, value);
            if (!result)
                trace("Tracker [", category, "]:", action, (label) ? " (" + label + ")" : "", (value) ? "value = " + value : "", "result: ", result);
        }

        private function get currentLevel():String
        {
            return "Level " + _currentLevel;
        }

        private function get musicMode():String
        {
            return (SoundManager.isChannelEnabled(StreamChannel.BACKGROUND)) ? "ON" : "OFF";
        }

        private function get sfxMode():String
        {
            return (SoundManager.isChannelEnabled(StreamChannel.SFX)) ? "ON" : "OFF";
        }

        public static function get instance():Analytics
        {
            return (_instance) ? _instance : _instance = new Analytics();
        }
    }
}
