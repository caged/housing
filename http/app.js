var map = d3.select('.js-map'),
    width = 1000,
    height = 1000

var path = d3.geo.path()
  .projection(null)

var svg = map.append('svg')
  .attr('width', width)
  .attr('height', height)

d3.json("data/c.json", function(err, pdx) {

  svg.append('path')
    .datum(topojson.feature(pdx, pdx.objects.parks))
    .attr('class', 'parks')
    .attr('d', path)

  svg.append('path')
    .datum(topojson.feature(pdx, pdx.objects.streets))
    .attr('class', 'streets')
    .attr('d', path)

  svg.append('path')
    .datum(topojson.feature(pdx, pdx.objects.buildings))
    .attr('class', 'buildings')
    .attr('d', path)

  svg.append('path')
    .datum(topojson.feature(pdx, pdx.objects.blockgroups))
    .attr('class', 'blockgroups')
    .attr('d', path)
})
