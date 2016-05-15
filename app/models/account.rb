require_relative "../../config/application.rb"

class Account < ActiveRecord::Base
   validates :user_id, presence:true, uniqueness: true
end



