namespace :sample do
  desc "slack test"
  task :slack => :environment do
    Slack.chat_postMessage(text: 'test', username: 'kenta', channel: '#random')
  end
end
