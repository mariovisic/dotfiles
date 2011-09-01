require 'rake'

desc 'symlink all dot files into the home directory'
task :default do
  git_pull
  ignored_files = ['Rakefile', 'README.md']
  Dir['*'].each { |file| link_file(file) unless ignored_files.include?(file) }
end

def git_pull
  system 'git pull'
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
