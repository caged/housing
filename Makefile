DB_NAME=housing

all:

.SECONDARY:

gz/%.zip:
	mkdir -p $(dir $@)
	curl --remote-time 'http://www2.census.gov/geo/tiger/TIGER2010DP1/$(notdir $@)' -o $@.download
	mv $@.download $@

# Public Housing Authorities
# http://zillowhack.hud.opendata.arcgis.com/datasets/0e99651ec61242648f3128e8fd36be4d_0
json/zillow/public_housing_authorities.json:
	curl --create-dirs --remote-time "http://zillowhack.hud.opendata.arcgis.com/datasets/0e99651ec61242648f3128e8fd36be4d_0.geojson" -o $@.download
	mv $@.download $@

# Public Housing Developments
# http://zillowhack.hud.opendata.arcgis.com/datasets/1cef73e2612f4cf7a46f8e40108d72bc_0
json/zillow/public_housing_developments.json:
	curl --create-dirs --remote-time "http://zillowhack.hud.opendata.arcgis.com/datasets/1cef73e2612f4cf7a46f8e40108d72bc_0.geojson" -o $@.download
	mv $@.download $@

# Public Housing Buildings
# http://zillowhack.hud.opendata.arcgis.com/datasets/2a462f6b548e4ab8bfd9b2523a3db4e2_0
json/zillow/public_housing_buildings.json:
	curl --create-dirs --remote-time "http://zillowhack.hud.opendata.arcgis.com/datasets/2a462f6b548e4ab8bfd9b2523a3db4e2_0.geojson" -o $@.download
	mv $@.download $@

# Multi-family properties
# http://zillowhack.hud.opendata.arcgis.com/datasets/c55eb46fbc3b472cabd0c2a41f805261_0
json/zillow/multi_family_properties.geojson:
	curl --create-dirs --remote-time "http://zillowhack.hud.opendata.arcgis.com/datasets/c55eb46fbc3b472cabd0c2a41f805261_0.geojson" -o $@.download
	mv $@.download $@

# Location Affordability Index Data
# http://zillowhack.hud.opendata.arcgis.com/datasets/27b53ea69f98474eb002ac3b9c6b51eb_0
# http://lai.locationaffordability.info//lai_data_dictionary.pdf
json/zillow/location_affordability_index.geojson:
	curl --create-dirs --remote-time "http://zillowhack.hud.opendata.arcgis.com/datasets/27b53ea69f98474eb002ac3b9c6b51eb_0.geojson" -o $@.download
	mv $@.download $@

# Low-Income Housing Tax Credit (LIHTC)
# http://zillowhack.hud.opendata.arcgis.com/datasets/c0d79831f95c46018349657dc768ddc4_0
json/zillow/low_income_housing_tax_credit.geojson:
	curl --create-dirs --remote-time "http://zillowhack.hud.opendata.arcgis.com/datasets/c0d79831f95c46018349657dc768ddc4_0.geojson" -o $@.download
	mv $@.download $@

# Housing Choice Voucher Program (HCVP)
# http://zillowhack.hud.opendata.arcgis.com/datasets/42c4d3d6648c4d5196fa0002af457383_0
json/zillow/housing_choice_voucher_program.geojson:
	curl --create-dirs --remote-time "http://zillowhack.hud.opendata.arcgis.com/datasets/42c4d3d6648c4d5196fa0002af457383_0.geojson" -o $@.download
	mv $@.download $@

# Fair Market Rents (FMRs)
# http://zillowhack.hud.opendata.arcgis.com/datasets/e29dca94b6924766a124d7c767e03b75_0
json/zillow/fair_market_rents.geojson:
	curl --create-dirs --remote-time "http://zillowhack.hud.opendata.arcgis.com/datasets/e29dca94b6924766a124d7c767e03b75_0.geojson" -o $@.download
	mv $@.download $@

shp/us/places.shp: gz/Place_2010Census_DP1.zip
shp/us/states.shp: gz/State_2010Census_DP1.zip

# US Places with selected demographics - 2010 US Census
#
# http://www2.census.gov/geo/tiger/TIGER2010DP1/Place_2010Census_DP1.zip
shp/us/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar -xzm -C $(basename $@) -f $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)
