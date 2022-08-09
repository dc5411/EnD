#!/usr/bin/ruby
#encoding: utf-8
#MauroEldritch & AdanzKx @ BCA - 2022.
require 'sinatra'
require 'thin'
require 'fileutils'
require 'zip'

#Main Configuration
set :root, Proc.new { File.join(Dir.pwd, "www") }
set :public_folder, Proc.new { File.join(root, "static") }
set :views, Proc.new { File.join(root, "templates") }

#Sinatra Configuration
set :environment, :production
enable :run
set :bind, "0.0.0.0"
set :port, 7891
set :show_exceptions, false
set :server_settings, :timeout => 5000
set :server, "thin"
$boss_catalog = []

#Functions
def get_catalog()
    $boss_catalog = []
    Dir["./bossdata/catalog/*.zip"].each { |x|
        $boss_catalog.push(x.split("/")[3])
    }
end

get ('/') {
    $ascii_files = []
    Dir["./bossdata/ascii/*.txt"].each { |x|
        $ascii_files.push(x.split("/")[3])
    }
    erb :index
}

get ('/catalog') {
    get_catalog()
    erb :catalog
}

post ('/download') {
    #Parameters
    boss_file = params['boss_sel']
    send_file "./bossdata/catalog/#{boss_file}", :filename => boss_file
}

post ('/spawn') {
    #Parameters
    $boss_name = params['boss_name'].gsub("'", "")
    $ascii_sel = params['ascii_sel']
    $intro_text = params['intro_text'].gsub("'", "")
    $taunt_text = params['taunt_text'].gsub("'", "")
    $channel = params['channel']
    $api_key = params['api_key']
    $presentation = params['presentation'].gsub("'", "")
    $death_message = params['death_message'].gsub("'", "")
    $unix_users = params['unix_users']
    $ssh_pass = params['ssh_pass']
    $flag_loc = params['flag_loc']
    $flag_con = params['flag_con'].gsub("'", "")
    $dmgcnd1_sel = params['dmgcnd1_sel']
    $dmgcnd2_sel = params['dmgcnd2_sel']
    $dmgcnd3_sel = params['dmgcnd3_sel']
    $argument_1 = params['argument_1']
    $argument_2 = params['argument_2']
    $argument_3 = params['argument_3']
    $sattack = params['sattack']
    $aattack = params['aattack']
    $clue = params['clue']
    $dialog_1 = params['dialog_1'].gsub("'", "")
    $dialog_2 = params['dialog_2'].gsub("'", "")
    $dialog_3 = params['dialog_3'].gsub("'", "")
    $wtime = params['wtime']
    $rtime = params['rtime']
    $sudo = params['sudo']
    $cmd = params['cmd']
    $files = params['files']
    $pkgs = params['pkgs']
    
    #Template: New Boss
    FileUtils.cp_r "./bossdata/template/.", "./bossdata/tmp"
    
    #index.html
    index = File.read("./bossdata/tmp/index.html")
    ascii = File.read("./bossdata/ascii/#{$ascii_sel}")
    new_index = index.gsub("__PLACEHOLDER_BOSS_TITLE__", "#{$boss_name}").gsub("__PLACEHOLDER_BOSS_WELCOME__", "#{$intro_text}").gsub("__PLACEHOLDER_BOSS_TAUNT__", "#{$taunt_text}").gsub("__PLACEHOLDER_ASCII_ART__", "#{ascii}")
    File.open("./bossdata/tmp/index.html", "w") {|file| file.puts new_index }
    
    #launcher.sh
    placeholder_users = ""
    $unix_users.gsub(" ","").split(",").each {|user|
        cmd_adduser = "adduser --disabled-password --gecos '' #{user}"
        cmd_password = "chpasswd <<<'#{user}:#{$ssh_pass}'"
        placeholder_users += cmd_adduser + "\n"
        placeholder_users += cmd_password + "\n"
    }
    placeholder_sudo = ""
    $sudo.gsub(" ","").split(",").each {|sudo|
        cmd_addsudo = "echo 'ALL ALL=NOPASSWD: #{sudo}' >> /etc/sudoers"
        placeholder_sudo += cmd_addsudo + "\n"
    }
    placeholder_commands = ""
    $cmd.split(",").each {|command|
        cmd_new = "#{command}"
        placeholder_commands += cmd_new + "\n"
    }
    launcher = File.read("./bossdata/tmp/launcher.sh")
    new_launcher = launcher.gsub("__PLACEHOLDER_UNIX_USERS__", "#{placeholder_users}").gsub("__PLACEHOLDER_SUDOERS__", "#{placeholder_sudo}").gsub("__PLACEHOLDER_EXTRA_CMD__", "#{placeholder_commands}")
    File.open("./bossdata/tmp/launcher.sh", "w") {|file| file.puts new_launcher }

    #Dockerfile
    placeholder_pkgs = ""
    $pkgs.gsub(" ","").split(",").each {|pkg|
        placeholder_pkgs += pkg + " "
    }
    placeholder_files = ""
    if $files.split(",").count > 0
        $files.split(",").each {|filep|
            placeholder_files += "COPY ./#{filep}\n"
        }
    end
    dockerfile = File.read("./bossdata/tmp/Dockerfile")
    new_dockerfile = dockerfile.gsub("__PLACEHOLDER_EXTRA_PKG__", "#{placeholder_pkgs}").gsub("__PLACEHOLDER_EXTRA_FILES__", "#{placeholder_files}")
    File.open("./bossdata/tmp/Dockerfile", "w") {|file| file.puts new_dockerfile }

    #boss.rb
    $dice_faces = ["1","2","3","4","5","6","7","8","9","10"].shuffle
    rest = 10 - ($sattack.to_i + $aattack.to_i + $clue.to_i)
    $sattack.to_i.times do |x|
        bossrb = File.read("./bossdata/tmp/boss.rb")
        dice_selected_face = $dice_faces[0]
        $dice_faces = $dice_faces.drop(1)
        new_bossrb = bossrb.gsub("__PLACEHOLDER_DICE_#{dice_selected_face}__", "main_attack()")
        File.open("./bossdata/tmp/boss.rb", "w") {|file| file.puts new_bossrb }
    end
    $aattack.to_i.times do |x|
        bossrb = File.read("./bossdata/tmp/boss.rb")
        dice_selected_face = $dice_faces[0]
        $dice_faces = $dice_faces.drop(1)
        new_bossrb = bossrb.gsub("__PLACEHOLDER_DICE_#{dice_selected_face}__", "area_attack()")
        File.open("./bossdata/tmp/boss.rb", "w") {|file| file.puts new_bossrb }
    end
    $clue.to_i.times do |x|
        bossrb = File.read("./bossdata/tmp/boss.rb")
        dice_selected_face = $dice_faces[0]
        $dice_faces = $dice_faces.drop(1)
        new_bossrb = bossrb.gsub("__PLACEHOLDER_DICE_#{dice_selected_face}__", "give_clue()")
        File.open("./bossdata/tmp/boss.rb", "w") {|file| file.puts new_bossrb }
    end
    rest.to_i.times do |x|
        bossrb = File.read("./bossdata/tmp/boss.rb")
        dice_selected_face = $dice_faces[0]
        $dice_faces = $dice_faces.drop(1)
        new_bossrb = bossrb.gsub("__PLACEHOLDER_DICE_#{dice_selected_face}__", "pass_turn()")
        File.open("./bossdata/tmp/boss.rb", "w") {|file| file.puts new_bossrb }
    end
    users_to_lock = ""
    conns_to_drop = ""
    svcs_to_stop = ""
    files_to_del = ""
    case $dmgcnd1_sel
    when "Interrupt a Connection"
        conns_to_drop += "'#{$argument_1}',"
    when "Stop a Service"
        svcs_to_stop += "'#{$argument_1}',"
    when "Delete a File"
        files_to_del += "'#{$argument_1}',"
    when "Lock User"
        users_to_lock += "'#{$argument_1}',"
    end
    case $dmgcnd2_sel
    when "Interrupt a Connection"
        conns_to_drop += "'#{$argument_2}',"
    when "Stop a Service"
        svcs_to_stop += "'#{$argument_2}',"
    when "Delete a File"
        files_to_del += "'#{$argument_2}',"
    when "Lock User"
        users_to_lock += "'#{$argument_2}',"
    end
    case $dmgcnd3_sel
    when "Interrupt a Connection"
        conns_to_drop += "'#{$argument_3}',"
    when "Stop a Service"
        svcs_to_stop += "'#{$argument_3}',"
    when "Delete a File"
        files_to_del += "'#{$argument_3}',"
    when "Lock User"
        users_to_lock += "'#{$argument_3}',"
    end
    clues_to_give = "'#{$dialog_1}','#{$dialog_2}','#{$dialog_3}'"
    bossrb = File.read("./bossdata/tmp/boss.rb")
    new_bossrb = bossrb.gsub("__PLACEHOLDER_API_KEY__", "#{$api_key}").gsub("__PLACEHOLDER_CHANNEL__", "#{$channel}").gsub("__PLACEHOLDER_BOSS_TITLE__", "#{$boss_name}").gsub("__PLACEHOLDER_DEATH_MESSAGE__", "#{$death_message}").gsub("__PLACEHOLDER_FLAG_LOC__", "#{$flag_loc}").gsub("__PLACEHOLDER_FLAG_CON__", "#{$flag_con}").gsub("__PLACEHOLDER_INTRO_MESSAGE__", "#{$presentation}").gsub("__PLACEHOLDER_WTIME__", "#{$wtime}").gsub("__PLACEHOLDER_RTIME__", "#{$rtime}").gsub("__PLACEHOLDER_USERS_LOCK__", "#{users_to_lock.chomp(",")}").gsub("__PLACEHOLDER_CONNS_DROP__", "#{conns_to_drop.chomp(",")}").gsub("__PLACEHOLDER_FILE_DEL__", "#{files_to_del.chomp(",")}").gsub("__PLACEHOLDER_SRV_STOP__", "#{svcs_to_stop.chomp(",")}").gsub("__PLACEHOLDER_CLUES__", "#{clues_to_give}")
    File.open("./bossdata/tmp/boss.rb", "w") {|file| file.puts new_bossrb }

    #ZIP
    folder = "./bossdata/tmp"
    input_filenames = ['Dockerfile', 'boss.rb', 'launcher.sh', 'index.html']
    zipfile_name = "./bossdata/catalog/#{$boss_name}.zip"
    Zip::File.open(zipfile_name, create: true) do |zipfile|
        input_filenames.each do |filename|
            zipfile.add(filename, File.join(folder, filename))
        end
    end

    #Delete old files
    input_filenames.each do |filename|
        File.delete("./bossdata/tmp/#{filename}") if File.exist?("./bossdata/tmp/#{filename}")
    end

    #Render
    redirect '/catalog'
}