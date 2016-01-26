class UserWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'user', retry: true, backtrace: true

  def perform(options = {})
    options = HashWithIndifferentAccess.new(options)
    return if options.blank?
    return if options[:user_id].blank? && options[:method]

    @user = User.find_by_id(options[:user_id])
    return unless @user

    send(options[:method])
  end

  def reset_password
    payload = {email: @user.email, "exp" => 2.days.from_now.to_i}
    token = JWT.encode(payload, @user.password_salt)
    # 发送重置密码邮件，里面会携带参有合法重置密码令牌的连接
    UserMailer.reset_password(@user, token).deliver
  end

end