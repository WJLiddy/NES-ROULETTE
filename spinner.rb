#Given a list of games, returns one randomly
class Spinner

  # Takes 'count' games off the game list.
  def initialize(gamelist,count)
    @games = Array.new(count,nil)
    count.times do |i|
      @games[i] = gamelist.shift
    end
    @size = count
    @ptr = 0
    @consumable = false
  end

  def chosen_game
    @consumable = false
    @games[@ptr]
  end

  def replace(game)
    @games[@ptr] = game
  end

  def consumable
    @consumable
  end

  def spin(time)
    @spintime = time
  end

  def update
    if(@spintime > 0)
      old_spin_time = @spintime
      @spintime -= (0.04 + [(@spintime/50), 0.7].min)
      if(old_spin_time.floor != @spintime.floor)
        @ptr = ((@ptr+1) % @size)
      end
      if(@spintime <= 0)
        @consumable = true
      end
    end
  end

  def done_spinning
    @spintime <= 0
  end

  def text
    @games[@ptr].name
  end
end