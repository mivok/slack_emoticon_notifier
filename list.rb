#!/usr/bin/env ruby
require 'slack'
require 'redis'
require 'json'

redis = Redis.new(:url => ENV['REDIS_URL'])

Slack.configure do |config|
  config.token = ENV['SLACK_TOKEN']
  raise "Ensure ENV['SLACK_TOKEN'] is set" unless config.token
end

slack_room = ENV['SLACK_ROOM'] || '#general'

old_emoticons = JSON.load(redis.get('emoticon_list'))

res = Slack.emoji_list
current_emoticons = res['emoji'].keys.sort
redis.set('emoticon_list', JSON.dump(current_emoticons))

if old_emoticons.nil?
  puts "First run, nothing to report."
else
  new_emoticons = (current_emoticons.to_set - old_emoticons.to_set).to_a.sort
  removed_emoticons = (old_emoticons.to_set - current_emoticons.to_set).to_a.sort
  message = []
  unless new_emoticons.empty?
    message << "New emoticons: #{new_emoticons.map {|i| ":#{i}: - #{i}"}.join(", ")}"
  end
  unless removed_emoticons.empty?
    message << "Removed emoticons: #{removed_emoticons.join(", ")}"
  end

  unless message.empty?
    Slack.chat_postMessage(
      channel: slack_room,
      text: message.join(". "),
      username: ENV['BOT_NAME'] || 'Emoticon bot'
    )
  end
end
