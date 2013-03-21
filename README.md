# CommitGuard

TODO: Write a gem description

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

Add custom guards by running

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
