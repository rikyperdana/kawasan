if Meteor.isServer

	Meteor.publish 'coll', (name, selector, modifier) ->
		coll[name].find selector, modifier

	Meteor.methods
		import: (name, selector, modifier) ->
			coll[name].upsert selector, modifier

		list: ->
			_.map coll.geojsons.find().fetch(), (i) ->
				_.pick i, ['grup', 'item']
