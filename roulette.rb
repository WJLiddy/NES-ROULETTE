# Rom Roulette
# A Shoes app that gives you random roms to play.
# Documentation to come.
require_relative 'emulator'
require_relative 'game'
require_relative 'spinner'
require 'open3'

SPINNER_SIZE = 20

Shoes.app(title: "Roulette",
   width: 700, height: 700, resizable: false) do
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
    #Make player list.
    @players_list = @players.text.split(',')
    @players_ptr = 0

    #Do not play on systems that are not included.
    @emulators_skip.each_with_index{ |e,i| @emulators[i] = nil if e.checked? }
    @emulators.compact!
    
  	@game_list = Game.random_list(@emulators,SPINNER_SIZE + (@game_count.text.to_i))			 
		@state = :game_closed
    @games_left = (@game_count.text.to_i)
    draw_game_desc
    # main logic loop
  	every(3) do

      if @state == :game_running
       if !game_is_running
          @state = :game_closed
          @games_left -= 1
        end
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
    # Finish if there are no games left.
    close() if @games_left == 0
    # Remove the current game.
    @current_game = nil
    @spinner.replace(@game_list.shift) unless @spinner.nil?
    @players_ptr = ((@players_ptr + 1) % @players_list.size) unless @spinner.nil?
    update_game_desc
    # Instaniate the spinner, spin it.
    if @spinner.nil?
      @spinner = Spinner.new(@game_list,SPINNER_SIZE)
      @spinner.spin(20 + rand(20))
      animate(20) do |frame|
        @spinner.update
        @spinner_text.replace @spinner.text
        if(@spinner.done_spinning && @spinner.consumable)
          @current_game = @spinner.chosen_game
          update_game_desc
          timer(3) do
            command = @current_game.emulator.exe_path + ' "' + @current_game.emulator.roms_dir + @current_game.name + '"' 
            debug(command)
            system command
            @state = :game_running
          end
        end
      end
    end
    @spinner.spin(20 + rand(20))


  end

  def draw_game_desc
      # Clear the setup pane. We are going to redraw anyway.
    @setup.clear
    # Clear the old game description unless it was already nil.
    stack do
      @games_left_text = subtitle " "
      @player_turn = subtitle " "
      @spinner_text = subtitle " "
    end
    update_game_desc
  end

  def update_game_desc
     @games_left_text.replace "#{@games_left} game(s) left."
     @player_turn.replace @players_list[@players_ptr] + " is going to play..."
  end
end
