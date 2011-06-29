Advanced tmux configuration
==================================
Personal tmux configration, setting is dedicated for my daily work.
Most of lines are commented out, I keep these unused config un-delete for reference.

個人的な tmux の設定。俺の仕事に特化している。一般化していない。
多くがコメントアウトされているが、これは俺がいろいろ検討した際の残骸で、
参考になるかもしれないので、あえて残している。

## tmux.rb
Emulate two step key-bind(which GNU screen provided as `bind -c class`).
Currently 2-step kebind only for pasting some string.
try

    mkdir ~/.tmux/
    echo 'register :key => "C-p", :string => "ABC"' >> ~/.tmux/paster.conf
    echo 'register :key => "j", :string => "DEF"' >> ~/.tmux/paster.conf
    tmux.rb sendkey


tmux.rb は GNU screen ではできてた 2ステップキーバインドをエミュレートしたくて作った。
他の機能をつけようとして中途半端な状態。だが、2ステップペースト自体は動く。
そのうちちゃんとする。

## tmux-swap-pane.rb
provide MOVE pane any direction you want.

pane を 好きな方向に移動する機能を実現している。

## Useful shell function for Shell
you can change `default-path` easily with `tcd` command.

cd /var/tmp and set `default-path` to /var/tmp
    tcd /var/tmp

set `default-path` to current directory
    tcd<Enter>

add following fragment to ~/.zshrc

    function tcd(){
      if [ -z $1 ]; then
        tmux set default-path $PWD
      else
        if [ -d $1 ]; then
          cd $1 && tmux set default-path $1
        fi
      fi
    }

try then understand how it work
    cd ~
    tmux 
    tcd /var/tmp
    tmux split-window
    tcd /etc
    tmux split-window

## Mac user CMD key as META
My setting use `<M-` prefixed keybinding heavily.
For Mac user, I reccoment user CMD key as META(`<M->`) key.
I used to Mac and iTerm 6th months ago.
When I used Mac, I set CMD key as `META` key.
It required patch the src and build with Xcode.
But know It seem to easier than ever.

http://d.hatena.ne.jp/a_bicky/20110205/1296877645

## Other interesting Project
* [tmux-ruby](https://github.com/dominikh/tmux-ruby)
* [tmuxinator](https://github.com/aziz/tmuxinator)
