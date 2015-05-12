module Baton
  class BasicCommand
    attr_accessor :name, :description, :parent, :status

    def initialize(name, description)
      @name = name
      @description = description
    end

    def execute
    end

    def unexecute
    end

    def done!
      self.status = :done
      puts self
    end

    def undone!
      self.status = nil
      puts self
    end

    def done?
      self.status == :done
    end

    def undone?
      self.status != :done
    end


    private

      def to_s
        "#{name} -  #{description} (status: #{status || '-'})"
      end

  end
end
