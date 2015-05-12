require 'test_helper'
require 'yaml'

module Baton
  class BatonTest < Minitest::Test
    def setup
      resource = YAML.load File.read('test/fixtures/resource.yml')
      resource.each do |project, h1|
        @project = Project.new h1['name'], h1['description']
        h1['commands'].each do |stage, h2|
          stage = Stage.new h2['name'], h2['description']
          h2['commands'].each do |task, h3|
            task = Task.new h3['name'], h3['description']
            h3['commands'].each do |step, h4|
              step = Step.new h4['name'], h4['description']
              task.add_sub_command(step)
            end
            stage.add_sub_command(task)
          end
          @project.add_sub_command(stage)
        end
      end

      @task = @project.pending.first.pending.first
    end

    def test_execute_in_one_task
      assert_equal 2, @project.pending.count
      assert_equal 3, @task.pending.count

      @project.execute

      assert_equal 2, @project.pending.count
      assert_equal 1, @project.completed.count
      assert_equal 2, @task.pending.count
      assert_equal 1, @task.completed.count

      2.times{ @project.execute }

      assert_equal ['Step1', 'Step2', 'Step3'],  @project.completed.map(&:name)
    end

    def test_execute_over_one_task
      4.times{ @project.execute }

      assert_equal ['Step1', 'Step2', 'Step3', 'Step4'],  @project.completed.map(&:name)
    end

    def test_unexecute_in_one_task
      assert_equal 2, @project.pending.count
      assert_equal 3, @task.pending.count

      @project.execute

      assert_equal 2, @project.pending.count
      assert_equal 1, @project.completed.count
      assert_equal 2, @task.pending.count
      assert_equal 1, @task.completed.count

      @project.unexecute

      assert_equal 2, @project.pending.count
      assert_equal 3, @task.pending.count
    end

    def test_unexecute_over_one_task
      4.times{ @project.execute }
      1.times{ @project.unexecute }

      assert_equal ['Step1', 'Step2', 'Step3'],  @project.completed.map(&:name)
    end

  end
end
