# ROM-ROULLETE.rb
# A Shoes app that gives you random roms to play.
# Documentation to come.

Shoes.app do
  # Init setup GUI
  @emulators = generate_emulator_list
  @emulators_skip = Array.new(@emulators.size)
  
  @setup = stack :margin => 8 do
    flow do
      para 'Games to play: '
      @game_count_input = edit_line
    end
    
    flow do
      para 'Exclude any systems?'
    end
    
    emulators.each_with_index do |e,i|
      flow do
        para e.system_name
        @emulators_skip[i] = check
      end
    end
  end
  
  def generate_emulator_list
    
end
	

