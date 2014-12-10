[![Build
Status](https://travis-ci.org/andresbravog/params_for.svg)](https://travis-ci.org/andresbravog/params_for) [![Code Climate](https://codeclimate.com/github/andresbravog/params_for/badges/gpa.svg)](https://codeclimate.com/github/andresbravog/params_for) [![Test Coverage](https://codeclimate.com/github/andresbravog/params_for/badges/coverage.svg)](https://codeclimate.com/github/andresbravog/params_for) [![Inline docs](http://inch-ci.org/github/andresbravog/params_for.svg?branch=master)](http://inch-ci.org/github/andresbravog/params_for)

# ParamsFor

Use service objects and the power of `ActiveModel::Validations` to easy validate params in controller.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'params_for'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install params_for

## Usage

In your controller:


```Ruby
# app/controllers/fancy_controller.rb

class FancyController < ApplicationController
  include ParamsFor::Connectors::Glue

  params_for :fancy, only: [:create]

  # Creates a Fancy object by checking and validating params
  # before that
  #
  def create
    ...
    @fancy = Fancy.new(fancy_params)
    ...
  end
end
```

Or you can play with it yourself

```Ruby
# app/controllers/fancy_controller.rb

class FancyController < ApplicationController
  include ParamsFor::Connectors::Glue

  # Creates a Fancy object by checking and validating params
  # before that
  #
  def create
    ...
    @fancy = Fancy.new(fancy_params)
    ...
  end

  protected

  # Strong params delegated to ParamValidator::Fancy
  # and memoized in @fancy_params var returned by this method
  #
  # @return [HashwithIndifferentAccess]
  def fancy_params
    params_for :fancy
  end
end
```

Some place in your application ( suggested `app/validators/params_for/` )

```Ruby
  # app/validators/params_for/fancy.rb

  class ParamValidator::Fancy < ParamValidator::Base
    attr_accessor :user_id, :fancy_name, :fancy_description

    validates :user_id, :fancy_name, presence: true
    validates :user_id, integer: true
  end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/params_for/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
