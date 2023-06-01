git add .
echo -n "what is this change?"
read;
git commit -m "${REPLY}"
git push --set-upstream orgin main