Router.configure
	layoutTemplate: 'layout'

Router.route '/',
	action: -> this.render 'beranda'

_.map ['login', 'admin'], (i) ->
	Router.route '/'+i,
		action: -> this.render i

Router.route '/peta/:grup?/:item?',
	action: -> this.render 'peta'
	waitOn: -> if Meteor.isClient
		sel = grup: this.params.grup
		this.params.item and sel.item = this.params.item
		Meteor.subscribe 'coll', 'geojsons', sel, {}

coll.geojsons = new Meteor.Collection 'geojsons'
coll.geojsons.allow
	insert: -> true
	update: -> true
	remove: -> true
