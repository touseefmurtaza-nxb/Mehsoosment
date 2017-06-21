class AuthenticateUser
	prepend SimpleCommand

	def initialize(uuid,pin)
		@uuid = uuid
		@pin = pin
	end

	def call
		JsonWebToken.encode(user_id: user.id) if user
	end

	private
	attr_accessor :uuid, :pin

	def user
		user = User.find_by_uuid(uuid)
		return user if user

		errors.add :user_authentication, 'invalid credentials'
		nil
	end

end