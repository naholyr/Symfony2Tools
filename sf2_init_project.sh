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
git submodule add git://github.com/kriswallsmith/assetic.git vendor/assetic
git submodule add git://github.com/symfony/symfony.git vendor/symfony
git submodule add git://github.com/doctrine/doctrine2.git vendor/doctrine ; cd vendor/doctrine ; git reset --hard 2.0.2 ; cd ../..
git submodule add git://github.com/doctrine/dbal.git vendor/doctrine-dbal ; cd vendor/doctrine-dbal ; git reset --hard 2.0.2 ; cd ../..
git submodule add git://github.com/doctrine/common.git vendor/doctrine-common ; cd vendor/doctrine-common ; git reset --hard 2.0.1 ; cd ../..
git submodule add git://github.com/swiftmailer/swiftmailer.git vendor/swiftmailer ; cd vendor/swiftmailer ; git reset --hard origin/4.1 ; cd ../..
git submodule add git://github.com/fabpot/Twig.git vendor/twig
git submodule add git://github.com/fabpot/Twig-extensions.git vendor/twig-extensions
git submodule add git://github.com/symfony/zend-log.git vendor/zend-log/Zend/Log
git submodule add git://github.com/sensio/FrameworkExtraBundle.git vendor/bundles/Sensio/Bundle/FrameworkExtraBundle
git submodule add git://github.com/symfony/WebConfiguratorBundle.git vendor/bundles/Symfony/Bundle/WebConfiguratorBundle

git add .
git commit -a -m "Added Symfony2 standard vendors"

echo Initialize assets...
app/console assets:install web/
git add web
git commit -a -m "Installed assets"

echo '*' > app/logs/.gitignore
echo '*' > app/cache/.gitignore
git add -f app/logs/.gitignore app/cache/.gitignore
git commit app/logs/.gitignore app/cache/.gitignore -m "Ignore logs & cache"

echo Ready to go \!
