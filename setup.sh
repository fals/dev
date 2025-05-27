#!/bin/bash

set -e

echo "preparing dev dirs..."
mkdir -p ~/tmp
mkdir -p ~/projects/
echo "done preparing dev dirs"

echo "preparing zsh..."
if ! [ -x "$(command -v zsh)" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # zsh-newuser-install
fi
if ! [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi
echo "done preparing zsh..."

echo "preparing tmux..."
if ! [ -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
cp .tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf
echo "done preparing tmux"
echo "installing tools.."

if ! [ -x "$(command -v lazygit)" ]; then
  echo "installing lazygit..."
  if ! [ -x "$(command -v go)" ]; then
    echo "Go is not installed. Please install Go first."
    exit 1
  fi
  git clone https://github.com/jesseduffield/lazygit.git ~/tmp/lazygit
  cd ~/tmp/lazygit
  go install
  rm -rf ~/tmp/lazygit
else
  echo "lazygit already installed"
fi

if ! [ -x "$(command -v fzf)" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi
echo "done installing tools"
echo "configuring git..."
git config merge.conflictstyle diff3
git config merge.tool vimdiff
git config mergetool.prompt false
echo "done configuring git"
