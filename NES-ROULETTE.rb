require 'open3'

Shoes.app do
	@all_game_names = Dir.entries("roms")

	#remove the ., .. produced by filenames
	@all_game_names.shift
	@all_game_names.shift

	@setup = stack :margin => 8 do

		flow do
			para 'Games to play: '
			@game_count = edit_line
		end

		flow do
			#does not work
			para 'Play published games only?'
			@play_published = check
		end

		flow do
			para '100% working ROMs only?'
			@working_roms = check
		end

		
 		button "Roulette!" do
			if @play_published.checked?
				games_skipped = @all_game_names.length
				@all_game_names.delete_if {|name| !name.include?('[!]')}
				games_skipped -= @all_game_names.length
				debug("Skipping #{games_skipped} unpublished games ")
			end
			
			if @working_roms.checked?
				games_skipped = @all_game_names.length
				@all_game_names.delete_if {|name| name.include?('[b')}
				games_skipped -= @all_game_names.length
				debug("Skipping #{games_skipped} broken games ")
			end
			
			
			debug("Total Games: #{@all_game_names.length}")
				
 			@games_in_roulette = @all_game_names.sample(@game_count.text.to_i)
 			@playing_game = 0
 			@game_started = false
 			@game_count_num = @game_count.text.to_i
 			every(2) do
 				if @game_started == false
 					@game_started = true
 					play(@playing_game) 
 				elsif Open3.capture2e('tasklist /fi "imagename eq nestopia.exe')[0].include?("INFO")
 					@game_started = false
 					@playing_game += 1
 					if(@playing_game == @game_count_num)
 						close()
 					end
 				end
 			end
		end
	end

	def play(number)
		count = number + 1
		@setup.clear
		@gamedesc.clear unless @gamedesc.nil?
		@gamedesc = stack :margin => 1 do
			para "#{count} of #{@game_count_num}: "+ @games_in_roulette[number]
		end
		timer(1) do
			system 'Nestopia/nestopia.exe "roms/' + @games_in_roulette[number] + '"'
		end
	end
end
