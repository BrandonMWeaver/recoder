class User < ActiveRecord::Base

	has_secure_password
	has_many :posts

	def slug
		return self.username.gsub(' ', '-').downcase
	end

	def self.find_by_slug(string)
		return self.all.select { |instance| instance.slug == string }.first
	end

end
