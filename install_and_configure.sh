#!/bin/bash

# OSごとに異なるパッケージマネージャーを設定
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if ! command -v brew &> /dev/null; then
        # Homebrewがインストールされていない場合はインストール
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    package_manager="brew"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Ubuntu
    package_manager="apt"
else
    echo "This script supports only macOS and Ubuntu."
    exit 1
fi

# スクリプトのディレクトリを取得
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# dotfiles フォルダのパス
dotfiles_dir="$script_dir/dotfiles"

# ステータスメッセージを表示する
show_status() {
    echo -e "\033[1;34m$1\033[0m"  # 青色の文字で表示
}

# エラーが発生した場合に終了する関数
exit_on_error() {
    local exit_code=$1
    local error_message=$2
    if [ "$exit_code" -ne 0 ]; then
        echo -e "\033[1;31mError: $error_message\033[0m"
        exit "$exit_code"
    fi
}

# スクリプトの進捗メッセージを表示
echo "🚀 Script is in progress..."
echo -e

# 一度だけパッケージマネージャーを更新
show_status "⚙️  Updating package list"
if [[ "$package_manager" == "brew" ]]; then
    brew update
else
    sudo $package_manager update
fi
exit_on_error $? "Failed to update package list."
echo -e

# 関数: パッケージのインストール状態を確認して表示する
check_and_install() {
    package_name=$1
    show_status "⚙️  Checking $package_name"
    if command -v "$package_name" &> /dev/null; then
        installed_version=$($package_name --version)
        echo "✅ $package_name is already installed (Version: $installed_version)"
    else
        show_status "🔧 Installing $package_name"
        if [[ "$package_manager" == "brew" ]]; then
            brew install "$package_name"
        else
            sudo $package_manager install -y "$package_name"
        fi
        exit_on_error $? "Failed to install $package_name."
        installed_version=$($package_name --version)
        echo "✅ $package_name installed successfully (Version: $installed_version)"
    fi
}

# 関数: パッケージの設定ファイルを取得・適用する
get_and_apply_config() {
    package_name=$1
    config_file=$2
    show_status "⚙️  Configuring $package_name"
    
    if [ -e "${HOME}/${config_file}" ]; then
        # 既存の設定ファイルが存在する場合はバックアップを作成
        backup_file="${HOME}/${config_file}_backup_$(date +"%Y%m%d%H%M%S")"
        mv "${HOME}/${config_file}" "$backup_file"
        echo "📁 Backup created for existing $package_name config file: $backup_file"
    fi
    
    # dotfiles フォルダから設定ファイルを取得
    cp "$dotfiles_dir/$config_file" "${HOME}/${config_file}"
    exit_on_error $? "Failed to copy $package_name configuration file."
    echo "✅ $package_name configuration applied successfully: ${HOME}/${config_file}"
}

# Zshのインストールと設定ファイルの取得・適用
check_and_install "zsh"
get_and_apply_config "Zsh" ".zshrc"
echo -e

# Emacsのインストールと設定ファイルの取得・適用
check_and_install "emacs"
get_and_apply_config "Emacs" ".emacs.el"
echo -e

# Tmuxのインストールと設定ファイルの取得・適用
check_and_install "tmux"
get_and_apply_config "Tmux" ".tmux.conf"
echo -e

# tmux-mem-cpu-loadのインストール
show_status "⚙️  Checking tmux-mem-cpu-load"
if command -v "tmux-mem-cpu-load" &> /dev/null; then
        echo "✅ tmux-mem-cpu-load is already installed"
    else
        show_status "🔧 Installing tmux-mem-cpu-load"
        if [[ "$package_manager" == "brew" ]]; then
            brew install tmux-mem-cpu-load
        else
            git clone https://github.com/thewtex/tmux-mem-cpu-load.git
            cd tmux-mem-cpu-load || exit
            cmake .
            make
            sudo make install
        fi
        exit_on_error $? "Failed to install tmux-mem-cpu-load"
        echo "✅ tmux-mem-cpu-load installed successfully"
    fi

# スクリプトの進捗メッセージを終了
echo "🎉 Script execution completed!"
