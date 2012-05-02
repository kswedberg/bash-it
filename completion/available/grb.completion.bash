# modified from: https://gist.github.com/1443992

###### grb commands ######
# => create new branch `branch`
#   $ grb new [branch] [--explain]
# => push branch `branch`, default current_branch
#   $ grb push [branch] [--explain]
# => rename `branch1` to `branch2`
#   $ grb mv   [branch1] [branch2] [--explain]
# => rename current branch to `branch`
#   $ grb mv branch [--explain]
# => delete branch `branch`,default current_branch
#   $ grb rm [branch] [--explain]
# => pull branch `branch`,default current_branch
#   $ grb pull [branch] [--explain]
# => track branch
#   $ grb track `branch` [--explain]
# => add a remote repo
#   $ grb remote_add `name` `repo path` [--explain]
# => remove a remote repo
#   $ grb remote_rm `name` [--explain]
# => prunes the remote branches from the list
#   $ grb prune


if which grb >/dev/null 2>&1; then

  _completion_list() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "$*" -- ${cur}) )
  }
  _complete_git() {
    if [ -d .git ]; then
      branches=`git branch | cut -c 3-`
      tags=`git tag`
      _completion_list $branches $tags
    fi
  }

  _complete_git_remote() {
    branches=`git branch -a | grep 'remotes/' | cut  -f '3' -d '/'`
    _completion_list $branches
  }

  _complete_grb() {
    # local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev=${COMP_WORDS[COMP_CWORD-1]}

    case $prev in
      pull|remote_rm|rm|track)
        _complete_git_remote
        return 0
        ;;
      mv|push)
        _complete_git
        return 0
        ;;
    esac

    commands=(new push mv rm pull track remote_add remote_rm prune)
    _completion_list "${commands[*]}"
  }

  complete -F _complete_grb grb

fi
