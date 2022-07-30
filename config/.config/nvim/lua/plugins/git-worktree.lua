local dap_status_ok, git_worktree = pcall(require, "git-worktree")
if not dap_status_ok then
  return
end


git_worktree.setup({
    change_directory_command = "cd",
    update_on_change = true,
    update_on_change_command = "e .",
    clearjumps_on_change = true, 
    autopush = true
})
