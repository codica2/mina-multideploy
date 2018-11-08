module Multideploy
  class Init < BaseService
    def call
      create
    end

    private

    def path
      'config/initializers/multideploy.rb'
    end

    def content
      <<-EOS
Mina::Multideploy.configure do |config|
  config.servers = {}
  # Default velues
  # config.original = 'config/deploy.rb'
  # config.w_dir = 'tmp/deploy'
end
      EOS
    end

    def create
      if File.exist?(path)
        puts "#{path} already exist."
      else
        File.open(path, 'w+') do |f|
          f.write(content)
        end
        puts "#{path} created. Feel free to chenge it!"
      end
    end
  end
end
