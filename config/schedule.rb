# Learn more: http://github.com/javan/whenever

env :GEM_HOME, ENV['GEM_HOME'] || "GEM_HOME=#{ENV['HOME']}/.gems/"

every :hour do
  runner 'Location.all.each {|l| begin; l.sample; rescue => e; Rails.logger.error e.backtrace.join("\n") end}'
end
