# Shell Startup Performance Optimization

## Analysis of zprof Output

Based on the profiling data, here are the **top time consumers**:

### Major Bottlenecks

| Rank | Function | Time (ms) | % | Source |
|------|----------|-----------|---|--------|
| 1 | `fast-highlight-process` | 280ms total | 24.5% | fast-syntax-highlighting |
| 2 | `‚É¶É≤chroma/-source.ch` | 208ms | 18.2% | fast-syntax-highlighting |
| 3 | `zvm_update_cursor` | 157ms | 13.7% | zsh-vi-mode |
| 4 | `_zsh_autosuggest_*` | ~128ms | 11% | zsh-autosuggestions |
| 5 | `asdf_update_java_home` | 52ms | 4.5% | asdf java plugin |
| 6 | `compinit` | 36ms | 3.2% | zsh completions |
| 7 | `zvm_define_widget` | 31ms | 2.7% | zsh-vi-mode |

### Key Observations

1. **fast-syntax-highlighting** is the biggest offender (~280-490ms combined)
2. **zsh-vi-mode** adds ~190ms for cursor/widget handling
3. **zsh-autosuggestions** widget binding takes ~128ms
4. **asdf_update_java_home** runs on every startup (52ms) - likely unnecessary
5. **compinit** can be cached to reduce 36ms

---

## Recommended Fixes

### 1. ASDF Java Home (52ms saved)
**File:** `zsh/source-scripts/asdf.zsh`

The `asdf_update_java_home` function runs on every prompt/startup. Should only run once or on directory change.

```bash
# Current (runs every time):
. ~/.asdf/plugins/java/set-java-home.zsh

# Fix: Only set once, not on every prompt
if [[ -z "$JAVA_HOME" ]]; then
  export JAVA_HOME="$HOME/.asdf/installs/java/$(asdf current java 2>/dev/null | awk '{print $2}')"
fi
```

### 2. Completion Caching (36ms saved)
**File:** `zsh/source-scripts/load-completions.zsh`

The `compinit` runs every time. Add caching:

```bash
# Cache completions for 24 hours
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C  # Use cached version
fi
```

### 3. Defer zsh-vi-mode (~100ms saved)
**File:** `zsh/antidote/shared_plugins.txt`

zsh-vi-mode is already deferred but still slow. Consider:
- Using `bindkey -v` directly (minimal vi mode)
- Or lazy-load vi-mode only when needed

### 4. Consider lighter syntax highlighting
**Current:** `zdharma-continuum/fast-syntax-highlighting` (280ms+)
**Alternative:** Could use simpler highlighting or defer it

The deferred loading helps but it still processes on first keystroke.

### 5. Lazy-load autosuggestions binding
The `_zsh_autosuggest_bind_widgets` takes 81ms binding 1183 widgets. This could be deferred further.

---

## Quick Wins (Implement Now)

| Fix | Estimated Savings | Effort |
|-----|-------------------|--------|
| Cache compinit | 36ms | Low |
| Fix asdf java home | 52ms | Low |
| Silent SSH key loading | Already done | Done |

**Total quick wins: ~88ms**

---

## Files to Modify

1. `zsh/source-scripts/load-completions.zsh` - Add compinit caching
2. `zsh/source-scripts/asdf.zsh` - Fix java home to run once

---

## Verification

```bash
# Profile startup time
time zsh -i -c exit

# Detailed profiling (add to .zshrc temporarily)
zmodload zsh/zprof
# ... at end:
zprof
```

---

## Current vs Target

| Metric | Current | Target |
|--------|---------|--------|
| Total startup | ~1100ms | ~600ms |
| Quick wins | - | ~88ms saved |
| With optimizations | - | ~400-500ms |

Note: Powerlevel10k's instant prompt already makes the shell *feel* instant even with longer actual startup.
