require "development_mail_interceptor"

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "optlet.net",
  :user_name            => "brandt@optlet.net",
  :password             => "CrownRoyaln3wd4rk",
  :authentication       => "plain",
  :enable_starttls_auto => true
}


if Rails.env.development?
  ActionMailer::Base.default_url_options[:host] = "localhost:3000"
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor)
else
  ActionMailer::Base.default_url_options[:host] = "mobdex.heroku.com"
end