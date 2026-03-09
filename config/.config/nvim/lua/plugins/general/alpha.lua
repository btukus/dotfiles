return {
    "goolord/alpha-nvim",
    dependencies = { 'nvim-mini/mini.icons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
};
