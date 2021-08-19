let T = ./tegola.dhall
let Prelude = https://prelude.dhall-lang.org/package.dhall
-- this record associates a scale (ex. 10m, 50m, 110m) with a specifc
-- zoom range
let Zoom =
	{ scale : Text
	, min_zoom : Natural
	, max_zoom : Natural
	}
-- the unified layer definition
let Layer =
	-- name is the map layer name, note that the tablename is a predictable
	-- combination of the zoom scale and the name
	{ name : Text
	-- zoom is a list of the desired scale-zoom mappings
	, zoom : List Zoom
	}
let mkGeoPkgLayer : Layer -> List T.GeoPkgLayer = \(l : Layer) ->
	Prelude.List.map
		Zoom
		T.GeoPkgLayer
		(\(d : Zoom) -> T.GeoPkgLayer.Table
			{ name = "ne_${d.scale}_${l.name}"
			, tablename = "ne_${d.scale}_${l.name}"
			, fields = None (List Text)
			, id_fieldname = None Text
			})
		l.zoom
let mkMapLayer : Layer -> List T.MapLayer.Type = \(l : Layer) ->
	Prelude.List.map
		Zoom
		T.MapLayer.Type
		(\(d : Zoom) -> T.MapLayer::
			{ name = Some l.name
			, provider_layer = "ne.ne_${d.scale}_${l.name}"
			, min_zoom = Some d.min_zoom
			, max_zoom = Some d.max_zoom
			})
		l.zoom

let zoom110 =
	{ scale = "110m"
	, min_zoom = 0
	, max_zoom = 2
	}

let zoom50 =
	{ scale = "50m"
	, min_zoom = 3
	, max_zoom = 4
	}

let zoom10 =
	{ scale = "10m"
	, min_zoom = 5
	, max_zoom = 10
	}

let layers : List Layer =
	[
		{ name = "coastline"
		, zoom = [ zoom10, zoom50, zoom110 ]
		} : Layer
	,
		{ name = "admin_0_countries"
		, zoom = [ zoom10, zoom50, zoom110 ]
		} : Layer
	,
		{ name = "admin_0_label_points"
		-- using Dhall's // operator we can override the default values we
		-- set for ourselves
		, zoom = [ zoom10 // { min_zoom = 0 } ]
		}
	]
in
	{ tile_buffer = Some 64
	, webserver = T.Webserver::{ port = Some ":8080" }
	, cache = None T.Cache
	, providers =
		[ T.Provider.GeoPkg T.GeoPkg::
			{ name = "ne"
			, filepath = "./ne.gpkg"
			, layers = Prelude.List.concat
				T.GeoPkgLayer
				(Prelude.List.map
					Layer
					(List T.GeoPkgLayer)
					mkGeoPkgLayer
					layers)
			}
		]
	, maps =
		[ T.Map::
			{ name = "natural"
			, layers = Prelude.List.concat
				T.MapLayer.Type
				(Prelude.List.map
					Layer
					(List T.MapLayer.Type)
					mkMapLayer
					layers)
			}
		]
	} : T.Tegola
