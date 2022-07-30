local status_ok, regexplainer = pcall(require, "regexplainer")
if not status_ok then
  return
end

regexplainer.setup{
    filetypes = {
    'md',
    'scala',
    'cpp',
    'py',
    'lua',
    'cs',
    'java',
    'html',
    'js',
    'cjs',
    'mjs',
    'ts',
    'jsx',
    'tsx',
    'cjsx',
    'mjsx',
  },
}
