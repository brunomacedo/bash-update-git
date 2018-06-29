alias s='git status -s'
alias status='git status -s'
alias add='git add .'
alias commit='git commit -m'
alias push='git push'
alias pull='git pull'
alias discart='git checkout -f'
alias clone='git clone'
alias cherry='git cherry -v'

alias vscode='"/c/Program Files/Microsoft VS Code/Code.exe"'
alias code='"/c/Program Files/Microsoft VS Code/Code.exe"'
alias www='cd /c/www'
alias templates='cd /c/www/templates'
alias hosts='vscode "/c/Windows/System32/drivers/etc/hosts"'

alias run='/c/www/run.sh 80 443'
alias dev='gulp dev'
alias prod='gulp prod'
alias open='gulp open'
alias stop='gulp kill'
alias help='gulp help'

fhelp() {
  if [ "$1" ]; then
    help | grep "$1" --color=auto
  else
    echo "It needs one argument."
  fi
}

isRemoteGit() {
  if [ -d ".git" ]; then
    cd ".git"
    if [ -f "config" ] && grep -q remote "config"; then
      cd ..
      pull
    else
      echo "Remote does not exists"
      cd ..
    fi
  else
    echo "Repo does not exists"
  fi
}

update() {
  if [ -d "templates" ]; then
    templates
    enterTemplates="yes"
  else
    enterTemplates="no"
  fi

  folders=($(ls -d */ | cut -f1 -d'/'))
  for dirName in ${!folders[@]}; do
    echo ""

    cd ${folders[$dirName]}
    echo "Opening ${folders[$dirName]}"

    isRemoteGit

    cd ..
    echo "Closing"
    echo ""
	done

  if [ $enterTemplates = "yes" ]; then
    www
  fi
}

logs() {
  if [ "$1" ] && [ "$2" ]; then
    git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date-order -n "$1" --date=short --author="$2"
  elif [ "$1" ]; then
    git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date-order -n "$1" --date=short
  else
    git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date=short
  fi
}

changes() {
  if [ -z "$(git status --porcelain)" ]; then
    changed=true
  else
    changed=false
  fi
  echo "$changed"
}

gcommit() {
	getChange="$(changes)"
	git status -s

  echo ""
  echo "You have some modified files to commit."
	echo "Would you like to commit it? [1] Yes [2] No"
  echo ""
	read SEND

	if [ $SEND == "1" ]; then
		if [ $getChange == "false" ]; then
			git add . && git commit -m "$1" && git push
    else
			echo "Nothing to commit"
		fi
	fi
}

bump() {
  getChange="$(changes)"

  if [ $getChange == "true" ]; then
    npm version "$1" -m "Bumped to version %s"
  else
    gcommit "Before bump commit"
  fi
}
