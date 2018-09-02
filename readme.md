# Devbox
```
        _            _               
     __| | _____   _| |__   _____  __
    / _` |/ _ \ \ / /  _ \ / _ \ \/ /
   | (_| |  __/\ V /| |_) | (_) >  < 
    \__,_|\___| \_/ |_.__/ \___/_/\_\
```
A vagrant LAMP stack based on Ubuntu Xenial 16.04 with MariaDB, PHP7 plus a bunch of extensions. Also Git, MongoDB, Node, Yarn, Gulp, Composer, PhpUnit, Micro and more.

I'm currently using this as my base dev setup. I'd been using scotchbox for a while, but wanted to learn how to provision everything myself.

Grab it from [https://github.com/moussaclarke/devbox](https://github.com/moussaclarke/devbox)

## Requirements
Vagrant and Virtualbox (Other VMs probably work too, but that's what I use)

## Setup
* `$ git clone https://github.com/moussaclarke/devbox`
* `$ cd devbox`
* `$ vagrant up`
* Wait for it to download and provision, could take a fair few minutes so go and make a cuppa
* You can then `$ vagrant ssh` to get in to the box

## Web root
The web folder `/var/www/public/` is synched to the host computer. You can put your php projects in there and see them at `http://192.168.33.10`

## Edit Hosts file
Get a friendlier local url by editing your hosts file. Add the following:

`192.168.33.10 dev.box dev.box`

You can then visit `http://dev.box`

## What gets installed
* Ubuntu Xenial 16.04 (bento base box, since Canonical's one is weirdly configured)
* Ondrej and git core ppas so we get recent versions of php and git
* Git, imagemagick, build-essential and a bunch of other standard tools
* Apache2
* MariaDB and MongoDB
* PHP7 and a load of extensions
* Composer and PHPUnit installed globally
* Node 8 LTS and npm
* Yarn, Gulp and Browserify installed globally, plus Micro Editor
* Have a look at the setup.sh provisioning script for more info

## Connecting to DB from the host
* MariaDB with SequelPro: Standard u: root, p: root host: 192.168.33.10 port 3306
* MongoDB with Robo3T: Connection address: localhost:27017 SSH address: 192.168.3310 u: vagrant p: vagrant Auth Method: Password

## Will it run framework X?
* It seems to run Slim, Laravel, October and Wordpress just fine. Haven't tried any others, but should be good to go.

## Todo
* Some checks to make sure everything actually get installed
* More php extensions?
* Redis? Memcached?

## Contributing
Feel free to send suggestions or pull requests.

## License
MIT
