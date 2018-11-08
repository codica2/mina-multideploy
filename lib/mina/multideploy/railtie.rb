module Multideploy
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'mina/tasks/multideploy_tasks.rake'
    end
  end
end
