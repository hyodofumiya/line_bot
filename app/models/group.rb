class Group < ApplicationRecord
  require "net/http"

  has_many :user_groups
  has_many :users, through: :user_groups

  validates :line_id, uniqueness: true

  def self.add_new_group(group_line_id)
    #招待されたグループがDBに存在するかで条件分岐
    if Group.find_by(line_id: group_line_id).nil?
      group_name = get_group_name(group_line_id)
      response = Group.create(line_id: group_line_id, name: group_name) 
    end
    return response
  end
end

#グループの概要を取得してグルーム名を返すメソッド
def get_group_name(groupId)
  uri = URI.parse("https://api.line.me/v2/bot/group/#{groupId}/summary")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === "https"

  headers = { "Authorization: Bearer {channel access token}" } #channel access tokenの部分が認証済みアカウントになると取得できる
  req = Net::HTTP::GET.new(uri.path)
  req.initialize_http_header(headers)

  res = http.request(req)
  
  result = ActiveSupport::JSON.decode(res.body)
  group_name = result["groupName"]
  return group_name
end