/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 29.05.14
 * Time: 13:21
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.configs
{
    import assets.connectors.ConnectorBlueAsset;
    import assets.connectors.ConnectorGreenAsset;
    import assets.connectors.ConnectorOrangeAsset;
    import assets.connectors.ConnectorPurpleAsset;
    import assets.connectors.ConnectorRedAsset;
    import assets.connectors.ConnectorYellowAsset;
    import assets.effects.IndicatorAsset;
    import assets.effects.MixingAsset;
    import assets.effects.SplashBlueAsset;
    import assets.effects.SplashGreenAsset;
    import assets.effects.SplashOrangeAsset;
    import assets.effects.SplashPurpleAsset;
    import assets.effects.SplashRedAsset;
    import assets.effects.SplashYellowAsset;
    import assets.effects.TextHintBlueAsset;
    import assets.effects.TextHintGreenAsset;
    import assets.effects.TextHintOrangeAsset;
    import assets.effects.TextHintPurpleAsset;
    import assets.effects.TextHintRedAsset;
    import assets.effects.TextHintYellowAsset;

    import com.levelupers.marmalade_factory.Game.effects.ImprovedHintEffect;

    import com.levelupers.marmalade_factory.Game.effects.ImprovedSpecialEffect;
    import com.levelupers.marmalade_factory.Game.effects.ImprovedSplashEffect;

    public class EffectsConfig
    {
        public static const TYPE_SPLASH     :String = 'splashEffectType';
        public static const TYPE_MIX        :String = 'mixEffectType';
        public static const TYPE_SPECIAL    :String = 'specialEffectType';
        public static const TYPE_HINT       :String = 'hintEffectType';

        public static const SPLASH_ASSETS  :Object =
        {
            (ColorsConfig.BLUE.toString())      : SplashBlueAsset,
            (ColorsConfig.GREEN.toString())     : SplashGreenAsset,
            (ColorsConfig.ORANGE.toString())    : SplashOrangeAsset,
            (ColorsConfig.PURPLE.toString())    : SplashPurpleAsset,
            (ColorsConfig.RED.toString())       : SplashRedAsset,
            (ColorsConfig.YELLOW.toString())    : SplashYellowAsset
        };

        public static const CONNECTOR_EFFECTS:Object =
        {
            (ColorsConfig.BLUE.toString())   : ConnectorBlueAsset,
            (ColorsConfig.GREEN.toString())  : ConnectorGreenAsset,
            (ColorsConfig.ORANGE.toString()) : ConnectorOrangeAsset,
            (ColorsConfig.PURPLE.toString()) : ConnectorPurpleAsset,
            (ColorsConfig.RED.toString())    : ConnectorRedAsset,
            (ColorsConfig.YELLOW.toString()) : ConnectorYellowAsset
        };

        public static const HINT_ASSETS:Object =
        {
            (ColorsConfig.BLUE.toString())   : TextHintBlueAsset,
            (ColorsConfig.GREEN.toString())  : TextHintGreenAsset,
            (ColorsConfig.ORANGE.toString()) : TextHintOrangeAsset,
            (ColorsConfig.PURPLE.toString()) : TextHintPurpleAsset,
            (ColorsConfig.RED.toString())    : TextHintRedAsset,
            (ColorsConfig.YELLOW.toString()) : TextHintYellowAsset
        };

        public static const SPLASH_EFFECT       :Class = ImprovedSplashEffect;

        public static const MIX_EFFECT          :Class = MixingAsset;

        public static const SPECIAL_EFFECT      :Class = ImprovedSpecialEffect;

        public static const HINT_EFFECT         :Class = ImprovedHintEffect;

        public static const MEDLEY_EFFECT       :String = 'medleyEffect'
    }
}
