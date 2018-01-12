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
		fillColor = (val) ->
			find = _.find colors, (i) -> i.item is val
			find.color
		baseMaps = Topo: L.tileLayer.provider 'OpenTopoMap'
		overLays = {}
		map = L.map 'peta',
			center: [0.5, 101]
			zoom: 8
			zoomControl: false
			layers:	_.map coll.geojsons.find().fetch(), (i) ->
				geojson = L.geoJson i,
					style: (feature) ->
						fillColor: fillColor feature.properties.F_Prbhn
						weight: 2
						opacity: 1
						color: 'white'
						dashArray: '3'
						fillOpacity: 0.7
					onEachFeature: (feature, layer) ->
						layer.on
							mouseover: (event) ->
								event.target.setStyle
									weight: 3
									dashArray: ''
								event.target.bringToFront()
							mouseout: (event) ->
								geojson.resetStyle event.target
							click: (event) ->
								map.fitBounds event.target.getBounds()
						layer.bindPopup ->
							content = ''
							for key, val of feature.properties
								content += '<b>Data '+key+'</b>'+': '+val+'</br>'
							content
				overLays[_.startCase(i.item)] = geojson
				geojson
		baseMaps.Topo.addTo map
		layerControl = L.control.layers baseMaps, overLays
		layerControl.addTo map

	Template.upload.events
		'change :file': (event) ->
			file = event.target.files[0]
			reader = new FileReader()
			reader.onload = ->
				split = _.split _.kebabCase(file.name), '-'
				if split[2] is 'geojson'
					name = grup: split[0], item: split[1]
					doc = _.assign name, JSON.parse reader.result
					Meteor.call 'import', 'geojsons', name, doc, (err, res) ->
						res and Materialize.toast 'Unggah Berhasil', 3000, 'orange'
			reader.readAsText file, 'UTF-8'
