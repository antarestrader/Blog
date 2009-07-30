Given(/^time is frozen(?: at "(.*)")?$/) do |time|
  time = time.nil? ? Time.now : Chronic.parse(time)
  Timecop.freeze(time)
  puts "It is now #{Time.now}:"
end

Given(/^the time is now after (.*)$/) do |time|
  Timecop.freeze(Chronic.parse(time)+1.second)
  puts "It is now #{Time.now}:"
end

