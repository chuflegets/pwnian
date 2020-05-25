#!/usr/bin/bash
pwnian_dir=$PWD
password=$(readlink -f $1)
num_threads=$(nproc --all)
bspwm_deps=(libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev)
polybar_deps=(build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev)
polybar_optional_deps=(libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libnl-genl-3-dev)
bspwm_repo=https://github.com/baskerville/bspwm.git
polybar_release=https://github.com/polybar/polybar/releases/download/3.4.0/polybar-3.4.0.tar
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

function install_bspwm () {
    bspwm -v &> /dev/null
    if [[ $? != 0 ]]; then
        sudo -S -k apt-get install bspwm -y < $password
        mkdir -p ~/.config/bspwm
        cp -R $pwnian_dir/config/bspwm/scripts $HOME/.config/bspwm
        cp $pwnian_dir/config/bspwm/bspwmrc.tpl $HOME/.config/bspwm/bspwmrc
        sed -i "s#%HOME%#${HOME}#g" $pwnian_dir/config/bspwm/bspwmrc
        chmod u+x $HOME/.config/bspwm/bspwmrc
    fi
}

function install_sxhkd () {
    sxhkd -v &> /dev/null
    if [[ $? != 0 ]]; then
        sudo -S -k apt-get install sxhkd -y < $password
        mkdir -p ~/.config/sxhkd
        cp $pwnian_dir/config/sxhkd/sxhkdrc.tpl $HOME/.config/sxhkd/sxhkdrc
        sed -i "s#%HOME%#${HOME}#g" $pwnian_dir/config/sxhkd/sxhkdrc
    fi
}

if [[ $# != 1 ]]; then
    print_usage
    exit 1
else
    # 1. Upgrade system repositories and install bspwm dependencies
    sudo -S -k apt-get update -y < $password
    sudo -S -k apt-get install ${bspwm_deps[@]} -y < $password
    cp $pwnian_dir/.vimrc $HOME/

    # 2. Install bspwm and sxhkd
    #install_from_git $bspwm_repo
    #install_from_git $sxhkd_repo
    install_bspwm
    install_sxhkd

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

    # 7. Install polybar
    polybar -h &> /dev/null
    if [[ $? != 0 ]]; then
        sudo -S -k apt-get install ${polybar_deps[@]} -y < $password
        sudo -S -k apt-get install ${polybar_optional_deps[@]} -y < $password
        polybar_tar=$pwnian_dir/$(echo $polybar_release | awk -F / '{ print $NF }')
        polybar_dir=$pwnian_dir/$(echo polybar_tar | cut -d'-' -f1)
        wget $polybar_release && tar xf $polybar_tar && rm -rf $polybar_tar
        cd $polybar_dir && mkdir build && cd $polybar_dir/build
        cmake .. && make -j$num_threads && sudo -S -k make install < $password
        cd $pwnian_dir && rm -rf $polybar_dir
    fi
fi
