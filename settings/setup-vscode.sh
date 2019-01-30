#!/bin/bash
echo "Note: probably a good idea to run setup.sh first"

if ! hash code; then
    echo "VSCode not installed, exiting"
    exit 1
fi

shopt -s expand_aliases

alias c="code --install-extension"

c kalitaalexey.vscode-rust
c DavidAnson.vscode-markdownlint
c EditorConfig.EditorConfig
c chiehyu.vscode-astyle
c ms-python.python
c ms-vscode.cpptools
c ms-vscode.PowerShell
c waderyan.gitblame
c rogalmic.bash-debug
c dan-c-underwood.arm
c christian-kohler.npm-intellisense
c eg2.vscode-npm-script
c austin.code-gnu-global
c msjsdiag.debugger-for-chrome
c redhat.java
c ms-vscode.csharp
c peterjausovec.vscode-docker
c ms-vscode.go
c donjayamanne.githistory
c redhat.vscode-yaml
c yzhang.markdown-all-in-one
c shinnn.stylelint
c streetsidesoftware.code-spell-checker
