/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 12:14
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.utils
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.text.TextField;

    public class TFSearcher
    {
        public function TFSearcher()
        {
        }

        public static function findInObject(object:DisplayObjectContainer):TextField
        {
            var result:TextField;
            var childNum:int = object.numChildren - 1;
            var child:DisplayObject;
            while (childNum >= 0)
            {
                child = object.getChildAt(childNum);
                if (child is TextField)
                    result = child as TextField;
                else if (child is DisplayObjectContainer)
                    result = findInObject(child as DisplayObjectContainer);

                if (result)
                    return result;

                childNum --;
            }

            return result;
        }

    }
}
