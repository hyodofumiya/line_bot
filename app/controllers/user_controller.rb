class UserController < ApplicationController
  require 'line/bot'
  require 'net/https'
  require 'uri'
  require 'json'

  def new
  end

  def create
  end

  def user_check_bot
    user_id_token = params[:user_token]
    get_user_id_from_token(user_id_token)
  end

  private
  #userIDのトークンからuserIDを取得する関数
  def get_user_id_from_token(user_id_token)
    uri = URI.parse('https://api.line.me/oauth2/v2.1/verify')
    http = Net::HTTP.new(uri.host, uri.port)


    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)

    req.set_form_data({"id_token":user_id_token, "client_id":"1654154094"})
    binding.pry
    res = http.request(req)
    binding.pry
  end

end

