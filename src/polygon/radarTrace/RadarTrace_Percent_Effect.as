package polygon.radarTrace
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	
	import mx.effects.IEffectInstance;
	import mx.effects.TweenEffect;
	import assets.actionScript.PathInfo;
	
	public class RadarTrace_Percent_Effect extends TweenEffect
	{
		private var _pctStart		: int = 0;
		private var _pctEnd			: int = 100;
		
		public function RadarTrace_Percent_Effect(
			target:Graphic=null, 
			duration:Number = NaN,
			pctStart:int = 0, pctEnd:int = 100
			)
		{
			super(target);
			super.duration = duration;
			instanceClass = RadarTrace_Percent_EffectInstance;
		}

		public function get pctStart():int
		{
			return _pctStart;
		}

		public function set pctStart(value:int):void
		{
			_pctStart = value;
		}

		public function get pctEnd():int
		{
			return _pctEnd;
		}

		public function set pctEnd(value:int):void
		{
			_pctEnd = value;
		}

		override public function set target(value:Object):void {
			super.target = value;
		}
		
		override protected function initInstance(instance:IEffectInstance):void {
			super.initInstance( instance );
			
			var rtei:RadarTrace_Percent_EffectInstance = RadarTrace_Percent_EffectInstance( instance );
			rtei.pctStart = this.pctStart;
			rtei.pctEnd = this.pctEnd;
			rtei.gatherPolygonInfo();
		}

	}
}