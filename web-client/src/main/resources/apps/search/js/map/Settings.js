OpenLayers.DOTS_PER_INCH = 90.71;
//OpenLayers.ImgPath = '../js/OpenLayers/theme/default/img/';
OpenLayers.ImgPath = '../js/OpenLayers/img/';

OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;

// Define a constant with the base url to the MapFish web service.
//mapfish.SERVER_BASE_URL = '../../../../../'; // '../../';

// Remove pink background when a tile fails to load
OpenLayers.Util.onImageLoadErrorColor = "transparent";

// Lang
OpenLayers.Lang.setCode(GeoNetwork.defaultLocale);

OpenLayers.Util.onImageLoadError = function () {
	this._attempts = (this._attempts) ? (this._attempts + 1) : 1;
	if (this._attempts <= OpenLayers.IMAGE_RELOAD_ATTEMPTS) {
		this.src = this.src;
	} else {
		this.style.backgroundColor = OpenLayers.Util.onImageLoadErrorColor;
		this.style.display = "none";
	}
};

// add Proj4js.defs here
// Proj4js.defs["EPSG:27572"] = "+proj=lcc +lat_1=46.8 +lat_0=46.8 +lon_0=0 +k_0=0.99987742 +x_0=600000 +y_0=2200000 +a=6378249.2 +b=6356515 +towgs84=-168,-60,320,0,0,0,0 +pm=paris +units=m +no_defs";
Proj4js.defs["EPSG:2154"] = "+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs";
Proj4js.defs["EPSG:4171"] = "+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs";

GeoNetwork.map.printCapabilities = "../../pdf";

GeoNetwork.map.PROJECTION = "EPSG:4326";
//GeoNetwork.map.EXTENT = new OpenLayers.Bounds(4.6,45.5,5.2,46);
GeoNetwork.map.EXTENT = new OpenLayers.Bounds(3.7,44.5,6,47);

/*
var scales = [1000, 2500.5, 5000.5, 10001, 25000.5, 50000.5, 100001, 250000, 500000, 1000000];
var resolutions = [];
for(var i = 0; i < scales.length; i++) {
    resolutions.push(OpenLayers.Util.getResolutionFromScale(scales[i], 'degrees'));
}
GeoNetwork.map.BACKGROUND_LAYERS = [
 new OpenLayers.Layer.WMS("Fond de carte OSM",
"http://openstreetmap.data.grandlyon.com/", {layers: 'osm_grandlyon', format:
'image/png'}, {isBaseLayer: true, resolutions: resolutions})
 ];
*/

var osmLayer = new OpenLayers.Layer.WMS( "osm_grandlyon-RGF93-WMS",
       "http://openstreetmap.data.grandlyon.com/?",{layers: 'osm_grandlyon'},
       { gutter:0,buffer:0,isBaseLayer:true,transitionEffect:'resize',
         resolutions:[0.00251994577818355836,0.00125997288909177918,0.00062998644454588959,0.00025199709776413397,0.00012599854888206699,0.00006299990442747805,0.00002520197772761375,0.00001260098886380688,0.00000630112441834799,0.00000251994577818356],
         units:"dd",
         //maxExtent: new OpenLayers.Bounds(-9.620000,41.180000,10.300000,51.540000),
         projection: new OpenLayers.Projection("EPSG:4326".toUpperCase()),
         sphericalMercator: false
       }
   );

GeoNetwork.map.BACKGROUND_LAYERS = [osmLayer];


GeoNetwork.map.CONTEXT_MAP_OPTIONS = {
 controls: [],
 theme:null
};

GeoNetwork.map.CONTEXT_MAIN_MAP_OPTIONS = {
 controls: [],
 theme:null
};

GeoNetwork.map.MAP_OPTIONS = {
 projection: GeoNetwork.map.PROJECTION,
 maxExtent: GeoNetwork.map.EXTENT,
 restrictedExtent: GeoNetwork.map.EXTENT,
 resolutions: GeoNetwork.map.RESOLUTIONS,
 controls: [],
 theme:null
};

GeoNetwork.map.MAIN_MAP_OPTIONS = {
 projection: GeoNetwork.map.PROJECTION,
 maxExtent: GeoNetwork.map.EXTENT,
 restrictedExtent: GeoNetwork.map.EXTENT,
 resolutions: GeoNetwork.map.RESOLUTIONS,
 controls: [],
 theme:null
};
