class Game

  attr_reader :name,:emulator
  
  def initialize(name,emulator)
    @name = name
    @emulator = emulator
  end
  
 
  def Game.random_list(emulators,count)
    eligible_games = []
    #Make a big list of all eligible games.
    emulators.each do |emulator|
        eligible_games << emulator.all_games
    end
    
    debug('Total Games:')
    eligible_games.flatten.sample(count)
  end
 
end