module WheneverHelper
  def update_schedule 
    schedule_path = File.join(Rails.root, 'config/schedule.rb')

    File.open(schedule_path, 'w') do |f| 
      f.flock File::LOCK_EX
      header = "set :output, 'log/output.log'\n"
      header << "set :environment, :development\n"
      f.write(header)
    end

    animes = Anime.all
    animes.each do |anime|
      content = <<-FILE
# minute, hour, day_of_month, month, day_of_week
every '#{crontime(anime)}' do
    runner "Slack.chat_postMessage(text: '#{anime.title} が あと一時間で始まるよ!!', username: 'kenta', channel: '#random')"
end

      FILE
      File.open(schedule_path, 'a') do |f|
        f.flock File::LOCK_EX
        f.write(content)
      end
    end
    system("bundle exec whenever --update-crontab")

  end 

  private
  def crontime anime
     if anime.start_time.to_s.match(/\s(\d{2}):(\d{2}):/)
       hour = "%01d" % $1
       hour = hour.to_i
       minute = "%01d" % $2
     end

     wday = week_list[anime.days_of_the_week]

     if hour == 0
       hour = 23
       if wday == 0
         wday = 6
       else
         wday = wday - 1
       end
     else
       hour = hour - 1
     end

    "%s %s * * %s" % [minute, hour, wday]
  end

  def week_list
    {'Sun' => 0, 'Mon' => 1, 'Tue' => 2, 'Wen' => 3, 'Thr' => 4, 'Fri' => 5, 'Sat' => 6}
  end

end
