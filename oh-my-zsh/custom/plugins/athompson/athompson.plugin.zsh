c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

PATH=$PATH:~/bin
PATH=/home/ubuntu/tools/Maven/Default/bin:$PATH

export EDITOR='vim'
export VAGRANT_DEFAULT_PROVIDER='virtualbox'

# autocorrect is more annoying than helpful
unsetopt correct_all

# disabling some dragons
#unalias gp # git push
#unalias git-svn-dcommit-push # git and svn mix 
#unalias ggpush # git push current branch
#unalias ggpnp # git pull and push current branch

# a few aliases I like
alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias git-personal-repo-email='git config --add user.email netengr2009@gmail.com'
alias git-personal-add-ssh-key='ssh-add ~/.ssh/id_rsa_github_personal'
alias gmlg='git log --author=Andrew_Thompson@rapid7.com'
alias tlf='tail -f'
alias tf='terraform'

ssh_aws_list() {
    echo $1 | awk -F' ' '{ print $2 }' | xargs -I {} ssh -o StrictHostKeyChecking=no {} "echo;ec2metadata|grep public-hostname;$2"
}

ssh_list() {
    echo $1 | xargs -I {} ssh -o StrictHostKeyChecking=no {} "echo;ec2metadata|grep public-hostname;$2"
}

scp() {
    if [[ "$@" =~ : ]];then
        /usr/bin/scp $@
    else
        echo 'You forgot the colon dumbass!'
    fi
} # Catch a common scp mistake.

vaild_json() {
    FILE=$1
    ruby -rjson -e "p ! JSON.parse(File.open('$FILE').read).empty?"
}

# Given content like the following passed as the first argument
# this should build the methods needed to write most of the convection
# code for you.  You will have to do some massaging of the method names,
# but this takes most of the grunt work out.
# 
# Example:
# 
# % convection_gen_code ""Count" : String,
#"Handle" : String,
#"Timeout" : String"
convection_gen_code() {
    echo $1 | sed "s/\"//g" | cut -d ':' -f 1 | tr -d ' ' | xargs -I {} printf "property \:{}, '{}'\n"
}

# Usage:
# tunnel host port
# tunnel host remoteport localport
# tunnel host remoteport localport passthruhost
tunnel() {
    PROXYHOST=$1
    RPORT=$2
    LPORT=$3
    PASSTHRUHOST=$4

    if [ -z $PROXYHOST ]; then
        echo "tunnel PROXYHOST REMOTE_PORT [LOCAL_PORT] [PASS_THRU_HOST]"
    fi

    if [ -z $RPORT ]; then
        echo "tunnel PROXYHOST REMOTE_PORT [LOCAL_PORT] [PASS_THRU_HOST]"
    fi

    if [ -z $LPORT ]; then
        LPORT=$RPORT
    fi

    if [ -z $PASSTHRUHOST ]; then
        PASSTHRUHOST=localhost
    fi

    ssh $PROXYHOST -L ${LPORT}:$PASSTHRUHOST:${RPORT}
}

list-access-keys() {
    aws iam list-users | jq --raw-output '.[][].UserName' | xargs -I {} aws iam list-access-keys --user-name "{}"
}

restart_vbox_network_adapter() {
    ADAPTER=${1:-"vboxnet1"}

    sudo ifconfig $ADAPTER down
    sudo ifconfig $ADAPTER up
}

kill_vagrant_run() {
    ps aux | grep ruby | grep vagrant | awk '{ print $2 }' | xargs kill
}

vagrant() {
    PWD=$(pwd)
    if [ -f "$PWD/Buildfile" ]; then
        echo "Running in a Builderator environment"
        ruby_version=$(ruby -e'puts RUBY_VERSION')
        if [ -f ~/.rbenv/shims/vagrant ]; then
            rm ~/.rbenv/shims/vagrant
        fi

        case $@ in
        provision)
            bundle exec build prepare
            bundle exec build vagrant provision default --provision-with chef_solo
            ;;
       "up --provider aws")
           bundle exec build ec2
           ;;
       up)
           bundle exec build local
           ;;
       ssh)
           bundle exec build vagrant ssh
           ;;
       *)
           cd .builderator
           /usr/local/bin/vagrant $@
           cd -
           ;;
       esac
    else
        echo "NOT Running in a Builderator environment"
        /usr/local/bin/vagrant "$@"
    fi
}

vagrant-base() {
    PWD=$(pwd)
    if [ -f "$PWD/Buildfile" ]; then
        echo "Running in a Builderator environment"
        ruby_version=$(ruby -e'puts RUBY_VERSION')
        if [ -f ~/.rbenv/shims/vagrant ]; then
            rm ~/.rbenv/shims/vagrant
        fi

        case $@ in
        provision)
            bundle exec build prepare
            bundle exec build vagrant provision vagrant-base --provision-with chef_solo
            ;;
       "up --provider aws")
           bundle exec build ec2
           ;;
       up)
           bundle exec build local bake
           ;;
       ssh)
           bundle exec build vagrant ssh
           ;;
       *)
           cd .builderator
           /usr/local/bin/vagrant $@
           cd -
           ;;
       esac

    else
        echo "NOT Running in a Builderator environment"
        /usr/bin/vagrant "$@"
    fi
}

git-worktree-add() {
    BASE_BRANCH=$1
    BRANCH=$2

    REPO=$(basename $(git rev-parse --show-toplevel))
    BASEDIR=$(dirname $(git rev-parse --show-toplevel))

    NEWDIR="${BASEDIR}/${REPO}-${BRANCH}"

    git worktree add -b $BRANCH $NEWDIR $BASE_BRANCH
    echo
    echo "Entering new worktree"
    echo
    cd $NEWDIR
    echo "When finished, delete the branch and directory:"
    echo "% cd ${BASEDIR}/${REPO}"
    echo "% git branch -d $BRANCH"
    echo "% rm -rf $NEWDIR"
    echo "% git worktree prune" 
    echo
}

ccm_setup() {
    sudo ifconfig lo0 alias 127.0.0.2 up
    sudo ifconfig lo0 alias 127.0.0.3 up
    sudo ifconfig lo0 alias 127.0.0.4 up
    sudo ifconfig lo0 alias 127.0.0.5 up
    sudo ifconfig lo0 alias 127.0.0.6 up
    sudo ifconfig lo0 alias 127.0.1.1 up
    sudo ifconfig lo0 alias 127.0.1.2 up
    sudo ifconfig lo0 alias 127.0.1.3 up
    sudo ifconfig lo0 alias 127.0.1.4 up
    sudo ifconfig lo0 alias 127.0.1.5 up
    sudo ifconfig lo0 alias 127.0.1.6 up
    }

