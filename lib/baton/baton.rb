require_relative 'basic_command'
require_relative 'composite_command'

module Baton
  class Step < BasicCommand
    def execute
      puts "Make #{name} done"
      done!
      self
    end

    def unexecute
      puts "Undo #{name}"
      undone!
    end
  end

  class Task < CompositeCommand
  end

  class Stage < CompositeCommand
  end

  class Project < CompositeCommand
  end

end
