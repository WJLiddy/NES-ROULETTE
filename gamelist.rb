class Game
  
  def initialize(name,emulator)
    @name = name
    @emulator = emulator
  end
  
 
  def Game.random_list(emulators,count)
    eligible_games = []
    #Make a big list of all eligible games.
    emulators.each |emulator| do
      e.all_games |gamename| do
        eligible_games << Game.new(gamename,emulator)
      end
    end
    eligible_games.sample(game_count)
  end
 
end