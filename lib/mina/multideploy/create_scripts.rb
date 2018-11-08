require 'fileutils'

module Multideploy
  class CreateScripts < BaseService
    attr_reader :c

    def initialize
      @c = Mina::Multideploy.configuration
    end

    def call
      create_dir
      write_bash_script
      write_ruby_script
    end

    private

    def working_dir
      c.w_dir
    end

    def create_dir
      FileUtils.mkdir_p(working_dir)
    end

    def deploy_file
      'server_deploy.rb'
    end

    def bash_script
      script = '#!/bin/bash'
      script << "\n\n"
      script << "echo 'Deploy started!'"
      script << "\n\n"
      script << c.servers.keys.map { |ip| "ruby \"$PWD/#{working_dir}/#{deploy_file}\" --ip #{ip} &\n" }.join('')
      script << "\n"
      script << 'wait'
      script << "\n"
      script << "echo 'Deploy finished!'"
    end

    def write_bash_script
      File.open("#{working_dir}/multideploy", 'w+') do |f|
        f.write(bash_script)
      end
      FileUtils.chmod 0755, "#{working_dir}/multideploy"
    end

    def ruby_script
      template_path = File.join(File.dirname(__FILE__), "./templates/#{deploy_file}")
      script = File.read(template_path)
      script = script.gsub('SERVERS_TO_REPLACE', c.servers.inspect)
      script = script.gsub('ORIGINAL_DEPLOY_FILE_TO_REPLACE', c.original)
      script = script.gsub('CUSTOM_W_DIR_TO_REPLACE', c.w_dir)
    end

    def write_ruby_script
      File.open("#{working_dir}/#{deploy_file}", 'w+') do |f|
        f.write(ruby_script)
      end
      FileUtils.chmod 0755, "#{working_dir}/#{deploy_file}"
    end
  end
end
