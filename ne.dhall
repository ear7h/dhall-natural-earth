let T = ./tegola.dhall
let Prelude = https://prelude.dhall-lang.org/package.dhall
let Zoom =
	{ scale : Text
	, min_zoom : Natural
	, max_zoom : Natural
	, dont_simplify : Optional Bool
	}
let Layer =
	{ Type =
		{ name : Text
		, tablename : Optional Text
		, fields : List Text
		, zoom : List Zoom
		}
	, default =
		{ fields = [] : List Text
		, tablename = None Text
		}
	}

let zoom110 =
	{ scale = "110m"
	, min_zoom = 0
	, max_zoom = 2
	, dont_simplify = None Bool
	}

let zoom50 =
	{ scale = "50m"
	, min_zoom = 3
	, max_zoom = 4
	, dont_simplify = None Bool
	}

let zoom10 =
	{ scale = "10m"
	, min_zoom = 5
	, max_zoom = 10
	, dont_simplify = None Bool
	}


let layers : List Layer.Type =
	[ Layer::
		{ name = "country_label_points"
		, tablename = Some "admin_0_label_points"
		, fields = [ "sr_subunit" ]
		, zoom = [ zoom10 // { min_zoom = 0 } ]
		}
	, Layer::
		{ name = "state_label_points"
		, tablename = Some "admin_1_label_points"
		, fields = [ "name" ]
		, zoom = [ zoom10 // { min_zoom = 0 } ]
		}
	, Layer::
		{ name = "boundary_lines_land"
		, tablename = Some "admin_0_boundary_lines_land"
		, fields = [ "name" ]
		, zoom = [ zoom10, zoom50 ]
		}
	, Layer::
		{ name = "boundary_lines_disputed"
		, tablename = Some "admin_0_boundary_lines_disputed_areas"
		, fields = [ "name" ]
		, zoom = [ zoom10, zoom50 ]
		}
	, Layer::
		{ name = "parks_and_protected_lands_area"
		, fields = [ "name" ]
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "parks_and_protected_lands_line"
		, fields = [ "name" ]
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "parks_and_protected_lands_point"
		, fields = [ "name" ]
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "map_units"
		, tablename = Some "admin_0_boundary_lines_map_units"
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "boundary_lines_maritime"
		, tablename = Some "admin_0_boundary_lines_maritime_indicator"
		, zoom = [ zoom10, zoom50 ]
		}
	, Layer::
		{ name = "countries"
		, tablename = Some "admin_0_countries"
		, fields = [ "name", "name_long", "abbrev", "adm0_a3" ]
		, zoom = [ zoom10, zoom50, zoom110 ]
		}
	, Layer::
		{ name = "admin_0_map_subunits"
		, fields = [ "type", "abbrev" ]
		, zoom = [ zoom10, zoom50 ]
		}
	, Layer::
		{ name = "states_provinces"
		, tablename = Some "admin_1_states_provinces_lines"
		, fields = [ "name", "adm0_name" ]
		, zoom = [ zoom10, zoom50, zoom110 ]
		}
	, Layer::
		{ name = "populated_places"
		, fields = [ "name" ]
		, zoom = [ zoom10, zoom50, zoom110 ]
		}
	, Layer::
		{ name = "roads"
		, fields = [ "name", "type", "label", "label2" ]
		, zoom = [ zoom10 // { min_zoom = 3 } ]
		}
	, Layer::
		{ name = "urban_areas"
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "geographic_lines"
		, fields = [ "name" ]
		, zoom = [ zoom10, zoom50 ]
		}
	, Layer::
		{ name = "coastline"
		, zoom = [ zoom10, zoom50, zoom110 ]
		}
	, Layer::
		{ name = "antarctic_ice_shelves_lines"
		, zoom = [ zoom10, zoom50 ]
		}
	, Layer::
		{ name = "antarctic_ice_shelves_polys"
		, zoom = [ zoom10, zoom50 ]
		}
	, Layer::
		{ name = "marine_polys"
		, tablename = Some "geography_marine_polys"
		, fields = [ "name" ]
		, zoom = [ zoom10, zoom50, zoom110 ]
		}
	, Layer::
		{ name = "elevation_points"
		, tablename = Some "geography_regions_elevation_points"
		, fields = [ "name", "elevation" ]
		, zoom = [ zoom10, zoom50 ]
		}
	, Layer::
		{ name = "geography_regions_points"
		, fields = [ "name" ]
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "geography_regions_polys"
		, fields = [ "name" ]
		, zoom = [ zoom10, zoom50, zoom110 ]
		}
	, Layer::
		{ name = "rivers_lake_centerlines_scale_rank"
		, fields = [ "name" ]
		, zoom = [ zoom10, zoom50 ]
		}
	, Layer::
		{ name = "rivers_north_america"
		, fields = [ "name" ]
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "rivers_europe"
		, fields = [ "name" ]
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "rivers_lake_centerlines"
		, fields = [ "name" ]
		, zoom = [ zoom10, zoom50, zoom110 ]
		}
	, Layer::
		{ name = "lakes_historic"
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "lakes"
		, fields = [ "name" ]
		, zoom = [ zoom10, zoom50, zoom110 ]
		}
	, Layer::
		{ name = "lakes_north_america"
		, fields = [ "name" ]
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "lakes_europe"
		, fields = [ "name" ]
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "reefs"
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "playas"
		, fields = [ "name" ]
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "glaciated_areas"
		, zoom = [ zoom10, zoom50, zoom110 ]
		}
	, Layer::
		{ name = "land"
		, zoom = [ zoom10, zoom50, zoom110 // { dont_simplify = Some True } ]
		}
	, Layer::
		{ name = "minor_islands"
		, zoom = [ zoom10 ]
		}
	, Layer::
		{ name = "ocean"
		, zoom = [ zoom10, zoom50, zoom110 // { dont_simplify = Some True } ]
		}
	]

let mkGeoPkgLayer : Layer.Type -> List T.GeoPkgLayer = \(l : Layer.Type) ->
	Prelude.List.map
		Zoom
		T.GeoPkgLayer
		(\(d : Zoom) -> T.GeoPkgLayer.Table
			{ name = "ne_${d.scale}_${l.name}"
			, tablename = "ne_${d.scale}_${Prelude.Optional.default Text l.name l.tablename}"
			, fields = Some l.fields
			, id_fieldname = None Text
			})
		l.zoom

let mkMapLayer : Layer.Type -> List T.MapLayer.Type = \(l : Layer.Type) ->
	Prelude.List.map
		Zoom
		T.MapLayer.Type
		(\(d : Zoom) -> T.MapLayer::
			{ name = Some l.name
			, provider_layer = "ne.ne_${d.scale}_${l.name}"
			, min_zoom = Some d.min_zoom
			, max_zoom = Some d.max_zoom
			, dont_simplify = d.dont_simplify
			})
		l.zoom

in
	{ tile_buffer = Some 64
	, webserver = T.Webserver::{ port = Some ":8080" }
	, cache = if (env:TEGOLA_CHACHE ? False) then Some (T.Cache.File T.FileCache::
		{ max_zoom = 5
		, basepath = "./tegola-cache/"
		}) else None T.Cache
	, providers =
		[ T.Provider.GeoPkg T.GeoPkg::
			{ name = "ne"
			, filepath = "./ne.gpkg"
			, layers = Prelude.List.concat
				T.GeoPkgLayer
				(Prelude.List.map
					Layer.Type
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
					Layer.Type
					(List T.MapLayer.Type)
					mkMapLayer
					layers)
			}
		]
	} : T.Tegola
