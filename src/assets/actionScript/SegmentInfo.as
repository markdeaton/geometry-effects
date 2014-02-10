package assets.actionScript
{
	import com.esri.ags.geometry.MapPoint;

	public class SegmentInfo
	{
		private var _startPoint:MapPoint;
		private var _endPoint:MapPoint;
		private var _segmentLength:Number;
		
		private var _cumulativeDistanceFromStart:Number;

		public function SegmentInfo( startPoint:MapPoint, endPoint:MapPoint, prevSegmentCumulativeDistance:Number )
		{
			if ( startPoint == null || endPoint == null )
				throw new Error( "Two valid points are necessary to create a segment" );
			
			_startPoint = startPoint;
			_endPoint = endPoint;
			updateSegmentLength();
			_cumulativeDistanceFromStart = prevSegmentCumulativeDistance;// + _segmentLength;
		}

		public function get startPoint():MapPoint
		{
			return _startPoint;
		}

		public function get endPoint():MapPoint
		{
			return _endPoint;
		}

		public function get segmentLength():Number
		{
			return _segmentLength;
		}


		private function updateSegmentLength():void {
			_segmentLength = Math.sqrt(
				Math.pow( _endPoint.x - _startPoint.x, 2 ) + Math.pow( _endPoint.y - _startPoint.y, 2 )					
			);
		}

		public function get cumulativeDistanceFromStart():Number
		{
			return _cumulativeDistanceFromStart;
		}

	}
}