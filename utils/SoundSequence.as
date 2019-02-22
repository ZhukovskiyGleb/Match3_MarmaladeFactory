/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 02.06.14
 * Time: 17:15
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.utils
{
    import assets.sounds.JellyConnectN1Sound;
    import assets.sounds.JellyConnectN2Sound;
    import assets.sounds.JellyConnectN3Sound;
    import assets.sounds.JellyConnectN4Sound;
    import assets.sounds.JellyConnectN5Sound;
    import assets.sounds.JellyConnectN6Sound;
    import assets.sounds.JellyConnectN7Sound;
    import assets.sounds.JellyConnectN8Sound;

    public class SoundSequence
    {

        private static const JELLY_CONNECT:Array =
        [
            JellyConnectN1Sound,
            JellyConnectN2Sound,
            JellyConnectN3Sound,
            JellyConnectN4Sound,
            JellyConnectN5Sound,
            JellyConnectN6Sound,
            JellyConnectN7Sound/*,
            JellyConnectN8Sound
            JellySelectSound,
            JellyConnect2Sound,
            JellyConnect3Sound,
            JellyConnect4Sound,
            JellyConnect5Sound,
            JellyConnect6Sound,
            JellyConnect7Sound,
            JellyConnect8Sound,
            JellyConnect9Sound,
            JellyConnect10Sound,
            JellyConnect11Sound,
            JellyConnect12Sound,
            JellyConnect13Sound,
            JellyConnect14Sound*/
        ];

        private static var _jellyCounter:int;

        public static function get jellyConnectSound():Class
        {
            _jellyCounter ++;
            if (_jellyCounter >= JELLY_CONNECT.length)
                _jellyCounter = JELLY_CONNECT.length - 1;

            return JELLY_CONNECT[_jellyCounter];
        }

        public static function get jellyConnectPrevSound():Class
        {
            _jellyCounter --;
            if (_jellyCounter <= 0)
                _jellyCounter = 0;

            return JELLY_CONNECT[_jellyCounter];
        }

        public static function refresh():void
        {
            _jellyCounter = -1;
        }
    }
}
