# CommitGuard

Prevent unwanted code from being committed (sleep, debugger, binding.pry).
Commit Guard allows the user to define custom rules at both the global and project level}

## Installation

Add this line to your application's Gemfile:

    gem 'commit_guard'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install commit_guard

## Usage
Generate the default Guards by running:

    $ commit_guard generate

Add additional guards by running

    $ commit_guard new

Run commit_guard on a directory by running:

    $ commit_guard

Or

    $ commit_guard run

Commit Guard uses the current directory or takes an optional path

    $ commit_guard run ~/some_project

Commit Guard looks for a .commit_guard.yml file in the HOME dir as well
as the project's dir.

Any project specific guards should be added to the project dir's
.commit_guard.yml

Add commit guard to your project's pre-commit hook to guard
automatically.
 
    $ vi .git/hooks/pre-commit

Add the following:

    $ #!/bin/sh
    $ commit_guard . -s

Then run:

    $ chmod +x .git/hooks/pre-commit

## Custom guards
If your project requires a custom validation, CommitGuard can still
help.

First add the following to your .commit_guard.yml file:
(builder support coing soon)

    $ requires:
    $ - 'lib/awesome_guard.rb'

Custom guards must:
* Inherit from CommitGuard::Guards::Base
* Have a call method
* #call must return self
* Have a result method

Here is an example custom guard:
```ruby
class Awesomeguard < CommitGuard::Guards::Base
  def call
    # some thing that needs to happen
    self
  end

  def result
    'the result of calling #call'
  end
end
```

Now you can add your custom guard to your configuration by running

    $ commit_guard new

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
