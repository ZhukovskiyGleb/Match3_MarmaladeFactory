/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 17.04.14
 * Time: 12:11
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.utils
{
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;

    public class Localization
    {
        static public const EN                              :String = 'English';
        static public const RU                              :String = 'Russian';

        static public const BUTTON_PLAY_TEXT                :String = 'button_play_text';
        static public const BUTTON_NEXT_TEXT                :String = 'button_next_text';
        static public const BUTTON_RESTART_TEXT             :String = 'results_restart_text';

        static public const GUI_LEVEL_TEXT                  :String = 'gui_level_text';
        static public const GUI_MOVES_TEXT                  :String = 'gui_moves_text';
        static public const GUI_SCORE_TEXT                  :String = 'gui_score_text';

        static public const TUTORIAL_TITLE_TEXT             :String = 'tutorial_title_text';
        static public const TUTORIAL_INFO_PAGE1_TEXT        :String = 'tutorial_info_page1_text';
        static public const TUTORIAL_INFO_PAGE2_TEXT        :String = 'tutorial_info_page2_text';

        static public const RESULTS_TITLE_TEXT              :String = 'results_title_text';
        static public const RESULTS_NOW_TEXT                :String = 'results_now_text';
        static public const RESULTS_BEST_TEXT               :String = 'results_best_text';
        static public const RESULTS_SCORE_TEXT              :String = 'results_score_text';
        static public const RESULTS_MAX_CHAIN_TEXT          :String = 'results_max_chain_text';
        static public const RESULTS_AVERAGE_CHAIN_TEXT      :String = 'results_average_chain_text';
        static public const RESULTS_ELEMENTS_TEXT           :String = 'results_elements_text';
        static public const RESULTS_IMPROVED_TEXT           :String = 'results_improved_text';
        static public const RESULTS_RESTART_TEXT            :String = 'results_restart_text';

        [Embed(source='../../../../../res/en/strings.xml', mimeType='application/octet-stream')]
        static private const EN_Localization:Class;

        [Embed(source='../../../../../res/ru/strings.xml', mimeType='application/octet-stream')]
        static private const RU_Localization:Class;

        static private var _language:String;
        static private var _localization:XML;
        static private var _worlds:Dictionary;

        static public function select_lang(language:String):void
        {
            if (language == EN)
                _localization = new XML( new EN_Localization() );
            else if (language == RU)
                _localization = new XML( new RU_Localization() );

            _language = language;

            _worlds = new Dictionary();

            for each (var child:XML in _localization.string)
                _worlds[String(child.@name)] = child.toString();
        }

        static public function localize(tf:*, key:String, addText:String = ''):void
        {
            var text:String = getWord(key);

            if (!(tf is TextField))
                tf = TFSearcher.findInObject(tf);

            tf.mouseEnabled = false;
            tf.text = text + addText;

            if (tf.text.length > 3)
            {
                while ((!tf.multiline && tf.textWidth >= tf.width - 10) || (tf.multiline && tf.textHeight > tf.height - tf.numLines * 5))
                {
                    var tff:TextFormat = tf.getTextFormat();
                    tff.size = uint(tff.size) - 1;
                    tf.setTextFormat(tff);

//                    if (!tf.multiline)
//                        tf.y ++;
                }
            }
        }

        static private function getWord(key:String):String
        {
            if (!_localization)
                select_lang(EN);

            if (_worlds[key])
                return _worlds[key];
            else
                return 'ERROR LOC!';
        }

        public static function get language():String
        {
            return _language;
        }
    }
}
