#!/usr/bin/bash
password=$(readlink -f $1)
num_threads=$(nproc --all)
install_utils=(vim git)
bspwm_deps=(libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev)
bspwm_repo=https://github.com/baskerville/bspwm.git
sxhkd_repo=https://github.com/baskerville/sxhkd.git

function print_usage () {
    echo "Usage: $0 password_file"
}

function install_from_git () {
    local repo_url=$1
    local package=$(echo $repo_url | cut -d'/' -f5 | cut -d'.' -f1)
    git clone $repo_url
    cd $PWD/$package && make -j$num_threads && sudo -S -k make install < $password
    cd $OLDPWD
    rm -rf $PWD/$package
}

if [[ $# != 1 ]]; then
    print_usage
    exit 1
else
    # 1. Upgrade system repositories and install bspwm dependencies
    sudo -S -k apt-get update -y < $password
    sudo -S -k apt-get install ${bspwm_deps[@]} -y < $password
    sudo -S -k apt-get install ${install_utils[@]} -y < $password

    # 2. Install bspwm and sxhkd
    bspwm -v &> /dev/null
    if [[ $? != 0 ]]; then
        install_from_git $bspwm_repo
        install_from_git $sxhkd_repo
        mkdir -p ~/.config/{bspwm,sxhkd}
        cp /usr/local/share/doc/bspwm/examples/bspwmrc $HOME/.config/bspwm/
        cp /usr/local/share/doc/bspwm/examples/sxhkdrc $HOME/.config/sxhkd/
        chmod u+x $HOME/.config/bspwm/bspwmrc
    fi

    # 3. Run bspwm on X startup
    if [[ ! -e $HOME/.xinitrc ]]; then
        cp $PWD/.xinitrc $HOME/.xinitrc
    fi

    # 4. Install compton
    compton -h &> /dev/null
    if [[ $? != 0 ]]; then
        sudo -S -k apt-get install compton -y < $password
    fi

    # 5. Install feh
    feh -v &> /dev/null
    if [[ $? != 0 ]]; then
        sudo -S -k apt-get install feh -y < $password
    fi
fi
