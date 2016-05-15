require_relative "../models/account"

class Sourcing

  def initialize(arguments)

    # @client = Twitter::REST::Client.new do |config|
    #   config.consumer_key        = "11AalVKHieDRCx9SlDcEyt2Tp"
    #   config.consumer_secret     = "hD4cC7yJuQGt4khpaieQWMtA8rrGhtGbWGPNeAAzS31sRvYSYn"
    #   config.access_token        = "4864258233-J6fMZlvuHg45XyrlK1frGM86j875Ta3LR8Jv9fG"
    #   config.access_token_secret = "dAWesD89G6ZuxISj8uRveaYzwDBd8J3IBuTgVrYB4eE5O"
    # end

    @cible_id = 1   #arguments [:cible]

    @cible = arguments[:cible]                    #@client.follower_ids(arguments[:cible], options = {})
    @our_account = arguments[:our_account]             #@client.follower_ids(arguments[:our_account], options = {})
  end

  def source
  #1 - Récupérer les id sources et les passer dans un tableau
    cible_array = []
    @cible.each do |number|
      cible_array.push(number)
    end
  #2 - Récupérer les id de nos followers et les passer dans un tableau
    our_account_array = []
    @our_account.each do |number|
      our_account_array.push(number)
    end
  #3 - Updater nos followers dans notre base
    update(our_account_array)
  #4 - Ajouter a la base le follower du compte sible si pas encore présent
    cible_array.each do |target_id|
      if !Account.exists?(:user_id => target_id)
        Account.create(user_id: target_id, subscribed_id:@cible_id )
      end
    end
  end

# une methode permettant de mettre a jour nos followers dans la base
# Traite les nouveaux follow et les un-follow
# Prend en entrée un tableau des ids de nos followers issu d'une requete twitter
# et les compare aux comptes de la base avec is_following = true
  def update(our_current_followers) #an array of id
    #update externe
    our_current_followers.each do |follower_id|
      if Account.exists?(:user_id => follower_id)
        account = Account.find_by(user_id: follower_id)
        if !account.is_following
          account.is_following = true
          account.save
        end
      else
        Account.create({user_id: follower_id, subscribed_id: "naturel", is_following: true})
      end
    end
    # update interne, changer le "is-following" si le compte nous a unfollow
    # et passe le statut a UNFOLLOWER
    my_previous_followers = Account.where(is_following: true)
    my_previous_followers.each do |follower|
      if !our_current_followers.include?(follower.user_id)
          account = Account.find_by(user_id: follower.user_id)
          account.is_following = false
          account.status = "UNFOLLOWER"
          account.save
      end
    end
  end
end
