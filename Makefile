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

# USGS NED n46w123 1/3 arc-second 2013 1 x 1 degree IMG
gz/usgs/pdx_ned.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'ftp://rockyftp.cr.usgs.gov/vdelivery/Datasets/Staged/NED/13/IMG/n46w123.zip' -o $@.download
	mv $@.download $@

# Portland
shp/pdx/tsp_district_boundaries.shp: gz/pdx/TSP_District_Boundaries_pdx.zip
shp/pdx/streets.shp: gz/pdx/Streets_pdx.zip
shp/pdx/parks.shp: gz/pdx/Parks_pdx.zip
shp/pdx/buildings.shp: gz/pdx/Building_Footprints_pdx.zip
shp/pdx/buildings.shp: gz/pdx/Building_Footprints_pdx.zip
shp/pdx/rivers.shp: gz/metro/mjriv_fi.zip

tif/hillshade.tif: gz/usgs/pdx_ned.zip
	rm -rf $(basename $@)
	mkdir -p $(basename $@)

	tar -xzm -C $(basename $@) -f $<

	gdalwarp \
		-overwrite \
		-s_srs EPSG:4269 \
		-t_srs EPSG:2913 \
		-of GTiff \
		$(basename $@)/imgn46w123_13.img \
		$@.reprojected

	gdaldem hillshade \
		$@.reprojected $@ \
		-z 1.0 -s 1.0 -az 315.0 -alt 45.0 \
		-compute_edges \
		-of GTiff

	rm $@.reprojected
	rm -rf $(basename $@)

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

shp/pdx/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar --exclude="._*" -xzm -C $(basename $@) -f $<

	for file in `find $(basename $@) -name '*.shp'`; do \
		ogr2ogr -dim 2 -f 'ESRI Shapefile' -t_srs 'EPSG:4326' $(basename $@).$${file##*.} $$file; \
		chmod 644 $(basename $@).$${file##*.}; \
	done
	rm -rf $(basename $@)
