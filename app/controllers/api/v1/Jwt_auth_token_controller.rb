class Api::V1::JwtAuthTokenController < ApplicationController

  skip_before_filter :verify_authenticity_token

  rescue_from JWT::ExpiredSignature, with: :jwt_expired_signature
  rescue_from JWT::DecodeError, with: :jwt_decode_error

  def jwt_expired_signature
    render json: {code: -1, message: 'token过期'}
  end

  def jwt_decode_error(exception)
    if exception.kind_of?(JWT::ExpiredSignature)
      render json: {code: -1, message: 'token过期'}
    else
      render json: {code: -1, message: 'token不合法'}
    end
  end

  # 创建登陆认证令牌
  def create
    @user = User.first
    payload = {id: @user.id, email: @user.email, "exp" => 1.seconds.from_now.to_i}
    @jwt = JWT.encode(payload, @user.password_salt)
    render json: {jwt: @jwt}
  end

  # 发送重置忘记密码邮件
  def send_reset_password_mail
    jid = UserWorker.perform_async({method: :reset_password, user_id: User.first.id})
    if jid
      render json: {code: 0}
    else
      render json: {code: -1, message: '发送重置密码失败'}
    end
  end

  # 更新密码
  def update_password
    # 获取重置密码中的用户信息，不验证令牌，此处不会抛出异常
    payload, header = JWT.decode(params[:reset_password_token], nil, false, verify_expiration: false)
    user = User.find_by_email(payload["email"])

    # 验证令牌，抛出异常如果验证失败
    JWT.decode(params[:reset_password_token], user.try(:password_salt))
    # 验证成功，重置密码
    if user.update(password: params[:new_password])
      # 返回成功信息
      render json: {code: 0}
    else
      render json: {code: -1, message: user.errors.full_messages.join(',')}
    end
  end

  # 验证认证令牌
  def validate_auth_token
    # 从请求头获取令牌
    auth_type, jwt = request.headers["HTTP_AUTHORIZATION"].try(:split, ' ')

    # 读取令牌携带用户信息，此处不作令牌的验证，不会抛出异常
    payload, header = JWT.decode(jwt, nil, false, verify_expiration: false)
    user = User.find_by_email(payload["email"])

    # 获取验证令牌的密钥
    secret = user ? user.try(:password_salt) : ""
    # 用秘钥验证令牌，会抛出 JWT::ExpiredSignature 或 JWT::DecodeError 异常
    payload, header = JWT.decode(jwt, secret)

    # 验证成功，设置当前用户
    render json: {current_user: user}
  end


end