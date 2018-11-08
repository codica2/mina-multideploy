require 'mina/multideploy/init'
require 'mina/multideploy/create_scripts'

namespace :multideploy do
  desc 'Create initializer file'
  task init: :environment do
    Multideploy::Init.call
  end

  desc 'Prepare deploy scripts'
  task prepare: :environment do
    c = Mina::Multideploy.configuration
    Multideploy::CreateScripts.call
    puts "Run './#{c.w_dir}/multideploy' to start deploy"
  end

  desc 'Prepare deploy scripts and start deploying'
  task start: :environment do
    c = Mina::Multideploy.configuration
    Multideploy::CreateScripts.call
    exec "./#{c.w_dir}/multideploy"
  end
end
