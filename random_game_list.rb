class RandomGameList

	def initialize(roms_dir,count)
		@game_count = count
		@all_game_names = Dir.entries(roms_dir)

		#remove the ., .. produced by entries
		@all_game_names.shift
		@all_game_names.shift
		@all_game_names.delete('alreadyplayed.txt')
    
    # remove the names of those games that have already been played.
    already_played_file = File.new("alreadyplayed.txt", "r")
    while (line = file.gets)
      all_game_names.remove(line)
    end
    already_played_file.close
        
 		@games_in_roulette = @all_game_names.sample(@game_count)
 		@game_ptr = 0
 	end

 	def next
 		@game_ptr += 1
 		current_game
 	end 

 	def current_number
 		@game_ptr + 1
 	end

 	def total_number
 		@game_count
 	end

 	def current_game
 		@games_in_roulette[@game_ptr]
 	end
  
   def add_game_to_already_played_file)
     File.write('alreadyplayed.txt', current_game)
   end
end