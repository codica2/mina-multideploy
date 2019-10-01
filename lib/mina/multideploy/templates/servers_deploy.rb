require 'fileutils'
require 'logger'
require 'parallel'
require 'tty-progressbar'
# require 'byebug'

# Servers list
SERVERS = SERVERS_TO_REPLACE

w_dir = Dir.pwd
c_dir = "#{w_dir}/CUSTOM_W_DIR_TO_REPLACE/config"
l_dir = "#{w_dir}/CUSTOM_W_DIR_TO_REPLACE/log"
command_argument = ARGV[0] || 'deploy'

original_deploy_config = File.read("#{w_dir}/ORIGINAL_DEPLOY_FILE_TO_REPLACE")
max_ip_length = SERVERS.keys.map(&:length).max + 1
multibar = TTY::ProgressBar::Multi.new

FileUtils.mkdir_p c_dir unless File.exist?(c_dir)
FileUtils.mkdir_p l_dir unless File.exist?(l_dir)

# Deploy script
Parallel.each(SERVERS, in_threads: SERVERS.length) do |ip, names|
  bar = multibar.register("#{ip.ljust(max_ip_length)} [:current/:total] :report", total: names.size)
  bar.start

  report = ''
  bar.advance(0, report: report)

  names.each do |site|
    c_file_name = "#{ip}-#{site}.rb"
    l_file_name = "#{ip}-#{site}.log"

    custom_deploy_config = original_deploy_config.gsub(/^set :application_name(.*)/, "set :application_name, :#{site}")
    custom_deploy_config = custom_deploy_config.gsub(/^set :domain(.*)/, "set :domain, '#{ip}'")

    FileUtils.rm "#{l_dir}/#{l_file_name}" if File.exist?("#{l_dir}/#{l_file_name}")
    File.write("#{c_dir}/#{c_file_name}", custom_deploy_config)

    cmd = "mina #{command_argument} -f #{c_dir}/#{c_file_name}"
    cmd = `#{cmd}`

    logger = Logger.new("#{l_dir}/#{l_file_name}")
    logger.info(cmd)

    report += "#{site} ✗ " if cmd.include?('ERROR')
  
    bar.advance(report: report)
  end
end
