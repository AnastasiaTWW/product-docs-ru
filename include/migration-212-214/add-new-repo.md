1. Откройте файл с адресом репозитория Валарм WAF в установленном редакторе текста. В инструкции используется редактор **vim**.

    === "Debian"
        ```bash
        sudo vim /etc/apt/sources.list.d/wallarm.list
        ```
    === "Ubuntu"
        ```bash
        sudo vim /etc/apt/sources.list.d/wallarm.list
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        sudo vim /etc/yum.repos.d/wallarm-node.repo
        ```
2. Закомментируйте указанный адрес репозитория Валарм WAF и укажите новый для версии 2.14:

    === "Debian 8.x (jessie-backports)"
        ``` bash
        # deb http://repo.wallarm.com/debian/wallarm-node jessie/
        # deb http://repo.wallarm.com/debian/wallarm-node jessie-backports/
        deb http://repo.wallarm.com/debian/wallarm-node jessie/2.14/
        deb http://repo.wallarm.com/debian/wallarm-node jessie-backports/2.14/
        ```
    === "Debian 9.x (stretch)"
        ``` bash
        # deb http://repo.wallarm.com/debian/wallarm-node stretch/
        deb http://repo.wallarm.com/debian/wallarm-node stretch/2.14/
        ```
    === "Debian 9.x (stretch-backports)"
        ```bash
        # deb http://repo.wallarm.com/debian/wallarm-node stretch/
        # deb http://repo.wallarm.com/debian/wallarm-node stretch-backports/
        deb http://repo.wallarm.com/debian/wallarm-node stretch/2.14/
        deb http://repo.wallarm.com/debian/wallarm-node stretch-backports/2.14/
        ```
    === "Ubuntu 16.04 LTS (xenial)"
        ```bash
        # deb http://repo.wallarm.com/ubuntu/wallarm-node xenial/
        deb http://repo.wallarm.com/ubuntu/wallarm-node xenial/2.14/
        ```
    === "Ubuntu 18.04 LTS (bionic)"
        ```bash
        # deb http://repo.wallarm.com/ubuntu/wallarm-node bionic/
        deb http://repo.wallarm.com/ubuntu/wallarm-node bionic/2.14/
        ```
    === "CentOS 6.x"
        ```bash
        [wallarm-node]
        # baseurl=http://repo.wallarm.com/centos/wallarm-node/6/$basearch
        baseurl=http://repo.wallarm.com/centos/wallarm-node/6/2.14/$basearch
        ```
    === "CentOS 7.x"
        ```bash
        [wallarm-node]
        # baseurl=http://repo.wallarm.com/centos/wallarm-node/7/$basearch
        baseurl=http://repo.wallarm.com/centos/wallarm-node/7/2.14/$basearch
        ```
3. Загрузите файлы из новых репозиториев:

    === "Debian"
        ```bash
        sudo apt update
        ```
    === "Ubuntu"
        ```bash
        sudo apt update
        ```
    === "CentOS или Amazon Linux 2"
        ```bash
        sudo yum update
        ```
