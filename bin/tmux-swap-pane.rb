#!/usr/bin/env ruby

def swap(src, dst)
  system("tmux swap-pane -s#{src} -t#{dst}")
end

CONF="~/.tmux/lastpane"
PANE_DIRECTION_TBL = {
    :up    => "U",
    :down  => "D",
    :left  => "L",
    :right => "R",
    :master => "M",
}

def swap_to(direction)
  target = PANE_DIRECTION_TBL[direction]

  org_pane=`tmux display-message -p "#P"`.chomp
  system("tmux select-pane -#{target}")

  dst_pane=`tmux display-message -p "#P"`.chomp
  system("tmux select-pane -t#{org_pane}")

  if target == "M"
    dst_pane = 0
  end
  swap(*[ org_pane, dst_pane ])
  # p [ org_pane, dst_pane ]
  system("tmux select-pane -t#{dst_pane}")

  # File.open(File.expand_path(CONF)).read # => ""
  if target == "M"
    dst_pane = 0
    # File.open(File.expand_path(CONF),'w+').write(org_pane)
  end
end
# def exchange
  
# end

# p ARGV[0].intern
if PANE_DIRECTION_TBL.keys.include?(ARGV[0].intern)
  swap_to ARGV[0].intern
end
