[![wercker
status](https://app.wercker.com/status/2a15e93654b2ff7d6ee34782791addeb/m/master
"wercker
status")](https://app.wercker.com/project/bykey/2a15e93654b2ff7d6ee34782791addeb)

# Ohm::Pop

A pop implementation for Ohm

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ohm-pop'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ohm-pop

## Usage

```ruby
require 'ohm'
require 'ohm/pop'

class Item < Ohm::Model
  attribute :name
  attribute :priority

  index :name
  index :priority
end

Item.create(name: 'item1', priority: 1)
Item.create(name: 'item2', priority: 2)
Item.create(name: 'item3', priority: 3)

Item.all.size
# => 3

Item.all.pop(by: :priority)
# => #<Item:xxxx @attributes={:name=>"item1", :priority=>"1"}, @_memo={}, @id="1">

Item.all.size
# => 2
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ohm-pop/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
