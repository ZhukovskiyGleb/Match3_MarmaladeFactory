/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 12:37
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.configs
{
    public class GameConfig
    {
        public static const SCORE_FOR_LEVEL             :Array = [0,    20000,  50000,  100000,     150000,     250000,     400000,     int.MAX_VALUE];
        public static const FIELD_SIZES                 :Array = [6,    6,      7,      8,          8,          9,          9];
        public static const AVAILABLE_COLORS            :Array = [3,    4,      4,      4,          5,          5,          6];

        public static const CELL_SIZE                   :uint = 60;

        public static const START_MOVES                 :uint = 60;

        public static const MIN_LENGTH                  :uint = 3;

        public static const MIN_WAIT_TIME               :uint = 1000;
        public static const ADD_WAIT_TIME               :uint = 1000;
        public static const MIN_ANIMATE_OBJECTS         :uint = 1;
        public static const ADD_ANIMATE_OBJECTS         :uint = 2;

        public static const OBJECTS_NEED_FOR_SPECIAL    :uint = 6;

        public static const CELL_CLICK_PENALTY          :Number = .15;

        public static const FINAL_SPECIALS_AMOUNT       :uint = 10;
    }
}
