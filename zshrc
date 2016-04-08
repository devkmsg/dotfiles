ZSH=$HOME/.oh-my-zsh
ZSH_THEME="rbates"
DISABLE_AUTO_UPDATE="true"
DISABLE_LS_COLORS="false"

if [[ $(uname) == Linux ]]; then
    plugins=(git athompson)
else
    plugins=(git brew gem vagrant athompson rapid7)
fi

export PATH="/usr/local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

if [[ $(uname) != Linux ]]; then
    # for Homebrew installed rbenv
    if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi
