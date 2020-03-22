# dotfiles
linux user home dotfiles

### .gitignore

retrieve from as follows

```
curl -L https://raw.githubusercontent.com/github/gitignore/master/Global/Vim.gitignore -o .gitignore
```

### Add a plugin as a submodule

ex. syntacitc

```
$ mkdir -p .vim/pack/code/start/
$ git submodule add https://github.com/vim-syntastic/syntastic.git .vim/pack/code/start/syntactic
