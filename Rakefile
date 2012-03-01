require 'rake'

desc 'symlink all dot files into the home directory'
task :default do
  @ignored_files = ['Rakefile', 'README.md']

  perform("Updating dotfiles") { git_pull }
  link_files
end

def git_pull
  `git pull`
end

def link_files
  Dir['*'].each { |file| link_file(file) unless @ignored_files.include?(file) }
end

def link_file(file)
  home = `echo $HOME`.strip

  unless File.exists?("#{home}/.#{file}")
    perform "linking ~/.#{file}" do
      `ln -s "$PWD/#{file}" "#{home}/.#{file}"`
    end
  end
end

def perform(name, &block)
  print name
  yield
  print ' ' * (50 - name.size)
  print "DONE"
  puts
end
