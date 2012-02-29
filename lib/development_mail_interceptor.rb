class DevelopmentMailInterceptor
  # this is only used for development don't need to send emails to people that don't want or need them.
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject} #{Rails.env}"
    message.to = "brandt.lareau@gmail.com"
  end
end