require 'rubygems'
require 'httparty' 

class Outlook 
  include HTTParty
  base_uri = 'outlook.office.com/api/v2.0/'

  def posts 
    self.class.get('me/messages')
  end
end