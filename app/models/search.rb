class Search < ActiveRecord::Base
  def self.store_query(search, request)
    search = self.new(:query => search, :request_ip => request.remote_ip)
    search.save!
  end
end
