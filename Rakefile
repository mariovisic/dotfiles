require 'rake'

desc 'symlink all dot files into the home directory'
task :default do
  git_pull
  Dir['*'].each do |file|
    unless ['Rakefile', 'README.md'].include?(file)
      link_file(file)
    end
  end
end

def git_pull
  system 'git pull'
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
