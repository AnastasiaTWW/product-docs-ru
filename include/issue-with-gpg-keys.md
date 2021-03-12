!!! warning "Ошибка с ключом CentOS GPG"
    Если у вас уже добавлен репозиторий Валарм и вы получили ошибку, связанную с ключами CentOS GPG, следуйте инструкциям:

    1. Удалите предыдущий добавленный репозиторий, используя команду `yum remove wallarm‑node‑repo`.
    2. Добавьте репозиторий, используя команду с подходящей вкладки выше.

    Возможные сообщения об ошибках:

    * `http://repo.wallarm.com/centos/wallarm-node/7/2.14/x86_64/repodata/repomd.xml: [Errno -1] repomd.xml signature could not be verified for wallarm-node_2.14`
    * `One of the configured repositories failed (Wallarm Node for CentOS 7 - 2.14), and yum doesn't have enough cached data to continue.`
