# -*- coding: utf-8 -*-
class PrettyDay

  InvalidTYDay = Class.new(StandardError)

  CN_WEEK_MAP = {
    'Mon' => '周一',
    'Tue' => '周二',
    'Wed' => '周三',
    'Thu' => '周四',
    'Fri' => '周五',
    'Sat' => '周六',
    'Sun' => '周日'
  }.freeze

  CN_TODAY = '今'.freeze
  CN_YTDAY = '昨'.freeze

  def initialize(day)
    @day = day.to_date
  end

  def cn_week
    @cn_week ||= CN_WEEK_MAP[@day.strftime('%a')]
  end

  def month_day
    @month_day ||= [@day.month, @day.day].join('/')
  end

  def is_today?
    @day == DateTime.now.to_date
  end

  def is_yesterday?
    @day == DateTime.now.yesterday.to_date
  end

  def is_t_y?
    is_today? || is_yesterday?
  end

  def cn_t_y
    if is_today?
      CN_TODAY
    elsif is_yesterday?
      CN_YTDAY
    else
      raise InvalidTYDay
    end
  end

end
