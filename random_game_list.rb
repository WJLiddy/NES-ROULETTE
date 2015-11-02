
class RandomGameList

	def initialize(roms_dir,count,published_only,working_only)
		@game_count = count
		@all_game_names = Dir.entries(roms_dir)

		#remove the ., .. produced by entries
		@all_game_names.shift
		@all_game_names.shift

		if published_only
			games_skipped = @all_game_names.length
			@all_game_names.delete_if {|name| !name.include?('[!]')}
			games_skipped -= @all_game_names.length
			debug("Skipping #{games_skipped} unpublished games ")
		end
			
		if working_only
			games_skipped = @all_game_names.length
			@all_game_names.delete_if {|name| name.include?('[b')}
			games_skipped -= @all_game_names.length
			debug("Skipping #{games_skipped} broken games ")
		end
			
		debug("Total Games: #{@all_game_names.length}")
				
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
end