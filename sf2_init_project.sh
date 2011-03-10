SF2_PKG="Symfony_Standard_2.0.0PR7"
DIR=$(pwd)

echo Initialize new Symfony2 project...

echo Check or initialize git repository...
if [ ! -d ".git" ]; then git init; fi

echo Check git configuration...
if ! git config user.name > /dev/null; then echo 'No user.name defined ! Please run git config user.name "Your Name"'; exit 1; fi
if ! git config user.email > /dev/null; then echo 'No user.email defined ! Please run git config user.email "your@email.tld"'; exit 1; fi

echo Download and unzip Symfony into /tmp/Symfony...
TMP=$(mktemp -d)
cd $TMP
if ! (curl http://symfony.com/get/$SF2_PKG.tgz | tar zx); then echo 'Failed downloadig Symfony2 distribution.'; exit 1; fi
cd "$DIR"
mv $TMP/Symfony/* ./
rm -rf $TMP

git add .
git commit -a -m "Initialize new project from $SF2_PKG"

echo Install vendors...
curl https://github.com/symfony/symfony-standard/raw/master/bin/vendors.sh | bash

git add .
git commit -a -m "Added Symfony2 standard vendors"

echo Initialize assets...
app/console assets:install web/

echo '*' > app/logs/.gitignore
echo '*' > app/cache/.gitignore
git add -f app/logs/.gitignore app/cache/.gitignore
git commit app/logs/.gitignore app/cache/.gitignore -m "Ignore logs & cache"

git add .
git commit -a -m "Installed assets"

echo Ready to go \!
