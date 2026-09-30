# Homebrew TritonDFT

Homebrew installer for TritonDFT, an AI-powered local-to-cluster DFT workflow
agent.

## Install

```bash
brew tap ktalit/tritondft
brew install tritondft
tritondft init
tritondft doctor
```

Edit `~/.tritondft/config.yaml` with your compute-cluster settings and API
keys, then run `tritondft`.

## Upgrade

```bash
brew update
brew upgrade tritondft
```
