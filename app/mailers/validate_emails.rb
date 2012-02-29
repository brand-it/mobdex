class ValidateEmails < ActionMailer::Base
  # This is a big note but if you are using images in emails you should put the in email_images the reason for this because there is no documentation or information on how to put a image in email. See this doc http://guides.rubyonrails.org/action_mailer_basics.html
  
  default :from => "brandt@optlet.net", :content_type => "text/html"
  
  def send_validation(user)
    @user = user
    # attachments.inline['optlet_header_email.png'] = File.read("#{Rails.root}/public/email_images/optlet_header_email.png")
    mail(:to => @user.email, :subject => "Mobdex Email Validation")
  end
  
  # Documentation Don't use this code but for referance it is good to read
  # def new_message(contact)
  #   @contact = contact
  #   mail(:to => "brandt.lareau@gmail.com", :subject => "#{contact.full_name} Contacted You")
  # end
  # 
  # def new_user_notice(user)
  #   @user = user
  #   mail(:to => "brandt.lareau@gmail.com", :subject => "#{user.full_name} New User Created")
  # end
  # 
  # def new_comment(comment)
  #   @comment = comment
  #   if !comment.user.nil?
  #     subject = "#{comment.user.full_name.titlecase} Has Left Message"
  #   else
  #     subject = "Un-know user Has Left A Message"
  #   end
  #   mail(:to => "brandt.lareau@gmail.com", :subject => subject)
  # end
end