#!/usr/bin/bash
pwnian_dir=$PWD
password=$(readlink -f $1)
num_threads=$(nproc --all)
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
    cd $pwnian_dir/$package && make -j$num_threads && sudo -S -k make install < $password
    cd $pwnian_dir
    rm -rf $pwnian_dir/$package
}

if [[ $# != 1 ]]; then
    print_usage
    exit 1
else
    # 1. Upgrade system repositories and install bspwm dependencies
    sudo -S -k apt-get update -y < $password
    sudo -S -k apt-get install ${bspwm_deps[@]} -y < $password

    # 2. Install bspwm and sxhkd
    bspwm -v &> /dev/null
    if [[ $? != 0 ]]; then
        sudo -S -k apt-get install bspwm -y < $password
        install_from_git $bspwm_repo
        install_from_git $sxhkd_repo
        mkdir -p ~/.config/{bspwm,sxhkd}
        cp $pwnian_dir/config/bspwm/bspwmrc $HOME/.config/bspwm/
        cp -R $pwnian_dir/config/bspwm/scripts $HOME/.config/bspwm
        cp $pwnian_dir/config/sxhkd/sxhkdrc $HOME/.config/sxhkd/
        chmod u+x $HOME/.config/bspwm/bspwmrc
    fi

    # 3. Run bspwm on X startup
    if [[ ! -e $HOME/.xinitrc ]]; then
        cp $pwnian_dir/.xinitrc $HOME/.xinitrc
    fi

    # 4. Install compton
    compton -h &> /dev/null
    if [[ $? != 0 ]]; then
        sudo -S -k apt-get install compton -y < $password
        cp -R $pwnian_dir/compton $HOME/.config
    fi

    # 5. Install feh
    feh -v &> /dev/null
    if [[ $? != 0 ]]; then
        sudo -S -k apt-get install feh -y < $password
        cp $pwnian_dir/wallpapers/red_scuba.jpg $HOME/Pictures
    fi

    # 6. Install rofi
    rofi -h &> /dev/null
    if [[ $? != 0 ]]; then
        sudo -S -k apt-get install rofi -y < $password
    fi
fi
