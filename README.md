# Baton

A process controller using Composite and Command pattern.

## Installation

Add this line to your application's Gemfile:

    gem 'baton'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install baton

## Usage


Assume the process structure is:

+ project1
  - stage1
        + task1
            - step1
            - step2
        + task2
            - step3
  - stage2
        + task3
            - step4
            - step5

Four predefined models:

+ `Baton::Project`
+ `Baton::Stage`
+ `Baton::Task`
+ `Baton::Step`

Build:

```ruby
step1 = Baton::Step.new('step1', '1st step')
step2 = Baton::Step.new('step2', '2nd step')
step3 = Baton::Step.new('step3', '3rd step')

task1 = Baton::Task.new('task1', '1st task')
task1.add_sub_command(step1)
task1.add_sub_command(step2)

task2 = Baton::Task.new('task2', '2nd task')
task2.add_sub_command(step3)

stage1 = Baton::Stage.new('stage1', '1st stage')
stage1.add_sub_command(task1)
stage1.add_sub_command(task2)

project1 = Baton::Project.new('project1', 'a demo project')
project1.add_sub_command(stage1)
```

Execute:

```ruby
project1.execute # => Make step1 done
project1.execute # => Make step2 done
project1.execute # => Make step3 done
```

Unexecute:

```ruby
project1.unexecute # => Undo step3
```

Predict:

```ruby
task1.done?   # => true
task2.done?   # => false
stage1.done?  # => false

project1.execute # => Make step3 done

task2.done?   # => true
stage1.done?  # => true
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/baton/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
