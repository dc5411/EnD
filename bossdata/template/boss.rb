#!/usr/bin/ruby
require 'net/http'
require 'uri'
require 'json'

#Discord Webhook
$api_key = "__PLACEHOLDER_API_KEY__"
$channel = "__PLACEHOLDER_CHANNEL__"

#Item Conditions
$users_to_lock = [__PLACEHOLDER_USERS_LOCK__]
$connections_to_drop = [__PLACEHOLDER_CONNS_DROP__]
$files_to_delete = [__PLACEHOLDER_FILE_DEL__]
$services_to_stop = [__PLACEHOLDER_SRV_STOP__]
$clues_to_give = [__PLACEHOLDER_CLUES__]

#Health
$health = 3
$death_confirmed = 0

#Send Message
def send_message(message)
	if $channel == "discord"
		uri = URI.parse("https://discord.com/api/webhooks/#{$api_key}")
		request = Net::HTTP::Post.new(uri)
		request.content_type = "application/json"
		request["Accept"] = "application/json"
		request.body = JSON.dump({"content" => "#{message}"})
		req_options = {use_ssl: uri.scheme == "https"}
		response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
			http.request(request)
		end
	elsif $channel == "telegram"
		#Not implemented
	elsif $channel == "slack"
		#Not implemented
	end
end

#Check File
def check_file(file_to_check)
	if !File.file?(file_to_check)
		$files_to_delete = $files_to_delete - ["#{file_to_check}"]
		$health -= 1
		send_message("[🩸] __PLACEHOLDER_BOSS_TITLE__ received a successful hit.")
	end
end

#Check Connections
def check_conn(conn_to_check)
	check_conn_cmd = `ping #{conn_to_check} -c3 | grep loss | awk '{print $4}'`.chomp
	if check_conn_cmd != "3"
		$connections_to_drop = $connections_to_drop - ["#{conn_to_check}"]
		$health -= 1
		send_message("[🩸] __PLACEHOLDER_BOSS_TITLE__ received a successful hit.")
	end
end

#Check Users
def check_user(user_to_check)
	check_user_cmd = `passwd -S #{user_to_check} | awk '{print $2}'`.chomp
	if check_user_cmd != "P"
		$users_to_lock = $users_to_lock - ["#{user_to_check}"]
		$health -= 1
		send_message("[🩸] __PLACEHOLDER_BOSS_TITLE__ received a successful hit.")
	end
end

#Check Service
def check_srvc(srvc_to_check)
	check_srvc_cmd = `/etc/init.d/#{srvc_to_check} status | grep "is running" | wc -l`.chomp
	if check_srvc_cmd != "1"
		$services_to_stop = $services_to_stop - ["#{srvc_to_check}"]
		$health -= 1
		send_message("[🩸] __PLACEHOLDER_BOSS_TITLE__ received a successful hit.")
	end
end

#Check Health
def check_health()
	if $users_to_lock.count > 0
		$users_to_lock.each do |user|
			check_user(user)
		end
	end
	if $connections_to_drop.count > 0
		$connections_to_drop.each do |conn|
			check_conn(conn)
		end
	end
	if $files_to_delete.count > 0
		$files_to_delete.each do |filep|
			check_file(filep)
		end
	end
	if $services_to_stop.count > 0
		$services_to_stop.each do |srvc|
			check_srvc(srvc)
		end
	end
end

#Hint / Clue
def give_clue()
	send_message("[💬] __PLACEHOLDER_BOSS_TITLE__: #{$clues_to_give.sample}.")
end

#Pass
def pass_turn()
	send_message("[🍀] __PLACEHOLDER_BOSS_TITLE__ passes this turn.")
end

#Main Attack (Single)
def main_attack()
	begin
		target = `who | grep -v root | awk '{print $2}'`.split("\n").sample
		`pkill -9 -t #{target}`
		send_message("[🗡️] __PLACEHOLDER_BOSS_TITLE__ attacks.")
	rescue => e
		puts e.to_s
	end
end

#Area Attack (Group)
def area_attack()
	begin
		targets = `who | grep -v root | awk '{print $2}'`.split("\n")
		targets.each do |x|
			`pkill -9 -t #{x}`
		end
		send_message("[💥] __PLACEHOLDER_BOSS_TITLE__ launched an area attack.")
	rescue => e
		puts e.to_s
	end
end

#Death
def death()
	send_message("[💀] __PLACEHOLDER_BOSS_TITLE__: __PLACEHOLDER_DEATH_MESSAGE__")
	File.write('__PLACEHOLDER_FLAG_LOC__', '__PLACEHOLDER_FLAG_CON__', mode: 'w')
	`chmod 777 __PLACEHOLDER_FLAG_LOC__`
	$death_confirmed = 1
end

#Throw Dice
def throw_dice()
	dice = rand(1...10)
	return dice
end

#Map dice to technique
def coordinate()
	#Check items and health
	check_health()
	if $health > 0
		#Throw a dice
		dice = throw_dice()
		puts "[Debug] Throw: #{dice}."
		case dice
		when 1
			__PLACEHOLDER_DICE_1__
		when 2
			__PLACEHOLDER_DICE_2__
		when 3
			__PLACEHOLDER_DICE_3__
		when 4
			__PLACEHOLDER_DICE_4__
		when 5
			__PLACEHOLDER_DICE_5__
		when 6
			__PLACEHOLDER_DICE_6__
		when 7
			__PLACEHOLDER_DICE_7__
		when 8
			__PLACEHOLDER_DICE_8__
		when 9
			__PLACEHOLDER_DICE_9__
		when 10
			__PLACEHOLDER_DICE_10__
		end
	else
		death()
	end
end

def main()
	$files_to_delete.each do |filep|
		File.write("#{filep}", "DELETE_ME", mode: 'w')
		`chmod 777 #{filep}`
	end
	send_message("[🤺] __PLACEHOLDER_BOSS_TITLE__: __PLACEHOLDER_INTRO_MESSAGE__")
	sleep __PLACEHOLDER_WTIME__
	t = Thread.new do
		while $death_confirmed == 0 do
			coordinate()
			sleep __PLACEHOLDER_RTIME__
		end
	end
	t.join
end

main()