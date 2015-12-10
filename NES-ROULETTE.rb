require 'open3'
require_relative 'random_game_list.rb'

# Start by extracting the roms and emulator list from the config file
# Todo.

Shoes.app do

  # Init setup GUI
  @setup = stack :margin => 8 do
    flow do
      para 'Games to play: '
      @game_count_input = edit_line
    end
	
	# TODO Checkboxes to disable/enable certain platforms.
	#	flow do
	#		para 'Play published games only?'
	#		@play_published_input = check
	#	end

    button "Roulette!" do
    
 			#quit if number invalid
 			if @game_count_input.text.to_i.nil? && @game_count_input.text.to_i > 0
 				alert("Enter a valid number of games")
 				break
 			end

      launch
		end
	end

  def launch
    #Fetch game list.
  	@game_list = RandomGameList.new("roms/nes/",@game_count_input.text.to_i)			
		@game_started = false

    #main logic loop
 		every(2) do
      #attempt to launch a game if one is not started
 			if !@game_started
        @game_started = true
 				play
 			#otherwise monitor to see if the game is running. 
 			#If it's not increment the list and start the next game
 			elsif Open3.capture2e('tasklist /fi "imagename eq nestopia.exe')[0].include?("INFO")
 				@game_started = false
 				#increment game counter, close if nil
 				close if @game_list.next.nil?
 			end
 		end
    
	def play
    # Clear the setup pane. We are going to redraw anyway.
		@setup.clear
    # Clear the old game description unless it was already nil.
		@gamedesc.clear unless @gamedesc.nil?
		@gamedesc = stack do
			para "#{@game_list.current_number} of #{@game_list.total_number}: "+ @game_list.current_game
		end
		timer(1) do
			system 'Nestopia/nestopia.exe "roms/nes/' + @game_list.current_game + '"'
		end
	end
end