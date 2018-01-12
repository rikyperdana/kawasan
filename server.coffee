if Meteor.isServer

	Meteor.publish 'coll', (name, selector, modifier) ->
		coll[name].find selector, modifier

	Meteor.methods
		import: (name, selector, modifier) ->
			coll[name].upsert selector, modifier

		list: ->
			map = _.map coll.geojsons.find().fetch(), (i) ->
				_.pick i, ['grup', 'item']
			arr = []
			for key, val of _.groupBy(map, 'grup')
				arr.push
					grup: key
					items: _.map val, (j) -> j.item
			arr
