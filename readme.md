

**Example:**

Download and import Location Affordability Index data into postgres

```
make geojson/zillow/27b53ea69f98474eb002ac3b9c6b51eb_0.geojson
./script/pgsql-import -d housing -i geojson/zillow/27b53ea69f98474eb002ac3b9c6b51eb_0.geojson
```
