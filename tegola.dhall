let WebserverHeaders =
	{ Access-Control-Allow-Origin  : Optional Text
	, Access-Control-Allow-Methods : Optional Text
	}

let Webserver =
	{ Type =
		{ port       : Optional Text
		, hostname   : Optional Text
		, uri_prefix : Optional Text
		, headers    : Optional WebserverHeaders
		}
	, default =
		{ port       = None Text
		, hostname   = None Text
		, uri_prefix = None Text
		, headers    = None WebserverHeaders
		}
	}

let ProviderBase =
	{ name : Text
	, type : Text
	}

let LayerSource =
	< Table :
		{ table  : Text
		, fields : Optional (List Text)
		}
	| SQL : Text
	>


let PostGISLayer =
	< Table :
		{ name : Text
		, tablename : Text
		, fields : Optional (List Text)
		, id_fieldname : Optional Text
		, geometry_fieldname : Optional Text
		, srid : Optional Natural
		, geometry_type : Text
		}
	| SQL :
		{ name : Text
		, sql : Text
		, id_fieldname : Optional Text
		, geometry_fieldname : Optional Text
		, srid : Optional Natural
		, geometry_type : Text
		}
	>

let PostGIS =
	{ Type =
		ProviderBase //\\
		{ host            : Text
		, port            : Optional Natural
		, database        : Text
		, user            : Text
		, password        : Text
		, srid            : Optional Natural
		, max_connections : Optional Natural
		, layers          : List PostGISLayer
		}
	, default =
		{ type            = "postgis"
		, port            = None Natural
		, srid            = None Natural
		, max_connections = None Natural
		}
	}

let GeoPkgLayer =
	< Table :
		{ name : Text
		, tablename : Text
		, fields : Optional (List Text)
		, id_fieldname : Optional Text
		}
	| SQL :
		{ name : Text
		, sql : Text
		, id_fieldname : Optional Text
		}
	>

let GeoPkg =
	{ Type =
		ProviderBase //\\
		{ filepath : Text
		, layers   : List GeoPkgLayer
		}
	, default =
		{ type = "gpkg"
		}
	}

let Provider =
	< PostGIS : PostGIS.Type
	| GeoPkg  : GeoPkg.Type
	>

let BBox =
	{ left   : Double
	, bottom : Double
	, right  : Double
	, top    : Double
	}

let Point =
	{ lon  : Double
	, lat  : Double
	, zoom : Double
	}

let MapLayer =
	{ Type =
		{ provider_layer : Text
		, name           : Optional Text
		, min_zoom       : Optional Natural
		, max_zoom       : Optional Natural
		, default_tags   : Optional (List Text)
		, dont_simplify  : Optional Bool
		}
	, default =
		{ name          = None Text
		, min_zoom      = None Natural
		, max_zoom      = None Natural
		, default_tags  = None (List Text)
		, dont_simplify = None Bool
		}
	}

let Map =
	{ Type =
		{ name        : Text
		, attribution : Optional Text
		, bounds      : Optional BBox
		, center      : Optional Point
		, tile_buffer : Optional Natural
		, layers      : List MapLayer.Type
		}
	, default =
		{ attribution = None Text
		, bounds      = None BBox
		, center      = None Point
		, tile_buffer = None Natural
		}
	}


let CacheBase =
	{ max_zoom : Natural
	}

let FileCache =
	{ Type =
		CacheBase //\\
		{ type     : < file >
		, basepath : Text
		}
	, default = { type = < file >.file }
	}

let RedisNetwork =
	< tcp
	| unix
	>

let RedisCache =
	{ Type =
		CacheBase //\\
		{ type     : < redis >
		, network  : Optional RedisNetwork
		, address  : Optional Text
		, password : Optional Text
		, db       : Optional Natural
		}
	, default = { type = < redis >.redis }
	}

let S3Cache =
	{ Type =
		CacheBase //\\
		{ type                  : < s3 >
		, bucket                : Text
		, basepath              : Optional Text
		, region                : Optional Text
		, aws_access_key_id     : Optional Text
		, aws_secret_access_key : Optional Text
		}
	, default = { type = < s3 >.s3 }
	}

let Cache =
	< File : FileCache.Type
	| Redis : RedisCache.Type
	| S3 : S3Cache.Type
	>

let Tegola =
	{ tile_buffer : Optional Natural
	, webserver   : Webserver.Type
	, cache       : Optional Cache
	, providers   : List Provider
	, maps        : List Map.Type
	}
in
	{ Tegola
	, Webserver
	, WebserverHeaders
	, CacheBase
	, FileCache
	, RedisNetwork
	, RedisCache
	, S3Cache
	, Cache
	, LayerSource
	, PostGIS
	, PostGISLayer
	, GeoPkg
	, GeoPkgLayer
	, Provider
	, Map
	, MapLayer
	, BBox
	, Point
	}
