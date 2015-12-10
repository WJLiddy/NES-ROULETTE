# Rom Roulette
# A Shoes app that gives you random roms to play.
# Documentation to come.
require_relative 'emulator'
require_relative 'game'
require 'open3'
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
 			if @game_count.text.to_i.nil? || @game_count.text.to_i <= 0
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
    
  	@game_list = Game.random_list(@emulators,@game_count.text.to_i)			 
		@state = :game_closed

    # main logic loop
  	every(3) do

      if @state == :game_running
        @state = :game_closed if !game_is_running
      end

      # attempt to launch a game if one is not started
  		if @state == :game_closed
 				launch_game
        @state = :launching
      end
    end
  end

  def game_is_running
    command = 'tasklist /fi "imagename eq' + @current_game.emulator.exe_name
    Open3.capture2e(command)[0].include?("INFO")
  end

  def launch_game
    close() if @game_list.empty?
  
    @current_game = @game_list.shift

    # Clear the setup pane. We are going to redraw anyway.
    @setup.clear
    # Clear the old game description unless it was already nil.
    @gamedesc.clear unless @gamedesc.nil?
    @gamedesc = stack do
      para "#{@game_list.size + 1} game(s) left."
      para "Now playing"
      para "#{@current_game.emulator.system_name}: #{@current_game.name}"
    end
    timer(5) do
      command = @current_game.emulator.exe_path + ' "' + @current_game.emulator.roms_dir + @current_game.name + '"' 
      debug(command)
      system command
      @state = :game_running
    end
  end
end
