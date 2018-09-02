<html>
    <head>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.5.3/css/bulma.min.css" rel="stylesheet">
            <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-mfizz/2.4.1/font-mfizz.min.css" rel="stylesheet">
    </head>
    <body>
        <section class="hero">
            <div class="hero-body">
                <div class="container">
                    <h1 class="title">
                        Devbox
                    </h1>
                    <h2 class="subtitle">
                        A vagrant LAMP box based on Ubuntu Xenial 16.04.
                    </h2>
                </div>
            </div>
        </section>
        <section class="section">
            <div class="container">
                <img src="tty.gif">
                </img>
            </div>
        </section>
        <section class="section">
            <div class="container">
                <h2 class="title is-4">
                    What's installed?
                </h2>
                <ul>
                    <li>
                        <i aria-hidden="true" class="icon-ubuntu">
                        </i>
                        Ubuntu Xenial 16.04 (Bento base box, since Canonical's one is weirdly configured)
                    </li>
                    <li>
                        <i aria-hidden="true" class="fa fa-linux">
                        </i>
                        Ondrej and git core ppas so we get recent versions of php and git
                    </li>
                    <li>
                        <i aria-hidden="true" class="icon-git">
                        </i>
                        Git, imagemagick, build-essential and a bunch of other standard tools
                    </li>
                    <li>
                        <i aria-hidden="true" class="icon-apache">
                        </i>
                        Apache2
                    </li>
                    <li>
                        <i aria-hidden="true" class="icon-database-alt2">
                        </i>
                        MariaDB and MongoDB
                    </li>
                    <li>
                        <i aria-hidden="true" class="icon-php">
                        </i>
                        PHP7 and a load of extensions (see phpinfo output below)
                    </li>
                    <li>
                        <i aria-hidden="true" class="icon-php">
                        </i>
                        Composer and PHPUnit installed globally
                    </li>
                    <li>
                        <i aria-hidden="true" class="icon-nodejs">
                        </i>
                        Node 8 LTS and npm
                    </li>
                    <li>
                        <i aria-hidden="true" class="icon-nodejs">
                        </i>
                        Yarn, Gulp and Browserify installed globally, plus Micro editor
                    </li>
                </ul>
            </div>
        </section>
        <section class="section">
            <div class="container">
                <h2 class="title is-4">
                    Connecting
                </h2>
                <ul>
                    <li>
                        <i aria-hidden="true" class="fa fa-chrome">
                        </i>
                        Point your browser at <a href="http://192.168.33.10">192.168.33.10</a> or edit your hosts file for a friendlier URL
                    </li>
                    <li>
                        <i aria-hidden="true" class="fa fa-plug">
                        </i>
                        You can ssh in very simply with
                        <code>
                            $ vagrant ssh
                        </code>
                         or use host: 192.168.33.10 port: 22 p: vagrant u: vagrant
                    </li>
                    <li>
                        <i aria-hidden="true" class="icon-mariadb">
                        </i>
                        MariaDB with SequelPro: Standard u: root, p: root host: 192.168.33.10 port 3306
                    </li>
                    <li>
                        <i aria-hidden="true" class="icon-mongodb">
                        </i>
                        MongoDB with Robo3T: Connection address: localhost:27017 SSH address: 192.168.3310 u: vagrant p: vagrant Auth Method: Password
                    </li>
                </ul>
            </div>
        </section>
        <section class="section">
            <div class="container">
                <h2 class="title is-4">
                    Info
                </h2>
                <ul>
                    <li>
                        <i aria-hidden="true" class="fa fa-info">
                        </i>
                        Check the readme for more info, delve into the build script (setup.sh) or check out the phpinfo output below.
                    </li>
                    <li>
                        <i aria-hidden="true" class="fa fa-github">
                        </i>
                        This is all on <a href="https://github.com/moussaclarke/devbox">github</a> and it's MIT licensed
                    </li>
                </ul>
            </div>
        </section>
        <section class="section">
            <div class="container">
<?php
ob_start();
phpinfo(INFO_GENERAL | INFO_CONFIGURATION | INFO_MODULES);
$phpi = ob_get_contents();
ob_end_clean();
$phpi= (str_replace("module_Zend Optimizer", "module_Zend_Optimizer", preg_replace('%^.*<body>(.*)</body>.*$%ms', '$1', $phpi)));
$phpi = preg_replace('#<table[^>]*>#', '<table class="table is-striped">', $phpi);
$phpi = preg_replace('#(\w),(\w)#', '\1, \2', $phpi);
$phpi = preg_replace('#<hr />#', '', $phpi);
$phpi = str_replace('<div class="center">', '', $phpi);
$phpi = str_replace('<h1 class="p">', '<h1 class="title is-3">', $phpi);
$phpi = str_replace('<h1>', '<h1 class="title is-3">', $phpi);
$phpi = str_replace('<h2>', '<h1 class="title is-5">', $phpi);
$phpi = preg_replace('#<tr class="h">(.*)<\/tr>#', '<thead><tr class="h">$1</tr></thead><tbody>', $phpi);
$phpi = str_replace('</table>', '</tbody></table>', $phpi);
$phpi = str_replace('</div>', '', $phpi);
echo $phpi;
?>
            </div>
        </section>
    </body>
</html>