package assets.actionScript
{
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polyline;

	public class PathInfo
	{
		private var _segmentInfos 	: Array = new Array(); // of SegmentInfo
		private var _pathLength		: Number = 0;
		private var _fullPath		: Array;
		
		/**
		 * @param path: a PolyLine Path or a Polygon Ring (array of MapPoint)
		 **/
		public function PathInfo( path:Array )
		{
			_fullPath = path;

			// Create SegmentInfos
			for ( var iPoint:int = 0; iPoint < path.length - 1; iPoint++ ) {
				var startPoint:MapPoint = MapPoint( path[ iPoint ] );
				var endPoint  :MapPoint = MapPoint( path[ iPoint + 1 ] );
				// Add SegmentInfos to array
				addSegmentInfo( startPoint, endPoint );
			}
}
		
		private function addSegmentInfo( startPoint:MapPoint, endPoint:MapPoint ):void {
			var si:SegmentInfo = new SegmentInfo( startPoint, endPoint, _pathLength );
			_segmentInfos.push( si );
			_pathLength += si.segmentLength;
		}

		public function get pathLength():Number
		{
			return _pathLength;
		}

		public function get segmentInfos():Array
		{
			return _segmentInfos;
		}

		public function get fullPath():Array
		{
			return _fullPath;
		}

		/** Calculates and returns the specified portion of the segments in the original ring **/
		public function getPartialPath( nFractionOfOriginal:Number ):Array {
			var partialPath:Array = new Array();
			// Determine the appropriate portion
			var nRequestedPathLen:Number = nFractionOfOriginal * this.pathLength; 
			for ( var iSegment:int = 0; iSegment < this.segmentInfos.length; iSegment++ ) {
				// Add all segments up to the point exceeding the requested length
				var segment:SegmentInfo = this.segmentInfos[ iSegment ];
				partialPath.push( segment.startPoint );
				
				// If we've reached the last actual point, we may need to interpolate the next
				// This is what will keep the animation from jumping when iterating over long segments
				var bAnotherSegmentNeeded:Boolean = ( nRequestedPathLen > (segment.cumulativeDistanceFromStart + segment.segmentLength) );
				var bInterpolationNeeded:Boolean = 
					!bAnotherSegmentNeeded
					&& ( nRequestedPathLen != segment.cumulativeDistanceFromStart );
				if ( bInterpolationNeeded ) {
					// What's the shortfall?
					var nShortfall:Number = nRequestedPathLen - segment.cumulativeDistanceFromStart;
					// How much of this segment do we need?
					var nFractionOfSegmentNeeded:Number = nShortfall / segment.segmentLength;
					// Where's the appropriate end point?
					var nDeltaX:Number = (segment.endPoint.x - segment.startPoint.x) * nFractionOfSegmentNeeded;
					var nDeltaY:Number = (segment.endPoint.y - segment.startPoint.y) * nFractionOfSegmentNeeded;
					var newEndPoint:MapPoint = new MapPoint(segment.startPoint.x + nDeltaX, segment.startPoint.y + nDeltaY);
					partialPath.push( newEndPoint );
				}
				
				if ( !bAnotherSegmentNeeded ) break;
			}

			return partialPath;
		}

	}
}