require "rake"

desc "symlink all dot files into the home directory"
task :default do
  @ignored_files = %w[config Rakefile README.md Brewfile]

  perform("Creating empty folders") { create_folders }
  perform("Updating dotfiles") { git_pull }

  link_root_files
  link_config_files

  install_brew_packages
end

def git_pull
  `git pull`
end

def link_root_files
  Dir["*"].each { |file| link_file(file) unless @ignored_files.include?(file) }
end

def link_file(file, prefix: '.')
  home = `echo $HOME`.strip
  new_location = [prefix, file].join

  `rm "#{home}/#{new_location}"` if File.exist?("#{home}/#{new_location}")

  perform "linking ~/#{new_location}" do
    `ln -s "$PWD/#{file}" "#{home}/#{new_location}"`
  end
end

def link_config_files
  Dir["config/*"].each { |file| link_file(file) }
end

def create_folders
  `mkdir -p ~/.config`
  `mkdir -p ~/.vimbackup`
end

def perform(name, &block)
  print name
  yield
  print " " * (50 - name.size)
  print "DONE"
  puts
end

def homebrew_installed?
  `brew help`.size > 0 rescue false
end

def install_brew_packages
  if homebrew_installed?
    perform("Installing homebrew packages") do
      `brew bundle`
    end
  else
    puts "\n!!! homebrew not installed, visit https://brew.sh/ to install !!!\n\n"
  end
end
