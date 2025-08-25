# Mario Visic's Dotfiles
Dotfiles to setup OS X systems for ruby, rails, rubygems, git, vim and more.

## New system setup:

```sh

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies for zsh shell and prompt
brew install mise romkatv/gitstatus/gitstatus

# Clone this repo and setup:
git clone https://github.com/mariovisic/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

rake
```
