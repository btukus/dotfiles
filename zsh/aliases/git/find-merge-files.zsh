function gfm() {
  git ls-files -u | awk '{print $4}' | sort | uniq
}
