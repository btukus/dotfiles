# Rebase zsh-z entries (path|rank|time) from one directory prefix to another.
# An entry is rewritten only if the new directory exists; duplicates are merged
# (ranks summed, latest timestamp kept), preserving original order.
#   awk -F'|' -v old=/from -v new=/to -f zshz-rebase.awk .zshz
{
  p = $1
  if (index(p, old "/") == 1 || p == old) {
    np = new substr(p, length(old) + 1)
    if (system("test -d \"" np "\"") == 0) p = np
  }
  if (!(p in rank)) order[++n] = p
  rank[p] += $2
  if ($3 > time[p]) time[p] = $3
}
END { for (i = 1; i <= n; i++) { p = order[i]; print p "|" rank[p] "|" time[p] } }
