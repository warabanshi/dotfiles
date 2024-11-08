# Setup windows environment

## install WSL2

Launch powershell with admin previleges

```
> wsl --install
```

## install packages

Launch powershell with admin previleges then move directory to where the winget.ps1 is placed

```
> Set-ExecutionPolicy RemoteSigned
> .\winget.ps1
> Set-ExecutionPolicy Restricted
```
