# Completions for functions defined in this directory (loaded last; compinit ran earlier)

# gwa: local branches and origin's branches
_gwa() {
  local -a branches
  branches=(${(u)${${(f)"$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes/origin 2>/dev/null)"}#origin/}})
  branches=(${branches:#HEAD})
  _describe 'branch' branches
}
compdef _gwa gwa

# docker helpers: container names
_dcontainers() {
  local -a containers
  containers=(${(f)"$(docker ps -a --format '{{.Names}}' 2>/dev/null)"})
  _describe 'container' containers
}
compdef _dcontainers de dip dbr

# tj: projects known to the sessionizer
_tj() {
  local -a projects
  projects=(${(f)"$("${ZDOTDIR:h}/scripts/zellij-sessionizer" --list 2>/dev/null)"})
  _describe 'project' projects
}
compdef _tj tj
