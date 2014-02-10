package polygon.radarTrace
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	
	import mx.effects.effectClasses.TweenEffectInstance;
	import assets.actionScript.PathInfo;
	
	public class RadarTrace_Percent_EffectInstance extends TweenEffectInstance
	{
		public var pctStart:int;
		public var pctEnd:int;
		
		private var _geomOriginal	: Polygon;
		public  var ringInfos		: Array; // of PathInfo
		
		public function RadarTrace_Percent_EffectInstance(target:Graphic)
		{
			super(target);
			_geomOriginal = Polygon(target.geometry);
		}
		
		override public function set target(value:Object):void {
			_geomOriginal = Graphic(value).geometry as Polygon;
			super.target = value;
		}
		
		override public function play():void {
			createTween( this, pctStart, pctEnd, duration );
		}
		
		override public function onTweenUpdate(value:Object):void {
			var g:Graphic = Graphic(target);
			var nFraction:Number = Number(value) / 100;
			
			// Create a new polygon which we'll construct and return
			var poly:Polygon = new Polygon( new Array(), _geomOriginal.spatialReference );
			var rings:Array = poly.rings;
			
/*			for each ( var originalRing:Array in _geomOriginal.rings ) {
				var partialRing:Array;
				const startAndEndPoint:MapPoint = new Polygon( [ originalRing ], _geomOriginal.spatialReference ).extent.center;
				var iRingPoints:int = originalRing.length;
				
				partialRing = originalRing.slice(
					(pctStart / 100)	* iRingPoints,
					(nPercent			* iRingPoints) + 1
				);
				
				// Add centroid as start and end point
				partialRing.unshift( startAndEndPoint );
//				partialRing.push( startAndEndPoint );
				// Add ring to rings
				rings.push( partialRing );
			}*/
			for each ( var ring:PathInfo in ringInfos ) {
				const startAndEndPoint:MapPoint = new Polygon( [ ring.fullPath ], _geomOriginal.spatialReference ).extent.center;
				// Create the appropriate portion of that ring
				var partialRing:Array = ring.getPartialPath( nFraction );
				// Add centroid as start point
				partialRing.unshift( startAndEndPoint );
				// Add ring to rings
				rings.push( partialRing );
			}
			
			// Assume the value is an already-instantiated graphic; just replace the geometry
			g.geometry = poly;
		}
		
		override public function onTweenEnd(value:Object):void {
			// Restore the original, full geometry
			super.onTweenEnd(value);
			Graphic(target).geometry = _geomOriginal;
		}
		
		public function gatherPolygonInfo():void {
			ringInfos = new Array();
			var geom:Polygon = Polygon(target.geometry);
			for ( var iRing:int = 0; iRing < geom.rings.length; iRing++ ) {
				var ring:Array = geom.rings[ iRing ];
				
				// Create RingInfo
				var ringInfo:PathInfo = new PathInfo( ring );
				
				// Add RingInfo to array
				ringInfos.push( ringInfo );
			}
		}
		
	}
}