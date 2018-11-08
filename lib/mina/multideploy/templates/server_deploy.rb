require 'fileutils'
require 'logger'
require 'optparse'
# require 'byebug'

# Servers list
SERVERS = SERVERS_TO_REPLACE

# Read entered options
options = {}
OptionParser.new do |parser|
  parser.banner = 'Usage: hello.rb [options]'

  parser.on('-h', '--help', 'Show this help message') do
    puts parser
  end

  parser.on('--ip IP', 'The ip address server to deploy.') do |v|
    options[:ip] = v
  end
end.parse!

ip    = options[:ip]
w_dir = Dir.pwd
c_dir = "#{w_dir}/CUSTOM_W_DIR_TO_REPLACE/config"
l_dir = "#{w_dir}/CUSTOM_W_DIR_TO_REPLACE/log"
original_deploy_config = File.read("#{w_dir}/ORIGINAL_DEPLOY_FILE_TO_REPLACE")

FileUtils.mkdir_p c_dir unless File.exist?(c_dir)
FileUtils.mkdir_p l_dir unless File.exist?(l_dir)

# Deploy report to console
class SiteDeployReport

  attr_reader :ip, :site, :status

  def initialize(ipaddress, site, status)
    @ip     = ipaddress
    @site   = site
    @status = status
  end

  def call
    puts "#{ip} - #{site} - #{status}"
  end

end

# Deploy script
SERVERS[ip].each do |site|
  c_file_name = "#{ip}-#{site}.rb"
  l_file_name = "#{ip}-#{site}.log"

  FileUtils.rm "#{l_dir}/#{l_file_name}" if File.exist?("#{l_dir}/#{l_file_name}")
  logger = Logger.new("#{l_dir}/#{l_file_name}")

  custom_deploy_config = original_deploy_config.gsub(/^set :application_name(.*)/, "set :application_name, :#{site}")
  custom_deploy_config = custom_deploy_config.gsub(/^set :domain(.*)/, "set :domain, '#{ip}'")

  File.write("#{c_dir}/#{c_file_name}", custom_deploy_config)

  cmd = "mina deploy -f #{c_dir}/#{c_file_name}"
  cmd = `#{cmd}`

  logger.info(cmd)

  raise 'ERROR: Deploy failed.' if cmd.include?('ERROR: Deploy failed.')

rescue StandardError => e
  SiteDeployReport.new(ip, site, '✗').call
  logger.error(e)
else
  SiteDeployReport.new(ip, site, '✓').call
end
