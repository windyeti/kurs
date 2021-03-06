# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "kurs"
set :repo_url, "git@github.com:windyeti/kurs.git"

set :deploy_to, "/var/www/kurs"

append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public", "storage"

set :format, :pretty
set :log_level, :info
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

after 'deploy:publishing', 'unicorn:restart'
