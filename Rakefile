require "rake"

desc "symlink all dot files into the home directory"
task :default do
  @ignored_files = %w[Rakefile README.md nvim.init.lua]

  perform("Creating empty folders") { create_folders }
  perform("Updating dotfiles") { git_pull }
  link_files
  link_nvim_config
end

def git_pull
  `git pull`
end

def link_files
  Dir["*"].each { |file| link_file(file) unless @ignored_files.include?(file) }
end

def link_file(file, new_location = nil)
  home = `echo $HOME`.strip
  new_location ||= "#{file}"

  `rm "#{home}/.#{new_location}"` if File.exist?("#{home}/.#{new_location}")

  perform "linking ~/.#{new_location}" do
    `ln -s "$PWD/#{file}" "#{home}/.#{new_location}"`
  end
end

def link_nvim_config
  link_file("nvim", "config/nvim")
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
