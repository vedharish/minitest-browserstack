require 'rake'
require 'yaml'
require 'rake/testtask'
require 'browserstack/local'

def run_tests(config_path, spec_file, run_parallel=false)
  config = YAML.load_file(config_path)
  wait_pids = []
  config["browser_caps"].length.times do |index|
    wait_pids << fork do
      ENV["test_config_path"] = config_path
      ENV["test_index"] = index.to_s
      require spec_file
    end
    
    wait_pids.delete_if { |pid| Process.wait pid; true } if !run_parallel
  end
  
  wait_pids.delete_if { |pid| Process.wait pid; true } if run_parallel
end

task :single do |t, args|
  puts "Running Single Tests"
  run_tests('config/single.config.yml', './specs/single_test.rb', false)
end

task :local do |t, args|
  puts "Running Local Tests"
  bs_local = BrowserStack::Local.new
  bs_local_args = { "key" => ENV['BROWSERSTACK_ACCESS_KEY'] || config['key'] }
  bs_local.start(bs_local_args)

  begin
    run_tests('./config/local.config.yml', './specs/local_test.rb', false)
  ensure
    bs_local.stop
  end
end

task :parallel do |t, args|
  puts "Running Parallel Tests"
  num_parallel = 4

  run_tests('./config/parallel.config.yml', './specs/single_test.rb', true)
end

task :test do |t, args|
  Rake::Task["single"].invoke
  Rake::Task["local"].invoke
  Rake::Task["parallel"].invoke
end
