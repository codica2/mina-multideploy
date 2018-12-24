# Mina multideploy

A useful tool for parallel deployment on multiple servers with [mina](https://github.com/mina-deploy/mina).

## How it works
![How it works](https://raw.githubusercontent.com/codica2/mina-multideploy/master/docs/images/how-it-works.gif)

This gem will help you to deploy the application on multiple servers simultaneously. It takes original mina `deploy.rb` file, changes `application_name`, `domain` and starts the deployment process.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'mina-multideploy', '~> 1.1.0'
```

And then execute:
```
bundle install
```

Or install it yourself as:
```bash
gem install mina-multideploy
```

## Getting Started
Start by generating a configuration file:
```
bundle exec rails multideploy:init
```
It should give you a file in:
```
config/initializers/multideploy.rb
```
It should look something like this:
```ruby
return unless defined? Mina::Multideploy

Mina::Multideploy.configure do |config|
  config.servers = {}
  # Default velues
  # config.original = 'config/deploy.rb'
  # config.w_dir = 'tmp/deploy'
end
```

## Configuration

*`servers`* - hash at format `domain` => `array of application_name's`.

Example:
```ruby
config.servers = {
  '84.155.207.209' => %w[carghana caryange cartanzania]
  '105.87.69.69'   => %w[poster]
  '48.84.207.183'  => %w[codica timebot]
}
```
It means that your code will be deployed to 3 servers, and there can be several applications on one server.

*`original`* - path to the original mina `deploy.rb` file which will be taken as a basic.

*`w_dir`* - path to directory where temoporary files and logs will be created.

## Available features
After you have configured servers at `config/initializers/multideploy.rb` you can start deploying in two ways.

### Semi-automatic deploy (recommended for first deploy)
Run this command:
```ruby
bundle exec rails multideploy:prepare
```
You will get file `servers_deploy.rb` at working directory (tmp/deploy by default). Check it and run `ruby ./tmp/deploy/server_deploy.rb`.

### Automatic deploy
Run this command:
```ruby
bundle exec rails multideploy:start
```
It will make the same as `multideploy:prepare`, but the deployment will start automatically.

## Additional information
* all scripts are updated according config file before launch `multideploy:prepare` and `multideploy:start`
* add public SSH key, so you can login to server without password. Run `ssh-copy-id user@$host`

## License
mina-multideploy is Copyright © 2015-2018 Codica. It is released under the [MIT License](https://opensource.org/licenses/MIT).

## About Codica

[![Codica logo](https://www.codica.com/assets/images/logo/logo.svg)](https://www.codica.com)

mina-multideploy is maintained and funded by Codica. The names and logos for Codica are trademarks of Codica.

We love open source software! See [our other projects](https://github.com/codica2) or [hire us](https://www.codica.com/) to design, develop, and grow your product.
