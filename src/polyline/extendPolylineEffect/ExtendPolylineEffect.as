package polyline.extendPolylineEffect
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Polyline;
	
	import mx.effects.IEffectInstance;
	import mx.effects.TweenEffect;

	public class ExtendPolylineEffect extends TweenEffect
	{
		// Effect parameters.
		// Animate through entire line extent by default
		// (Duration is already present in the superclass)
		private var _pctStart:Number = 0;
		private var _pctEnd:Number = 100;
		private var _alsoAnimateAlpha:Boolean = false;
		private var _playReverseDirection:Boolean = false;
		
		public function ExtendPolylineEffect(target:Graphic = null)
		{
			super(target);
			
			instanceClass = ExtendPolylineEffectInstance;
		}
	
		public function get playReverseDirection():Boolean
		{
			return _playReverseDirection;
		}

		/**
		 * If true, animates the line in the reverse direction (end to start).
		 * This is most useful when using polylines with arrowheads.
		 * <p/>
		 * See <a href="http://thunderheadxpler.blogspot.com/2009/02/line-style-with-arrows.html" target="_blank"> Mansour Raad's arrowhead line style</a>
		 * @default false
		 **/
		public function set playReverseDirection(value:Boolean):void
		{
			_playReverseDirection = value;
		}

		[Deprecated(replacement="a parallel fade effect (<a href='http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/effects/Parallel.html' target='_blank'>http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/mx/effects/Parallel.html</a>)", since="v1.1, 2011")]
		public function get alsoAnimateAlpha():Boolean
		{
			return _alsoAnimateAlpha;
		}
		/**
		 * If true, the polyline starts the animation transparent and transitions to fully opaque
		 * by the end of the animation. If false, the polyline starts and ends fully opaque.
		 * 
		 * @default false
		 **/
		public function set alsoAnimateAlpha(value:Boolean):void
		{
			_alsoAnimateAlpha = value;
		}

		public function get pctEnd():Number
		{
			return _pctEnd;
		}

		/**
		 * The value (percentage of the line's length) at which to end the animation.
		 * The default is 100 and generally should not be changed.
		 * 
		 * @default 100
		 **/
		public function set pctEnd(value:Number):void
		{
			_pctEnd = value;
		}

		public function get pctStart():Number
		{
			return _pctStart;
		}

		/**
		 * The value (percentage of the line's length) at which to start the animation.
		 * The default is 0 (zero) and generally should not be changed.
		 * 
		 * @default 0
		 **/
		public function set pctStart(value:Number):void
		{
			_pctStart = value;
		}

		override public function getAffectedProperties():Array {
			// Polylines have no simple properties this effect can manipulate to extend them
			return [];
		}
		
		override public function set target(value:Object):void {
//			var bNewTarget:Boolean = ( value !== super.target );
			super.target  = value;
//			if ( value != null && value is Graphic && bNewTarget ) 
//				gatherPolylineInfo();
		}
		
		override protected function initInstance(instance:IEffectInstance):void {
			super.initInstance(instance);
			
			var pei:ExtendPolylineEffectInstance = ExtendPolylineEffectInstance(instance);

			var pln:Polyline = instance.target.geometry as Polyline;
			pei.pctStart = pctStart;
			pei.pctEnd = pctEnd;
			pei.alsoAnimateAlpha = alsoAnimateAlpha;
			pei.playReverseDirection = playReverseDirection;
			pei.gatherPolylineInfo();
		}
		
	}
}
