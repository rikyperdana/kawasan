@_ = lodash
@coll = {}

if Meteor.isClient
	@currentPar = (name) -> Router.current().params[name]
