#!/bin/bash

# Devbox setup, yo

export DEBIAN_FRONTEND=noninteractive

# Quiet
qu() {
    "$@" &> /dev/null;
}

echo "Getting Started. This will take a while..."

# Update
echo "Updates..."
qu sudo apt-get -y update

# Add Ondrej repo
echo "Ondrej repo..."
qu sudo add-apt-repository ppa:ondrej/php
echo "Update..."
qu sudo apt-get -y update

# Suppress dpkg errors by preventing debconf
echo "Suppress dpkg errors..."
sudo ex +"%s@DPkg@//DPkg" -cwq /etc/apt/apt.conf.d/70debconf
sudo dpkg-reconfigure debconf -f noninteractive -p critical

# Silly Git
echo "Git latest version..."
qu sudo apt-add-repository ppa:git-core/ppa
qu sudo apt-get update
qu sudo apt-get -y install git

# Basic tings
echo "Install basic tools..."
qu sudo apt-get -y install build-essential curl unzip imagemagick

# Incredible Bongo Band
echo "Michael Viner's Incredible Bongo Band presents..."
qu sudo apt-get -y install apache2
sudo a2enmod rewrite

# Rename webroot
echo "Configuring Web Root..."
sudo rm -r /var/www/html
sudo touch /etc/apache2/conf-enabled/000-default.conf
sudo cat >> /etc/apache2/conf-enabled/000-default.conf <<EOT
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/public
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
EOT

# Set permissions on the web root
echo "Setting Web Root permissions..."
sudo chown www-data -R /var/www/public/

# Install MariaDB
echo "I've just met a girl named MariaDB..."
qu sudo apt-get -y install mariadb-server mariadb-client

# Set up root user
mysql -u root <<-EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF

# Enable remote mysql access by commenting out relevant lines
sudo sed -i '/skip-external-locking/s/^/#/' /etc/mysql/mariadb.conf.d/50-server.cnf
sudo sed -i '/bind-address/s/^/#/' /etc/mysql/mariadb.conf.d/50-server.cnf
sudo service mysql restart

# Mongo like candy
echo "MongoDB like candy..."
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
qu sudo apt-get -y update
qu sudo apt-get install -y mongodb-org

sudo cat >> /etc/systemd/system/mongodb.service <<EOT
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl start mongodb
sudo systemctl enable mongodb

# Php and ting
echo "PHP 7 and extensions..."
qu sudo apt-get -y install php
qu sudo apt-get -y install php-fpm php-mysql libapache2-mod-php php-cli php-json php-xmlrpc php7.1-opcache php-zip php-imap php-curl php-xml php-gd php-mbstring php-dev php-pear php-imagick php-mongodb

# Wagner or Verdi
echo "Composer..."
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo rm composer-setup.php
composer -V

# Testy-eye
echo "PhpUnit..."
qu sudo wget https://phar.phpunit.de/phpunit-6.2.phar
sudo chmod +x phpunit-6.2.phar
sudo mv phpunit-6.2.phar /usr/local/bin/phpunit
phpunit --version

# Node ftw
echo "Node 8 LTS..."
curl -sL https://deb.nodesource.com/setup_8.x | qu sudo -E bash -
qu sudo apt-get install -y nodejs

## Spinning a yarn
echo "Yarn..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
qu sudo apt-get -y update && qu sudo apt-get -y install yarn

## Gulp it down
echo "Gulp..."
sudo npm install gulp-cli -g

## Browserify
echo "Browserify..."
sudo npm install -g browserify

## Micro ('cos Slap seems to be abandoned)
echo "Micro editor..."
sudo snap install micro --classic
sudo git config --global core.editor "micro"

# Restart Michael Viner
echo "Restart Apache..."
sudo service apache2 restart

# Upgrades
echo "Final upgrades..."
qu sudo apt-get -y dist-upgrade
qu sudo apt-get -y upgrade

# Welcome splash
echo "Setting up welcome splash..."
sudo cat > /etc/update-motd.d/00-header <<'EOF'
#!/bin/sh

[ -r /etc/lsb-release ] && . /etc/lsb-release

if [ -z "$DISTRIB_DESCRIPTION" ] && [ -x /usr/bin/lsb_release ]; then
    # Fall back to using the very slow lsb_release utility
    DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi

printf '
        _            _               
     __| | _____   _| |__   _____  __
    / _` |/ _ \ \ / /  _ \ / _ \ \/ /
   | (_| |  __/\ V /| |_) | (_) >  < 
    \__,_|\___| \_/ |_.__/ \___/_/\_\
    
    '
    
printf "\n\r"

printf "Built on %s (%s %s %s)\n" "$DISTRIB_DESCRIPTION" "$(uname -o)" "$(uname -r)" "$(uname -m)"
EOF

sudo cat > /etc/update-motd.d/10-help-text <<'EOF'
#!/bin/sh

printf "\n"
printf " * A LAMP stack with MariaDB, PHP7 plus a bunch of extensions\n"
printf " * Also Git, MongoDB, Node, Yarn, Gulp, Composer, PhpUnit, Micro and more\n"
printf " * More info at  https://github.com/moussaclarke/devbox\n"
EOF

echo "And we're done... Try '$ vagrant ssh' or visiting http://192.168.33.10 in your browser"