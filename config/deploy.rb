# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "kurs"
set :repo_url, "WWWWWWWW git@example.com:me/my_repo.git WWWWWWWWWWW"

set :deploy_to, "/var/www/kurs"

append :linked_files, "config/database.yml", "config/master.key"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public", "storage"

set :format, :pretty
set :log_level, :info
set :unicorn_rack_env, -> { production }

after 'deploy:publishing', 'unicorn:restart'