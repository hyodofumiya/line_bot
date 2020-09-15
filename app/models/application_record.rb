class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  #lineAPIを使用するためのclientを定義
  def self.client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.line_channel[:secret]
      config.channel_token = Rails.application.credentials.line_channel[:token]
    } 
  end

end
