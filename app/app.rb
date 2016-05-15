require_relative 'methods/sourcing'

test = Sourcing.new ({cible:["1","3"] , our_account:["1", "2","3"] })

test.source

p Account.all
