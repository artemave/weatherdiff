# Learn more: http://github.com/javan/whenever

every :hour do
  runner 'Location.all.each {|l| begin; l.sample; rescue => e; Rails.logger.error e.backtrace.join("\n") end}'
end
