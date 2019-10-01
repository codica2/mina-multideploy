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
    puts "Run 'ruby ./#{c.w_dir}/servers_deploy.rb' to start deploy"
  end

  desc 'Prepare deploy scripts and start deploying'
  task :start :environment do
    c = Mina::Multideploy.configuration
    Multideploy::CreateScripts.call
    exec "ruby ./#{c.w_dir}/servers_deploy.rb"
  end

  desc 'Runing mina or rake tasks'
  task :run, [:task_arg] => [:environment] do |task, args|
    c = Mina::Multideploy.configuration
    Multideploy::CreateScripts.call
    exec "ruby ./#{c.w_dir}/servers_deploy.rb #{args[:task_arg]}"
  end
end
