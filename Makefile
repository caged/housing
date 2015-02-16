DB_NAME=housing

all:

.SECONDARY:

gz/tiger/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'http://www2.census.gov/geo/tiger/TIGER2010DP1/$(notdir $@)' -o $@.download
	mv $@.download $@

gz/metro/%.zip:
	mkdir -p $(dir $@)
	curl -L --remote-time 'http://library.oregonmetro.gov/rlisdiscovery/$(notdir $@)' -o $@.download
	mv $@.download $@

gz/pdx/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'ftp://ftp02.portlandoregon.gov/CivicApps/$(notdir $@)' -o $@.download
	mv $@.download $@

geojson/zillow/%.geojson:
	mkdir -p $(dir $@)
	curl --remote-time 'http://zillowhack.hud.opendata.arcgis.com/datasets/$(notdir $@)' -o $@.download
	mv $@.download $@

# Public Housing Authorities
# http://zillowhack.hud.opendata.arcgis.com/datasets/0e99651ec61242648f3128e8fd36be4d_0
topo/public_housing_authorities.json:	geojson/zillow/0e99651ec61242648f3128e8fd36be4d_0.geojson

# Public Housing Developments
# http://zillowhack.hud.opendata.arcgis.com/datasets/1cef73e2612f4cf7a46f8e40108d72bc_0
topo/public_housing_developments.json:	geojson/zillow/1cef73e2612f4cf7a46f8e40108d72bc_0.geojson

# Public Housing Buildings
# http://zillowhack.hud.opendata.arcgis.com/datasets/2a462f6b548e4ab8bfd9b2523a3db4e2_0
topo/public_housing_buildings.json:	geojson/zillow/2a462f6b548e4ab8bfd9b2523a3db4e2_0.geojson

# Multi-family properties
# http://zillowhack.hud.opendata.arcgis.com/datasets/c55eb46fbc3b472cabd0c2a41f805261_0
topo/multi_family_properties.json:	geojson/zillow/c55eb46fbc3b472cabd0c2a41f805261_0.geojson

# Location Affordability Index Data
# http://zillowhack.hud.opendata.arcgis.com/datasets/27b53ea69f98474eb002ac3b9c6b51eb_0
# http://lai.locationaffordability.info//lai_data_dictionary.pdf
topo/location_affordability_index.json:	geojson/zillow/27b53ea69f98474eb002ac3b9c6b51eb_0.geojson

# Low-Income Housing Tax Credit (LIHTC)
# http://zillowhack.hud.opendata.arcgis.com/datasets/c0d79831f95c46018349657dc768ddc4_0
topo/low_income_housing_tax_credit.json:	geojson/zillow/c0d79831f95c46018349657dc768ddc4_0.geojson

# Housing Choice Voucher Program (HCVP)
# http://zillowhack.hud.opendata.arcgis.com/datasets/42c4d3d6648c4d5196fa0002af457383_0
topo/housing_choice_voucher_program.json:	geojson/zillow/42c4d3d6648c4d5196fa0002af457383_0.geojson

# Fair Market Rents (FMRs)
# http://zillowhack.hud.opendata.arcgis.com/datasets/e29dca94b6924766a124d7c767e03b75_0
topo/fair_market_rents.json:	geojson/zillow/e29dca94b6924766a124d7c767e03b75_0.geojson

# US Census
shp/us/places.shp: gz/tiger/Place_2010Census_DP1.zip
shp/us/states.shp: gz/tiger/State_2010Census_DP1.zip

# Portland
shp/pdx/neighborhoods.shp: gz/pdx/Neighborhoods_pdx.zip
shp/pdx/tsp_district_boundaries.shp: gz/pdx/TSP_District_Boundaries_pdx.zip

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
