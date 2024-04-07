# Compit
Compit is a plugin for NeoVim to easily compile/run your code.

This repository is a fork of [paulfrische's Compit](github.com/paulfrische/compit),
adding support for background tasks.

### Usage
```lua
require('compit').run({})

-- to disable the prompt
require('compit').run({ prompt = false })

-- to kill the last command
require('compit').kill()
```

Or you make a keybind for it:
```lua
vim.api.nvim_set_keymap('n', '<leader>c', ':lua require("compit").run({})<CR>', { noremap = true })
```

After running the compile/run command compit saves it and will put it in next
time you use compit.

### Usage
Default mappings are:
- `<localleader>bb` to run the registered command
- `<localleader>bp` to register a new command
- `<localleader>bk` to kill the command

### Installation
Lazy:
```lua
return {
  "paulpatault/compit",
  config = function() require('compit').init() end,
  dependencies = "skywind3000/asyncrun.vim"
}
```

### Informations

The is one dependencies,
it is [Asyncrun.vim](https://github.com/skywind3000/asyncrun.vim)
to run task in background.
