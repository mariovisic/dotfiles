require 'rake'

desc 'symlink all dot files into the home directory'
task :default do
  @ignored_files = ['Rakefile', 'README.md']

  perform("Creating vim backups folder") { create_vim_backups_folder }
  perform("Updating dotfiles")           { git_pull }
  perform("Updating submodules")         { git_update_submodules }
  link_files
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

def link_file(file)
  home = `echo $HOME`.strip

  if File.exists?("#{home}/.#{file}")
    `rm "#{home}/.#{file}"`
  end

  perform "linking ~/.#{file}" do
    `ln -s "$PWD/#{file}" "#{home}/.#{file}"`
  end
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
