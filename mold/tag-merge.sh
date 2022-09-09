# check if CI is set
if [ -z ${CI+x} ]; then
  echo 'Cannot run in non-CI environment.' >&2
  exit 1
fi

echo "Placing SSH keys..."
mkdir -p ~/.ssh
cp deploy_key ~/.ssh/id_rsa
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
ssh-keyscan gitlab.com > ~/.ssh/known_hosts

export MR_ID=$(echo $CI_COMMIT_MESSAGE | grep -o -e "[0-9]\+$")
if [ -n "$MR_ID" ]; then
  echo "Tagging mr$MR_ID"
  git remote set-url origin git@gitlab.com:$CI_PROJECT_PATH
  git remote -v
  git tag mr$MR_ID
  git push --tags
fi
