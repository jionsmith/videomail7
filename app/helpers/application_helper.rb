module ApplicationHelper
  def video_status(video)
    status = if video.encoded
               "<p class= \"text-success\"><span title='Encoded!' class='glyphicon glyphicon-ok'></span></p>"
             else
               "<p class= \"text-warning\"><span title='Encoding..please wait..' class='glyphicon glyphicon-time'></span></p>"
             end
    status.html_safe
  end

  def filter_links_class(regexp, url = '')
    if regexp.match(request.url) || url.match(request.url)
      'active'
    else
      ''
    end
  end

  def money_with_cents_and_with_symbol(amount)
    humanized_money_with_symbol(amount, {no_cents: false, no_cents_if_whole: false})
  end

  def percentage_with_symbol(val)
    '%.1f%' % val
  end

  def plan_price_with_symbol(amount)
    html = humanized_money_with_symbol(Money.new(amount), {no_cents: false, no_cents_if_whole: false, decimal_mark: ',', symbol_position: :after, symbol_after_without_space: true})
    money = amount / 100.0
    if money.round == money
      html.sub!(/(.+)(,00)/, '\1,-')
    end

    html
  end

  def plan_duration_human(months)
    Plan::DURATION_NAME[months] || '-'
  end

  def video_duration_human(ms)
    unless ms.blank?
     return Time.at(ms/1000.0).utc.strftime("%H:%M:%S")
    else
      "00:00:00"
    end
  end

  def current_time_zone
    cookies["browser.timezone"]
  end
end
