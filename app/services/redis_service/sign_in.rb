module RedisService
  class SignIn

    # 生成签到日期的键，例如 2013-4-13::signed
    def sign_key(date)
      "#{date}::signed"
    end

    # 生成用户签到计数器的键，例如 tom::sign_count
    def sign_count_key(user_id)
      "#{user_id}::sign_count"
    end

    # 用户在指定日期签到
    # 注意，为了保持示例实现的简单性
    # 目前的这个实现不能防止一个用户在同一天多次签到
    # 解决这个问题需要使用事务或者 Lua 脚本
    def sign(user_id, date)
      return if signed(user_id, date)
      $redis.incr(sign_count_key(user_id))
      $redis.sadd(sign_key(date), user_id)
    end

    # 用户在指定日期已经签到了吗？
    def signed(user_id, date)
      $redis.sismember(sign_key(date), user_id)
    end

    # 返回给定用户的签到次数
    def sign_count_of(user_id)
      $redis.get(sign_count_key(user_id)).to_i
    end

    # 将给定日期内的签到排名保存到 top_sign_name 键中，
    # 并从高到低返回排名结果。
    def top_sign(top_sign_name, *dates)
      date_keys = dates.map{|date| sign_key(date)}
      $redis.zunionstore(top_sign_name, date_keys)
      $redis.zrevrange(top_sign_name, 0, -1, withscores: true)
    end

    # 将给定日期内的全勤记录保存到 full_sign_name 键中，
    # 并返回全勤记录。
    def full_sign(full_sign_name, *dates)
      date_keys = dates.map{|date| sign_key(date)}
      $redis.sinterstore(full_sign_name, date_keys)
      $redis.smembers(full_sign_name)
    end

  end
end