if Meteor.isClient

	Template.registerHelper 'startCase', (val) ->
		_.startCase val

	Template.menu.onRendered ->
		$('.collapsible').collapsible()
		Meteor.call 'list', (err, res) ->
			res and Session.set 'list', res

	Template.menu.helpers
		list: -> Session.get 'list'

	Template.peta.onRendered ->
		topo = L.tileLayer.provider 'OpenTopoMap'
		lay1 = L.geoJson coll.geojsons.findOne()
		map = L.map 'peta',
			center: [0.5, 101]
			zoom: 8
			zoomControl: false
			layers: [topo, lay1]

	Template.upload.events
		'change :file': (event) ->
			file = event.target.files[0]
			reader = new FileReader()
			reader.onload = ->
				split = _.split _.kebabCase(file.name), '-'
				if split[2] is 'geojson'
					name = grup: split[0], item: split[1]
					doc = _.assign name, JSON.parse reader.result
					Meteor.call 'import', 'geojsons', name, doc
			reader.readAsText file, 'UTF-8'
