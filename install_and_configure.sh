#!/bin/bash

# GitHubリポジトリのベースURLを変数に定義
base_repo_url="https://raw.githubusercontent.com/long-910/dotfiles/main"

# 関数: パッケージのインストール状態を確認して表示する
check_and_install() {
    package_name=$1
    show_status "⚙️  Checking $package_name"
    if command -v $package_name &> /dev/null; then
        installed_version=$($package_name --version)
        echo "✅ $package_name is already installed (Version: $installed_version)"
    else
        show_status "🔧 Installing $package_name"
        sudo apt update
        sudo apt install -y $package_name
        installed_version=$($package_name --version)
        echo "✅ $package_name installed successfully (Version: $installed_version)"
    fi
}

# 関数: パッケージの設定ファイルを取得・適用する
get_and_apply_config() {
    package_name=$1
    config_file=$2
    show_status "Configuring $package_name"
    
    if [ -e "${HOME}/${config_file}" ]; then
        # 既存の設定ファイルが存在する場合はバックアップを作成
        backup_file="${HOME}/${config_file}_backup_$(date +"%Y%m%d%H%M%S")"
        mv "${HOME}/${config_file}" "$backup_file"
        echo "📁 Backup created for existing $package_name config file: $backup_file"
    fi
    
    # リポジトリ内のdotfilesディレクトリから設定ファイルを取得
    curl -fsSL "$base_repo_url/dotfiles/$config_file" -o "${HOME}/${config_file}"
    echo "✅ $package_name configuration applied successfully: ${HOME}/${config_file}"
}

# 関数: ステータスメッセージを表示する
show_status() {
    echo -e "\033[1;34m$1\033[0m"  # 青色の文字で表示
}

# スクリプトの進捗メッセージを表示
echo "🚀 Script is in progress..."

# Zshのインストールと設定ファイルの取得・適用
check_and_install "zsh"
get_and_apply_config "Zsh" ".zshrc"

# Tmuxのインストールと設定ファイルの取得・適用
check_and_install "tmux"
get_and_apply_config "Tmux" ".tmux.conf"

# tmux-mem-cpu-loadのインストール
check_and_install "tmux-mem-cpu-load"

# Emacsのインストールと設定ファイルの取得・適用
check_and_install "emacs"
get_and_apply_config "Emacs" ".emacs"

# スクリプトの進捗メッセージを終了
echo "🎉 Script execution completed!"
