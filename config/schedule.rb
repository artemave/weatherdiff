# Learn more: http://github.com/javan/whenever

every :hour do
  runner "Location.find(:all).each { |l| l.sample }; Rails.logger.flush"
end
