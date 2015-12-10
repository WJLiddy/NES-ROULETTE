# Rom Roulette
# A Shoes app that gives you random roms to play.
# Documentation to come.
require_relative 'emulator'
require_relative 'gamelist'
Shoes.app do

  # Setup the emulator list.
  @emulators = []
  File.foreach('config.txt') {|l| @emulators << Emulator.new(l)}
  # Create the list of checkboxes to skip emulators.
  @emulators_skip = Array.new(@emulators.size)
  
  # Add setup boxes.
  @setup = stack :margin => 8 do
    flow do
      para 'Games to play: '
      @game_count = edit_line
    end
    flow do
      para 'Who is playing? Enter names seperated by commas.'
      @players = edit_line
    end
    flow do
      para 'Exclude any systems?'
    end
    @emulators.each_with_index do |e,i|
      flow do
        para e.system_name
        @emulators_skip[i] = check
      end
    end
    button "Roulette!" do
 			#quit if number of games to play is invalid
 			if @game_count.text.to_i.nil? && @game_count.text.to_i > 0
 				alert("Enter a valid number of games")
 				break
 			end
      play_roulette
		end
  end
  
   def play_roulette
    #First of all, do not play on systems that are not included.
    @emulators_skip.each_with_index{ |e,i| @emulators[i] = nil if e.checked? }
    @emulators.compact
  	@game_list = GameList.new(@emulators,@game_count_input.text.to_i)			
#		@game_started = false

    #main logic loop
# 		every(2) do
      #attempt to launch a game if one is not started
 #			if !@game_started
  #      @game_started = true
 		#		play
 			#otherwise monitor to see if the game is running. 
 			#If it's not increment the list and start the next game
 	#		elsif Open3.capture2e('tasklist /fi "imagename eq nestopia.exe')[0].include?("INFO")
 		#		@game_started = false
 				#increment game counter, close if nil
 			#	close if @game_list.next.nil?
 		#	end
 		#end
  end
end
	

