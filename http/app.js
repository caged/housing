var map = d3.select('.js-map'),
    width = 800,
    height = 800

var path = d3.geo.path()
  .projection(null)

var svg = map.append('svg')
  .attr('width', width)
  .attr('height', height)

d3.json("data/se.json", function(err, pdx) {
// Hardcoded bg median income extents from the entire Portland area
var extent = [1368.33492, 207549.87568],
    extentr = [1302.11322, 145312.92241]

var color = d3.scale.linear()
  .domain(extent)
  .range(["hsl(62,100%,90%)", "hsl(228,30%,20%)"])
  .interpolate(d3.interpolateCubehelix)

svg.append('path')
  .datum(topojson.merge(pdx, pdx.objects.blockgroups.geometries))
  .attr('class', 'land')
  .attr('d', path)

  svg.selectAll('.blockgroups')
    .data(topojson.feature(pdx, pdx.objects.blockgroups).features)
  .enter().append('path')
    .attr('class', 'blockgroups')
    .attr('d', path)
    .style('fill', function(d) {
      return color(d.properties.bmio)
    })

  svg.append('path')
    .datum(topojson.feature(pdx, pdx.objects.parks))
    .attr('class', 'parks')
    .attr('d', path)

  svg.append('path')
    .datum(topojson.feature(pdx, pdx.objects.rivers))
    .attr('class', 'rivers')
    .attr('d', path)

  svg.append('path')
    .datum(topojson.feature(pdx, pdx.objects.streets))
    .attr('class', 'streets')
    .attr('d', path)

  svg.append('path')
    .datum(topojson.feature(pdx, pdx.objects.buildings))
    .attr('class', 'buildings')
    .attr('d', path)
})
