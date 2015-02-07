all:

.SECONDARY:

gz/zillow/%.zip:
	mkdir -p $(dir $@)
	curl -L --remote-time 'http://zillowhack.hud.opendata.arcgis.com/datasets/$(notdir $@)' -o $@.download
	mv $@.download $@

# Public Housing Developments
# http://zillowhack.hud.opendata.arcgis.com/datasets/1cef73e2612f4cf7a46f8e40108d72bc_0
shp/public_housing_developments.shp: gz/zillow/1cef73e2612f4cf7a46f8e40108d72bc_0.zip

# Public Housing Authorities
# http://zillowhack.hud.opendata.arcgis.com/datasets/0e99651ec61242648f3128e8fd36be4d_0
shp/public_housing_authorities.shp: gz/zillow/0e99651ec61242648f3128e8fd36be4d_0.zip

# Public Housing Buildings
# http://zillowhack.hud.opendata.arcgis.com/datasets/2a462f6b548e4ab8bfd9b2523a3db4e2_0
shp/public_housing_buildings.shp: gz/zillow/2a462f6b548e4ab8bfd9b2523a3db4e2_0.zip

# Multi-family properties
# http://zillowhack.hud.opendata.arcgis.com/datasets/c55eb46fbc3b472cabd0c2a41f805261_0
shp/multi_family_properties.shp: gz/zillow/c55eb46fbc3b472cabd0c2a41f805261_0.zip

# Location Affordability Index Data
# http://zillowhack.hud.opendata.arcgis.com/datasets/27b53ea69f98474eb002ac3b9c6b51eb_0
shp/location_affordability_index.shp: gz/zillow/27b53ea69f98474eb002ac3b9c6b51eb_0.zip

# Low-Income Housing Tax Credit (LIHTC)
# http://zillowhack.hud.opendata.arcgis.com/datasets/c0d79831f95c46018349657dc768ddc4_0
shp/low_income_housing_tax_credit.shp: gz/zillow/c0d79831f95c46018349657dc768ddc4_0.zip

# Housing Choice Voucher Program (HCVP)
# http://zillowhack.hud.opendata.arcgis.com/datasets/42c4d3d6648c4d5196fa0002af457383_0
shp/housing_choice_voucher_program.shp: gz/zillow/42c4d3d6648c4d5196fa0002af457383_0.zip

# Fair Market Rents (FMRs)
# http://zillowhack.hud.opendata.arcgis.com/datasets/e29dca94b6924766a124d7c767e03b75_0
shp/fair_market_rents.shp: gz/zillow/e29dca94b6924766a124d7c767e03b75_0.zip

shp/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar -xzm -C $(basename $@) -f $<
	for file in $(basename $@)/*; do chmod 644 $$file; mv $$file $(basename $@).$${file##*.}; done
	rmdir $(basename $@)
