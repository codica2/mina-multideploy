# Mina multideploy

Useful tool for parallel deploying on multiple servers with [mina](https://github.com/mina-deploy/mina).

## How it works
This gem will help you deploy the application on multiple servers in parallel. It takes original mina `deploy.rb` file, change `application_name`, `domain` and starts deploying process.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'mina-multideploy'
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
Start off by generating a configuration file:
```
bundle exec rails multideploy:init
```
this should give you a file in:
```
config/initializers/multideploy.rb
```
It should look something like this:
```ruby
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
```
config.servers = {
  '84.155.207.209' => %w[carghana caryange cartanzania]
  '105.87.69.69'   => %w[poster]
  '48.84.207.183'  => %w[codica timebot]
}
```
This means that your code will be deployed to 3 servers, and there can be several applications on one server.

*`original`* - path to the original mina `deploy.rb` file which will be taken as a basic.

*`w_dir`* - path to directory where temoporary files and logs will be created.

## Available features
After you have configured servers at `config/initializers/multideploy.rb` you can start deploying in two ways.

### Semi-automatic. (recomended for first deploy)
Run this command:
```ruby
bundle exec rails multideploy:prepare
```
You will get two files `multideploy` and `server_deploy.rb` at working directory (tmp/deploy by default). Check them and run `./tmp/deploy/multideploy`.

### Automatic
Run this command:
```ruby
bundle exec rails multideploy:start
```
This will make the same things like `multideploy:prepare`, but the deployment will start automatically.

## Additional information
* all scripts are updated before launch `multideploy:prepare` and `multideploy:start`
* add public SSH key, so you can login to server passwordles. Run `ssh-copy-id user@$host`

## License

Mina multideploy is released under the [MIT License](https://opensource.org/licenses/MIT)

## About Codica

[![Codica logo](https://www.codica.com/assets/images/logo/logo.svg)](https://www.codica.com)