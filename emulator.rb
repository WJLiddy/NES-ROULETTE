class Emulator
  attr_reader :system_name,:exe,:roms_dir
  
  def initialize(entry)
    @system_name = entry.split[0]
    @emulator_exe = entry.split[1]
    @emulator_roms = entry.split[2]
  end
end
