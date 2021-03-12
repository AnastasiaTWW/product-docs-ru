=== "Debian 8.x (jessie-backports)"
    ```bash
    sudo apt install dirmngr
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    echo 'Acquire::Check-Valid-Until "false";' | sudo tee /etc/apt/apt.conf.d/ignore-release-date
    echo 'deb http://archive.debian.org/debian jessie-backports/ main' | sudo tee /etc/apt/sources.list.d/jessie-backports.list
    echo 'deb http://repo.wallarm.com/debian/wallarm-node jessie/' | sudo tee /etc/apt/sources.list.d/wallarm.list
    echo 'deb http://repo.wallarm.com/debian/wallarm-node jessie-backports/' | sudo tee --append /etc/apt/sources.list.d/wallarm.list
    sudo apt update
    ```
=== "Debian 9.x (stretch)"
    ```bash
    sudo apt install dirmngr
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    sh -c "echo 'deb http://repo.wallarm.com/debian/wallarm-node stretch/2.14/' | sudo tee /etc/apt/sources.list.d/wallarm.list"
    sudo apt update
    ```
=== "Debian 10.x (buster)"
    ```bash
    sudo apt install dirmngr
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    sh -c "echo 'deb http://repo.wallarm.com/debian/wallarm-node buster/2.14/' | sudo tee /etc/apt/sources.list.d/wallarm.list"
    sudo apt update
    ```
=== "Ubuntu 16.04 LTS (xenial)"
    ```bash
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    sh -c "echo 'deb http://repo.wallarm.com/ubuntu/wallarm-node xenial/2.14/' | sudo tee /etc/apt/sources.list.d/wallarm.list"
    sudo apt update
    ```
=== "Ubuntu 18.04 LTS (bionic)"
    ```bash
    curl -fsSL https://repo.wallarm.com/wallarm.gpg | sudo apt-key add -
    sh -c "echo 'deb http://repo.wallarm.com/ubuntu/wallarm-node bionic/2.14/' | sudo tee /etc/apt/sources.list.d/wallarm.list"
    sudo apt update
    ```
=== "CentOS 6.x"
    ```bash
    sudo yum install --enablerepo=extras -y epel-release centos-release-SCL
    sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/6/2.14/x86_64/Packages/wallarm-node-repo-1-5.el6.noarch.rpm
    ```
=== "CentOS 7.x"
    ```bash
    sudo yum install -y epel-release
    sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/7/2.14/x86_64/Packages/wallarm-node-repo-1-5.el7.noarch.rpm
    ```
=== "Amazon Linux 2"
    ```bash
    sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/7/2.14/x86_64/Packages/wallarm-node-repo-1-5.el7.noarch.rpm
    ```
