-- See: https://trac.osgeo.org/postgis/wiki/UserWikiRandomPoint
--
-- Return 10 random points/rows
-- SELECT ST_AsText(RandomPointsInPolygon('POLYGON ((10 20, 30 60, 50 20, 10 20))', 10));

-- Or 10 random points as a single MultiPoint
-- SELECT ST_AsText(ST_Union(geom))
-- FROM RandomPointsInPolygon('POLYGON ((10 20, 30 60, 50 20, 10 20))', 10) AS geom

-- CREATE TABLE india_random_points
-- (
--   gid serial NOT NULL,
--   CONSTRAINT india_random_points_pkey PRIMARY KEY (gid)
-- );
-- SELECT AddGeometryColumn('india_random_points', 'geom', 4326, 'POINT', 2);

-- -- Populate table with 10000 random points within India
-- INSERT INTO india_random_points(geom)
-- SELECT RandomPointsInPolygon(geom, 10000)
-- FROM world WHERE name='INDIA';

CREATE OR REPLACE FUNCTION RandomPointsInPolygon(geom geometry, num_points integer)
  RETURNS SETOF geometry AS
$BODY$DECLARE
  target_proportion numeric;
  n_ret integer := 0;
  loops integer := 0;
  x_min float8;
  y_min float8;
  x_max float8;
  y_max float8;
  srid integer;
  rpoint geometry;
BEGIN
  -- Get envelope and SRID of source polygon
  SELECT ST_XMin(geom), ST_YMin(geom), ST_XMax(geom), ST_YMax(geom), ST_SRID(geom)
    INTO x_min, y_min, x_max, y_max, srid;
  -- Get the area proportion of envelope size to determine if a
  -- result can be returned in a reasonable amount of time
  SELECT ST_Area(geom)/ST_Area(ST_Envelope(geom)) INTO target_proportion;
  RAISE DEBUG 'geom: SRID %, NumGeometries %, NPoints %, area proportion within envelope %',
                srid, ST_NumGeometries(geom), ST_NPoints(geom),
                round(100.0*target_proportion, 2) || '%';
  IF target_proportion < 0.0001 THEN
    RAISE EXCEPTION 'Target area proportion of geometry is too low (%)',
                    100.0*target_proportion || '%';
  END IF;
  RAISE DEBUG 'bounds: % % % %', x_min, y_min, x_max, y_max;

  WHILE n_ret < num_points LOOP
    loops := loops + 1;
    SELECT ST_SetSRID(ST_MakePoint(random()*(x_max - x_min) + x_min,
                                   random()*(y_max - y_min) + y_min),
                      srid) INTO rpoint;
    IF ST_Contains(geom, rpoint) THEN
      n_ret := n_ret + 1;
      RETURN NEXT rpoint;
    END IF;
  END LOOP;
  RAISE DEBUG 'determined in % loops (% efficiency)', loops, round(100.0*num_points/loops, 2) || '%';
END$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
