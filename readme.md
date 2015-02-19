### Portland Area Blockgroup Statistics

I'm not sure what's going to surface from this, but currently it's a way to load and inspect thousands of datapoints per blockgroup for Portland.

* Around 188 different metrics from the United States Department of Housing and Urban Development.
* Over 5,000 different metrics from the 2009-2013 American Community Survey 5-Year Estimates.

### Requirements

* PostgreSQL
* PostGIS
* GDAL
* Node (for topojson generation)

### A few commands

These aren't all that versatile just yet, but here are the basic scripts.
``` bash
# Import all data to postgres
script/import-psql -d DATABASE_NAME

# Export blockgroups, streets, parks, rivers and buildings to a single topojson file per TSP district.
script/export-topojson -d DATABASE_NAME -o OUTPUT_FILE/STDOUT -a PDX_TSP_AREA

# Preview exported topojson
script/server
```
