git add .
echo -n "what is this change?"
read;
git commit -m "${REPLY}"
git branch -M main
git remote add origin https://github.com/aginaugustine/CAPM.git
git push -u origin main