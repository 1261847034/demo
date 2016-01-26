class UserMailer < ActionMailer::Base

  def reset_password(user, token)
    @user = user
    @token = token
    mail :to => user.email, :subject => "密码找回测试"
  end

end