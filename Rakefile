require 'rake'

desc 'symlink all dot files into the home directory'
task :default do
  @ignored_files = ['Rakefile', 'README.md', '.nvim.init.lua']

  perform("Creating vim backups folder") { create_vim_backups_folder }
  perform("Updating dotfiles")           { git_pull }
  # perform("Updating submodules")         { git_update_submodules }
  link_files
  link_nvim_config
end

def git_pull
  `git pull`
end

def git_update_submodules
  `git submodule update --init --recursive`
  `git submodule foreach git checkout master`
  `git submodule foreach git pull`
end

def link_files
  Dir['*'].each { |file| link_file(file) unless @ignored_files.include?(file) }
end

def link_file(file, new_location = nil)
  home = `echo $HOME`.strip
  new_location ||= "#{file}"

  if File.exists?("#{home}/.#{new_location}")
    `rm "#{home}/.#{new_location}"`
  end

  perform "linking ~/.#{new_location}" do
    `ln -s "$PWD/#{file}" "#{home}/.#{new_location}"`
  end
end

def link_nvim_config
  link_file('.nvim.init.lua', 'config/nvim/init.lua')
end

def create_vim_backups_folder
  `mkdir -p ~/.vimbackup`
end

def perform(name, &block)
  print name
  yield
  print ' ' * (50 - name.size)
  print "DONE"
  puts
end
