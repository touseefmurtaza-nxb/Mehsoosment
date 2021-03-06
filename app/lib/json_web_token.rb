class JsonWebToken
	class << self
		def encode(payload, exp = 1.month.from_now)
			payload[:exp] = exp.to_i
			JWT.encode(payload, Rails.application.secrets.secret_key_base)
		end

		def decode(token)
			body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
			HashWithIndifferentAccess.new body
		rescue Exception => e
			puts e.message
			e
		end
	end
end
