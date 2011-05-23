#!/usr/bin/env ruby

Signal.trap(:INT) { puts "Interrupted"; exit 1 }
CONFIG_FILE = File.join(ENV['HOME'], ".tmux/paster.conf")

$menu = [
  "split-window",
  "clock-mode",
  "copy-mode",
  "log"
  # %qcommand-prompt -p "Log file name: " "pipe-pane -o 'cat >>~/tmuxlog/%%'"
] 

# to insert special key(such as Ctrl-A). In vim enter insert mode then use C-v then C-a
$special_key_table = {
  "C-p" => "",
  "C-a" => "",
}
$special_key_table = $special_key_table.invert

module Tmux
  class Tmux::Buffer
    class << self
      def set(str, opt = nil)
        nl = ""
        nl = "\015" if opt[:newline]
        system("tmux set-buffer #{str}#{nl}")
      end

      def current_pane
        `tmux display-message -p '#P'`.chomp.to_i
      end

      def send_key(str, opt = nil)
        newline = ''
        newline = 'C-m' if opt[:newlmne]
        system("tmux send-keys -t #{current_pane - 1} #{str} #{newline}")
      end

      def paste(opt = nil)
        system("tmux paste-buffer -d -t#{current_pane - 1}")
      end
    end
  end

  class Tmux::Menu
    def show
      $menu.each_with_index {|e,idx| puts "#{idx+1} #{e}" }
    end
    def split
      system("tmux split-window -h -l #{@@menu_width} ")
    end
  end
end

def shell_escape(str) 
  String(str).gsub(/(?=[^a-zA-Z0-9_.\/\-\x7F-\xFF\n])/n, '\\').gsub(/\n/, "'\n'").sub(/^$/, "''") 
end

def load_config
  load CONFIG_FILE
end

def register(opt)
  @pw_table ||= {}
  opt[:key] =~ /^C-/
  @pw_table.store(opt[:key], shell_escape(opt[:string]))
end

def pw_table
  @pw_table
end

def read_char
  system "stty raw -echo"
  STDIN.getc
ensure
  system "stty -raw echo"
end
def read_line
  system "stty raw -echo"
  STDIN.readline
ensure
  system "stty -raw echo"
end

def sendkey
  load_config
  print pw_table.keys.sort_by {|e| e.to_s.downcase }.join(" ") , ': '

  c = read_char
  key = c.chr.to_s
  key = $special_key_table.fetch(key,key)
  if val = pw_table.fetch(key, nil)
    Tmux::Buffer.set(val, :newline => true)
    Tmux::Buffer.paste
  end
end

def menu
  Tmux::Menu.new.split
end

def menu_select
  Tmux::Menu.new.show
  c = read_char
  original_window = `tmux display-message -p '#P'`.chomp.to_i - 1
  key = c.chr.to_s.to_i - 1
  cmd = "tmux #{$menu[key]}"
  system(%!tmux send-keys -t #{original_window} "#{cmd}" Enter!)
end

LAYOUT_FILE = File.expand_path("~/tmux/layout")
def save_layout
  window_index = `tmux display-message -p "#I"`.chomp.to_i
  layout = `tmux lsw`.scan(/layout:\s+(.*)$/).flatten[window_index]
  File.open(LAYOUT_FILE, 'w'){|io| io.write layout }
end
def load_layout
  layout = File.read(LAYOUT_FILE)
  system("tmux select-layout '#{layout}'")
  system("tmux refresh-client")
end

command = ARGV.shift
case command
when 'sendkey'; then sendkey
when 'menu';    then menu
when 'menu_select';    then menu_select
when 'save_layout';    then save_layout
when 'load_layout';    then load_layout
else
end
