class BetaSignupEmails < ActionMailer::Base
  default :from => "brandt@optlet.net", :content_type => "text/html"
  
  def congratulate(beta_signup)
    @beta_signup = beta_signup
    mail(:to => beta_signup.email, :subject => "Pew2 Beta Signup")
  end
end