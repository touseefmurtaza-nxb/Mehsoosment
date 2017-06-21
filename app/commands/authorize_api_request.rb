class AuthorizeApiRequest
	prepend SimpleCommand

	def initialize(headers = {})
		@headers = headers
	end

	def call
		user
	end

	private

	attr_reader :headers

	def user
		if (decoded_auth_token.try(:message) == "Signature has expired")
			return 'Expired' # Token Expired
		elsif (decoded_auth_token.try(:message) == "Signature verification raised")
			return 'Invalid' # Invalid Token
		else
			@user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
			@user || errors.add(:token, 'Invalid token') && nil
		end
	end

	def decoded_auth_token
		@decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
	end

	def http_auth_header
		if headers['Authorization'].present?
			return headers['Authorization'].split(' ').last
		else
			errors.add(:token, 'Missing token')
		end
		nil
	end
end