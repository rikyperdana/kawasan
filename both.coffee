Router.configure
	layoutTemplate: 'layout'

Router.route '/',
	action: -> this.render 'beranda'

Router.route '/upload',
	action: -> this.render 'upload'

Router.route '/peta/:grup?/:item?',
	action: -> this.render 'peta'
	waitOn: -> if Meteor.isClient
		sel = grup: this.params.grup, item: this.params.item
		Meteor.subscribe 'coll', 'geojsons', sel, {}

coll.geojsons = new Meteor.Collection 'geojsons'
coll.geojsons.allow
	insert: -> true
	update: -> true
	remove: -> true
