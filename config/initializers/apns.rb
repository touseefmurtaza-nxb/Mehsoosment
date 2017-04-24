if Rails.env == "development"
  APNS.host = 'gateway.sandbox.push.apple.com'
  # gateway.sandbox.push.apple.com is default and only for development
  # gateway.push.apple.com is only for production
  APNS.port = 2195
  APNS.pem  = '/home/touseef/Downloads/ChallanShor/APNS_Certificates_Dev.pem'
  APNS.pass = ''
else
  # APNS.host = 'gateway.sandbox.push.apple.com'
  APNS.host = 'gateway.push.apple.com'
  APNS.port = 2195
  # APNS.pem  = '/home/deploy/pem-files/APNS_Certificates_Dev.pem'
  APNS.pem  = '/home/deploy/pem-files/ChallanShor_Production.pem'
  APNS.pass = ''
end