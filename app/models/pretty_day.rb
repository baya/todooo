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

  CN_TMDAY = '明'.freeze
  CN_TODAY = '今'.freeze
  CN_YTDAY = '昨'.freeze

  def initialize(day)
    @day = day.to_date
    @dt  = DateTime.now
  end

  def cn_week
    @cn_week ||= CN_WEEK_MAP[@day.strftime('%a')]
  end

  def month_day
    @month_day ||= [@day.month, @day.day].join('/')
  end

  def is_today?
    @day == @dt.to_date
  end

  def is_yesterday?
    @day == @dt.yesterday.to_date
  end

  def is_tomorrow?
    @day == @dt.tomorrow.to_date
  end

  def is_tty?
    is_today? || is_tomorrow? || is_yesterday?
  end

  def cn_tty
    if is_today?
      CN_TODAY
    elsif is_yesterday?
      CN_YTDAY
    elsif is_tomorrow?
      CN_TMDAY
    else
      raise InvalidTYDay
    end
  end

  def cn_tty_long
    [cn_tty, '天'].join('')
  end

  def is_in_week?
    @day.strftime('%V') == @dt.strftime('%V')
  end

  def is_in_year?
    @day.strftime('%Y') == @dt.strftime('%Y')
  end

  def to_deadlines
    if is_tty?
      cn_tty_long
    elsif is_in_week?
      ['本', cn_week].join
    elsif is_in_year?
      @day.strftime('%-m月%-d日')
    else
      @day.strftime('%Y年%-m月%-d日')
    end
  end

end
