# -*- coding: utf-8 -*-
require 'rails_helper'

RSpec.describe PrettyDay, :type => :model do
  
  it '如果日期是今天，显示今天' do
    day = DateTime.now.strftime('%Y-%m-%d')
    pday = PrettyDay.new(day)

    assert_equal pday.cn_tty_long, '今天'
    assert_equal pday.cn_tty, '今'
  end

  it '如果日期是昨天，显示昨天' do
    day = (DateTime.now - 1.day).strftime('%Y-%m-%d')
    pday = PrettyDay.new(day)

    assert_equal pday.cn_tty_long, '昨天'
    assert_equal pday.cn_tty, '昨'
  end

  it '如果日期是明天, 显示明天' do
    day = (DateTime.now + 1.day).strftime('%Y-%m-%d')
    pday = PrettyDay.new(day)

    assert_equal pday.cn_tty_long, '明天'
  end

  it 'cn_week 显示星期' do
    # 周一
    spec_cn_week('2016-01-04', '周一')
    
    # 周二
    spec_cn_week('2016-01-05', '周二')

    # 周三
    spec_cn_week('2016-01-06', '周三')

    # 周四
    spec_cn_week('2016-01-07', '周四')

    # 周五
    spec_cn_week('2016-01-08', '周五')

    # 周六
    spec_cn_week('2016-01-09', '周六')

    # 周日
    spec_cn_week('2016-01-10', '周日')
  end

  it 'month_day 显示为月/日' do
    day = '2016-01-13'
    pday = PrettyDay.new(day)

    assert_equal pday.month_day, '1/13'
  end

  it 'to_deadlines 显示合适的截止日期' do
    # 今天
    day = DateTime.now.strftime('%Y-%m-%d')
    pday = PrettyDay.new(day)
    assert_equal pday.to_deadlines, '今天'

    # 明天
    day = (DateTime.now + 1.day).strftime('%Y-%m-%d')
    pday = PrettyDay.new(day)
    assert_equal pday.to_deadlines, '明天'

    # 一周内
    day = (DateTime.now + 2.day).strftime('%Y-%m-%d')
    pday = PrettyDay.new(day)
    assert pday.to_deadlines.include?('本周')
    

    # 一年内
    tday = DateTime.now
    day = (tday + 10.day).strftime('%Y-%m-%d')
    pday = PrettyDay.new(day)
    assert_equal pday.to_deadlines, (tday + 10.day).strftime('%-m月%-d日')

    # 一年外
    day = '2015-09-07'
    pday = PrettyDay.new(day)
    assert_equal pday.to_deadlines, '2015年9月7日'

  end

  def spec_cn_week(day, cn_week)
    pday = PrettyDay.new(day)
    assert_equal pday.cn_week, cn_week
  end
  
end
