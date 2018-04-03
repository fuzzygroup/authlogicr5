source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'mechanize'


ruby '2.3.1'
####gem 'rails', '~> 5.0.2'
gem 'rails', '~> 5.1.3'
#gem 'rails', '5.1.3'

#gem 'puma', '~> 3.10'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
group :development, :test do
  gem 'byebug', platform: :mri
end
group :development do
  gem 'web-console', '>= 3.3.0'
  #gem 'listen', '~> 3.0.5'
  #gem 'spring'
  #gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'brakeman', :require => false
  gem 'rubocop', require: false
  
end
gem 'tzinfo-data'#, platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'bootstrap-sass'
gem 'high_voltage'
#gem 'mysql2', '~> 0.3.18'
gem 'mysql2', '~> 0.4'
gem 'simple_form'
gem 'capybara'
gem 'poltergeist'
group :development do
  gem 'better_errors'
  # gem 'capistrano', '~> 3.0.1'
  # gem 'capistrano-bundler'
  # gem 'capistrano-rails', '~> 1.1.0'
  # gem 'capistrano-rails-console'
  # gem 'capistrano-rvm', '~> 0.1.1'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'spring-commands-rspec'
  gem 'binding_of_caller'
  #gem 'rails_db'


  gem 'rails_real_favicon'

  
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'awesome_print', :require => 'ap'
end
group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'rails-controller-testing'
end


#A
gem 'authlogic', '~> 4.0.1'
###gem 'airbrake', '~> 5.0'
#gem 'arachni'
#B
#gem "bugsnag"

#C
######gem 'clockwork'
#D
gem 'elasticsearch-model', git: 'git://github.com/elastic/elasticsearch-rails.git', branch: 'master'
gem 'elasticsearch-rails', git: 'git://github.com/elastic/elasticsearch-rails.git', branch: 'master'

#E
#F
gem "font-awesome-rails"#, '~> 4.7.0.2'
gem "fuzzyurl"

#G
######gem 'github-trending', github: 'fuzzygroup/github-trending'
#H
gem 'httpclient'
#I
#gem 'identicon'

#J
#K
gem 'kramdown-rails'
gem 'kaminari'
#gem 'kaminari_themes', github: "https://github.com/amatsuda/kaminari_themes.git"
#L
#R
#gem 'ransack'
gem 'rack-attack'
#S
#gem 'sidekiq', '< 5'
gem 'sidekiq'
gem 'sys-filesystem'
#gem 'sparkpost_rails'
#T
#gem 'timber', '~> 2.0'
gem 'twilio-ruby'


gem 'rack-mini-profiler'
# For memory profiling (requires Ruby MRI 2.1+)
gem 'memory_profiler'

# For call-stack profiling flamegraphs (requires Ruby MRI 2.0.0+)
gem 'flamegraph'
gem 'stackprof'     # For Ruby MRI 2.1+

#w
gem 'wicked'
gem 'watir'

#x
# https://github.com/fuzzygroup/xbox-live-api
gem 'xbox_live_api'
#gem 'xbox_live_api', :git => "https://github.com/fuzzygroup/xbox-live-api.git"