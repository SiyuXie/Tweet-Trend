json.array!(@userinfos) do |userinfo|
  json.extract! userinfo, :id, :user_name, :country, :city, :age
  json.url userinfo_url(userinfo, format: :json)
end
