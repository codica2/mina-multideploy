lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mina/multideploy/version'

Gem::Specification.new do |spec|
  spec.name          = 'mina-multideploy'
  spec.version       = Mina::Multideploy::VERSION
  spec.authors       = ['Sergey Volkov']
  spec.email         = ['sergvolkov.codica@gmail.com']

  spec.summary       = 'Parallel deploying on multiple servers with mina.'
  spec.description   = 'This gem will help you deploy the application on multiple servers in parallel. It takes original mina deploy.rb file, changes application_name, domain and starts deploying process.'
  spec.homepage      = 'https://github.com/codica2/mina-multideploy'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
