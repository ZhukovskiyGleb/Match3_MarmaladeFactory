/**
 * Created with IntelliJ IDEA.
 * User: Zhukovskiy Gleb
 * Date: 26.05.14
 * Time: 17:01
 * To change this template use File | Settings | File Templates.
 */
package com.levelupers.marmalade_factory.Game.modules
{
    import assets.effects.IndicatorAsset;
    import assets.selectors.CellSelectorAsset;

    import com.greensock.TweenMax;
    import com.levelupers.marmalade_factory.Game.objects.models.BaseObjectModel;
    import com.levelupers.marmalade_factory.Game.objects.views.BaseObjectView;
    import com.levelupers.marmalade_factory.Game.views.GameView;
    import com.levelupers.marmalade_factory.configs.EffectsConfig;
    import com.levelupers.marmalade_factory.configs.ObjectsConfig;

    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    public class FieldView extends EffectsManager
    {

        protected var _objectViews          :Vector.<BaseObjectView>;
        protected var _connectorViews       :Dictionary;
        protected var _specialViews         :Dictionary;

        public function FieldView(gameView:GameView)
        {
            _objectViews = new Vector.<BaseObjectView>();
            _connectorViews = new Dictionary(true);
            _specialViews = new Dictionary(true);

            gameView.addChild(this);
        }

        public function createObjectView(model:BaseObjectModel, delay:Number, position:Point):void
        {
            if (model.readyForDelete)
                return;

            var view:BaseObjectView;
            for each (var views:Array in ObjectsConfig.OBJECT_VIEWS)
            {
                if (model is views[0])
                    view = new (views[1] as Class)(model) as BaseObjectView;
            }

            _objectsLayer.addChild(view);
            _objectViews.push(view);

            var coordinates:Point;
            if (position)
                coordinates = getViewCoordinates(position);
            else
                coordinates = getViewCoordinates(model.position);

            view.x = coordinates.x;
            view.y = coordinates.y;

            view.addEventListener(Event.REMOVED_FROM_STAGE, view_removedFromStageHandler);

            TweenMax.to(view, delay, {onComplete: view.create});
        }

        override public function clear():void
        {
            if (parent)
                parent.removeChild(this);

            while (_objectViews.length > 0)
            {
                _objectViews[0].clear(false);
            }
            _objectViews = null;

            var key:String;
            for (key in _connectorViews)
            {
                delete _connectorViews[key];
            }
            _connectorViews = null;

            for (key in _specialViews)
            {
                delete _specialViews[key];
            }
            _specialViews = null;

            super.clear();
        }

        private function view_removedFromStageHandler(event:Event):void
        {
            var target:BaseObjectView = event.currentTarget as BaseObjectView;

            target.removeEventListener(Event.REMOVED_FROM_STAGE, view_removedFromStageHandler);
            _objectViews.splice(_objectViews.indexOf(target), 1);
        }

        public function addConnector(targets:Vector.<BaseObjectModel>):void
        {
            var connector:MovieClip = new (EffectsConfig.CONNECTOR_EFFECTS[targets[0].color] as Class)() as MovieClip;

            var connectorName:String = targets[0].position.x + '_' + targets[0].position.y;
            _connectorViews[connectorName] = connector;
            _connectorsLayer.addChild(connector);

            var coordinates:Point = getViewCoordinates(targets[0].position);

            connector.x = coordinates.x;
            connector.y = coordinates.y;

            var angle:int = Math.atan2(targets[1].position.y - targets[0].position.y, targets[1].position.x - targets[0].position.x) / Math.PI * 180;

            connector.rotation = angle;
        }

        public function removeConnector(object:BaseObjectModel):void
        {
            var connectorName:String = object.position.x + '_' + object.position.y;
            _connectorsLayer.removeChild(_connectorViews[connectorName]);
            delete _connectorViews[connectorName];
        }

        public function updateDepths():void
        {
            _objectViews.sort(sortDepthsFunction);

            for each (var object:BaseObjectView in _objectViews)
            {
                _objectsLayer.addChild(object);
            }
        }

        private function sortDepthsFunction(a:BaseObjectView, b:BaseObjectView):int
        {
            if (a.getPositionY() < b.getPositionY())
                return -1;
            else if (a.getPositionY() > b.getPositionY())
                return 1;
            else
                return 0;
        }

        public function addRemoveSpecial(add:Boolean, object:BaseObjectModel, delay:Number = .0):void
        {
            if (!object)
                return;

            var special:IndicatorAsset;
            var specialName:String = object.position.x + '_' + object.position.y;

            if (add)
            {
                special = new IndicatorAsset();

                _specialViews[specialName] = special;
                _connectorsLayer.addChildAt(special, 0);

                var coordinates:Point = getViewCoordinates(object.position);

                special.x = coordinates.x;
                special.y = coordinates.y;

                special.visible = false;

                TweenMax.to(_specialViews[specialName], delay, {onComplete: showSpecial, onCompleteParams:[specialName]});
            }
            else
            {
                if (!_specialViews[specialName])
                    return;
                TweenMax.to(_specialViews[specialName], delay, {onComplete: removeSpecial, onCompleteParams:[specialName]});
            }
        }

        private function showSpecial(specialName:String):void
        {
            if (_specialViews[specialName])
                _specialViews[specialName].visible = true;
        }

        private function removeSpecial(specialName:String):void
        {
            _connectorsLayer.removeChild(_specialViews[specialName]);
            delete _specialViews[specialName];
        }

        public function updateSpecialTargets(targets:Vector.<BaseObjectModel>):void
        {
            while (_specialTargetsLayer.numChildren > 0)
            {
                _specialTargetsLayer.removeChildAt(0);
            }

            var view:Sprite;

            for each (var target:BaseObjectModel in targets)
            {
                view = new CellSelectorAsset();
                _specialTargetsLayer.addChild(view);

                var position:Point = getViewCoordinates(target.position);

                view.x = position.x;
                view.y = position.y;
            }
        }
    }
}
