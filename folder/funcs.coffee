@_ = lodash
@coll = {}

if Meteor.isClient
	@currentRoute = -> Router.current().route.getName()
	@currentPar = (name) -> Router.current().params[name]
