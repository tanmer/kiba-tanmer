# Kiba::Tanmer

This is a gem as extensions of Kiba for Tanmer Inc.

## Features

- Registry for making short-cuts of Class with Symbol.
- Checkpoint for storing current data to Hash store.
- Support passing block to source and destination.
- Add Job class.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kiba-tanmer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kiba-tanmer

## Usage

**Define job with block:**

```ruby
job = Kiba::Tanmer.parse do
  source { 1..5 }
  transform { |x| x * 2 }
  destination { |x| puts x }
end
job.run # => puts 2 4 5 8 10
```

**Define job with source code:**

```ruby
code = <<-CODE
source { 1..5 }
  transform { |x| x * 2 }
  destination { |x| puts x }
CODE
job = Kiba::Tanmer.parse(code)
job.run # => puts 2 4 5 8 10
```

**Define job in class:**

```ruby
class MyJob
  include Kiba::Tanmer::Job
  define_etl do
    source { 1..5 }
    transform { |x| x * 2 }
    destination { |x| puts x }
  end
end
MyJob.new.run # => puts 2 4 5 8 10

```

**Register mapping in class:**

```ruby
class RawSource
  def initialize(raw)
    @raw = raw
  end

  def each
    yield @raw
  end
end

class MultiplyTransform
  def initialize(x)
    @x = x
  end

  def process(row)
    yield @x * row
  end
end

class StdoutDestination
  def write(row)
    puts row
  end
end

class MyJob
  include Kiba::Tanmer::Job
  register_sources raw: RawSource
  register_transforms multiply: MultiplyTransform
  register_destinations stdout: StdoutDestination

  define_etl do
    source :raw, 10
    transform :multiply, 2
    destination :stdout
  end
end
MyJob.new.run # => puts 20

```

**Register mapping in instance:**

```ruby
class RawSource
  def initialize(raw)
    @raw = raw
  end

  def each
    yield @raw
  end
end

class MultiplyTransform
  def initialize(x)
    @x = x
  end

  def process(row)
    yield @x * row
  end
end

class StdoutDestination
  def write(row)
    puts row
  end
end

class MyJob
  include Kiba::Tanmer::Job

  define_etl do
    register_sources raw: RawSource
    register_transforms multiply: MultiplyTransform
    register_destinations stdout: StdoutDestination

    source :raw, 10
    transform :multiply, 2
    destination :stdout
  end
end
MyJob.new.run # => puts 20

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xiaohui-zhangxh/kiba-tanmer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
