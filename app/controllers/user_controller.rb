class UserController < ApplicationController
  require 'line/bot'
  protect_from_forgery :except => [:callback]

  def new
  end

  def create
  end

  def user_check_bot
    binding.pry

  end

  private

end

