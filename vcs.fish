
set -xg __fish_vcs_prompt_color yellow

function __vcs_info --description "Print a vcs prompt - supports git and hg"
  # find out if we're in a git or hg repo by looking for the control dir
  set -l d $PWD
  set -l git
  set -l hg

  while true
    if test -d "$d/.git"
      set git $d
      break
    else if test -d "$d/.hg"
      set hg $d
      break
    end
    if test "$d" = /
      break
    end
    # portable "realpath" equivalent
    set d (cd "$d/.."; and echo "$PWD")
  end

  set -l br
  if test -n "$hg"
    set -l file
    for file in "$hg/.hg/bookmarks.current" "$hg/.hg/branch"
      if test -f "$file"
        read br < "$file"
        break
      end
    end
  else if test -n "$git"
    if test -f "$git/.git/HEAD"
      read br < "$git/.git/HEAD"
      switch $br
        case 'ref: refs/heads/*'
          set br (echo $br | sed -e 's/^................//')
        case '*'
          set br (echo $br | sed -e 's/^/DETACHED @ /')
      end
    end
  end
  if test -n "$br"
    set_color $__fish_vcs_prompt_color
    printf ' %s' "$br"
  end
end
