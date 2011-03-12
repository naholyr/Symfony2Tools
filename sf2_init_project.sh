SF2_PKG="Symfony_Standard_2.0.0PR7"
DIR=$(pwd)

echo Initialize new Symfony2 project...


# Git init

echo Check or initialize git repository...
if [ ! -d ".git" ]; then git init; fi


# Git config

echo Check git configuration...
if ! git config user.name > /dev/null; then echo 'No user.name defined ! Please run git config user.name "Your Name"'; exit 1; fi
if ! git config user.email > /dev/null; then echo 'No user.email defined ! Please run git config user.email "your@email.tld"'; exit 1; fi


# Download Symfony distribution to a temp folder and unarchive it

echo Download and unzip Symfony into /tmp/Symfony...
TMP=$(mktemp -d '_sf2XXX_')
cd $TMP
if ! (curl http://symfony.com/get/$SF2_PKG.tgz | tar zx); then echo 'Failed downloadig Symfony2 distribution.'; exit 1; fi
cd "$DIR"
mv $TMP/Symfony/* ./
rm -rf $TMP

git add .
git commit -a -m "Initialize new project from $SF2_PKG"


# For PR7: config.yml is invalid for current version of doctrine

echo Patching default config.yml to make it work with current Doctrine...
echo '@@ -28,17 +28,22 @@ assetic:
 # Doctrine Configuration
 doctrine:
     dbal:
-        driver:   %database_driver%
-        host:     %database_host%
-        dbname:   %database_name%
-        user:     %database_user%
-        password: %database_password%
-        logging:  %kernel.debug%
-
+        default_connection: default
+        connections:
+            default:
+                driver:   %database_driver%
+                host:     %database_host%
+                dbname:   %database_name%
+                user:     %database_user%
+                password: %database_password%
+                logging:  %kernel.debug%
     orm:
         auto_generate_proxy_classes: %kernel.debug%
-        mappings:
-            AcmeDemoBundle: ~
+        default_entity_manager: default
+        entity_managers:
+            default:
+                mappings:
+                    AcmeDemoBundle: ~
 
 # Swiftmailer Configuration
 swiftmailer:
-- 
' | patch -p0 app/config/config.yml

git add .
git commit -a -m "Fixed config.yml"


# Install vendors as submodules

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


# Execute assets task

echo Initialize assets...
app/console assets:install web/

git add web
git commit -a -m "Installed assets"


# Ignore logs & cache

echo '*' > app/logs/.gitignore
echo '*' > app/cache/.gitignore

git add -f app/logs/.gitignore app/cache/.gitignore
git commit app/logs/.gitignore app/cache/.gitignore -m "Ignore logs & cache"


echo Ready to go \!

echo "Add this virtual host to your Apache ('/etc/apache2/sites-available/yoursite'):"
echo "	<VirtualHost *:80>
		ServerName yoursite.localhost
		DocumentRoot "$(pwd)"
		DirectoryIndex app_dev.php
	</VirtualHost>"
echo "Then enable it ('sudo a2ensite yoursite') and reload Apache ('sudo service apache2 reload')"
echo "Add this line to your /etc/hosts:"
echo "	127.0.0.1 yoursite.localhost"
echo "And go to http://yoursite.localhost/app_dev.php/_configurator :)"
