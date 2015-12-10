require 'fileutils'

class Emulator
  attr_reader :system_name,:exe_path,:roms_dir
  
  def initialize(entry)
    @system_name = entry.split[0]
    @exe_path = entry.split[1]
    @roms_dir = entry.split[2]
  end

  def exe_name
    File.basename(@roms_dir)
  end
  
  def all_games
    all_game_names = Dir.entries(@roms_dir)

		#remove the ., .. produced by entries
		all_game_names.shift
    all_game_names.shift
		all_game_names.delete('alreadyplayed.txt')
    
    # remove the names of those games that have already been played.
    File.new(@roms_dir + 'alreadyplayed.txt',"w") unless File.exist?(@roms_dir + '/alreadyplayed.txt')
    already_played_file = File.new(@roms_dir + 'alreadyplayed.txt', "r")
    while (line = already_played_file.gets)
      all_game_names.remove(line)
    end
    already_played_file.close
    
    all_games = []
    all_game_names.each do |gamename|
      all_games << Game.new(gamename,self)
    end
    all_games
  end
  

end
