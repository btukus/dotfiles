local status_ok, nvim_startup = pcall(require, "nvim-startup")
if not status_ok then
	return
end

nvim_startup.setup({
	startup_file = "/tmp/nvim-startuptime",
	message = "Whoa! those {} are pretty fast",
})
