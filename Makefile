all:

.SECONDARY:

gz/tiger/%.zip:
	mkdir -p $(dir $@)
	curl -L --remote-time 'http://www2.census.gov/geo/tiger/TIGER_DP/$(notdir $@)' -o $@.download
	mv $@.download $@

gz/metro/%.zip:
	mkdir -p $(dir $@)
	curl -L --remote-time 'http://library.oregonmetro.gov/rlisdiscovery/$(notdir $@)' -o $@.download
	mv $@.download $@

gz/pdx/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'ftp://ftp02.portlandoregon.gov/CivicApps/$(notdir $@)' -o $@.download
	mv $@.download $@

# Portland
shp/pdx/tsp_district_boundaries.shp: gz/pdx/TSP_District_Boundaries_pdx.zip
shp/pdx/streets.shp: gz/pdx/Streets_pdx.zip
shp/pdx/parks.shp: gz/pdx/Parks_pdx.zip

gz/tiger/acs_2013_5yr.zip:
	mkdir -p $(dir $@)
	curl -L --remote-time 'http://www2.census.gov/geo/tiger/TIGER_DP/2013ACS/ACS_2013_5YR_BG_41.gdb.zip' -o $@.download
	mv $@.download $@

gdb/tiger/acs_2013_5yr.gdb: gz/tiger/acs_2013_5yr.zip
	mkdir -p $(dir $@)
	tar -xzm -C $(dir $@) -f $<

csv/oregon_lai.csv:
	mkdir -p $(dir $@)
	curl -L --remote-time 'http://lai.locationaffordability.info//download_csv.php?state=41&geography=blkgrp' -o $@.download
	mv $@.download $@

# US Places with selected demographics - 2010 US Census
# http://www2.census.gov/geo/tiger/TIGER2010DP1/Place_2010Census_DP1.zip
shp/us/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar -xzm -C $(basename $@) -f $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)

shp/pdx/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar --exclude="._*" -xzm -C $(basename $@) -f $<

	for file in `find $(basename $@) -name '*.shp'`; do \
		ogr2ogr -dim 2 -f 'ESRI Shapefile' -t_srs 'EPSG:4326' $(basename $@).$${file##*.} $$file; \
		chmod 644 $(basename $@).$${file##*.}; \
	done
	rm -rf $(basename $@)
