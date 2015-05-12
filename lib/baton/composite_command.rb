require_relative 'basic_command'

module Baton
  class CompositeCommand < BasicCommand
    # :pending is a queue, while :completed is a stack
    attr_accessor :pending, :completed

    def initialize(name, description)
      super(name, description)
      @pending = []
      @completed = []
    end

    def add_sub_command(cmd)
      pending.push cmd
      cmd.parent = self
    end

    def execute
      if pending.empty?
        done!
      else
        cmd = pending.first
        base_cmd = cmd.execute

        completed << base_cmd unless base_cmd.nil? # Only append BasicCommand
        pending.shift if cmd.done?

        return base_cmd
      end
    end

    def unexecute
      if completed.empty?
        raise 'No completed command available'
      else
        ret_cmd = cmd = completed.pop
        cmd.unexecute

        while cmd != self
          parent = cmd.parent
          parent.pending.unshift cmd unless parent.pending.include? cmd
          parent.completed.delete cmd

          cmd = parent
        end

        ret_cmd
      end
    end

    def done?
      pending.all?(&:done?)
    end

    def undone?
      pending.any?(&:undone?)
    end

    private

      def to_s
        ( [super] + pending.flat_map{|cmd| cmd.send(:to_s) } ).join("\n")
      end
  end
end
