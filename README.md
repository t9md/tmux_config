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

    function tcd(){
      if [ -z $1 ]; then
        tmux set default-path $PWD
      else
        if [ -d $1 ]; then
          cd $1 && tmux set default-path $1
        fi
      fi
    }

## Other interesting Procect
[tmux-ruby](https://github.com/dominikh/tmux-ruby)
[tmuxinator](https://github.com/aziz/tmuxinator)
