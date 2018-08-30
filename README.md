# Slack emoticon notifier

This is a slack bot that will notify on any new or deleted emoticons in your
slack team.

## Installation

First, create a new bot integration in slack. Go to
https://my.slack.com/services/new/bot, choose a username for it (e.g.
emoticon-bot) and Add the bot integration.

Next, edit list.rb and change the token to the token slack gave you when you
created the bot. You'll also want to change the channel to the channel you
want to post emoticon updates to.

Next, you'll want to deploy the bot on heroku:

    heroku create my_emoticon_bot
    heroku addons:create heroku-redis:hobby-dev
    heroku config:set SLACK_TOKEN=token_from_slack
    heroku config:set SLACK_ROOM=#room_to_post_to
    git push heroku master
    heroku addons:create scheduler:standard
    heroku addons:open scheduler
    # Add a new job daily to run 'worker' task or 'ruby list.rb'
