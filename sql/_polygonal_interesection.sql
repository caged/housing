-- Native st_intersection can return points and linestrings that we're not
-- really interested in.  This will return only polygons.
CREATE OR REPLACE FUNCTION PolygonalIntersection(a geometry(MultiPolygon, 4326), b geometry(MultiPolygon, 4326))
RETURNS geometry(MultiPolygon, 4326) AS $$
SELECT ST_Collect(geom)
FROM
(SELECT (ST_Dump(ST_Intersection(a, b))).geom
UNION ALL
-- union in an empty polygon so we get an
-- empty geometry instead of NULL if there
-- is are no polygons in the intersection
SELECT ST_GeomFromText('POLYGON EMPTY')) SQ
WHERE ST_GeometryType(geom) = 'ST_Polygon';
$$ LANGUAGE SQL;
