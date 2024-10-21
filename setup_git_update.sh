# Pull updates and return to working directory
git_pull_setup()
{
  cd /home/$usrname/.pisetup/$repo
  git pull https://github.com/cms66/$repo
  cd $OLDPWD
  read -p "Finished setup update, press enter to return to menu" input
}
