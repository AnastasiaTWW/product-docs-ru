# Ошибки после установки Валарм WAF

## После установки WAF не работают сценарии загрузки файлов. Как исправить?

Еcли у вас не работают сценарии для загрузки файлов после установки WAF‑ноды, то проблема заключается в том, что размер запросов не укладывается в лимит, заданный параметром `client_max_body_size` в конфигурационном файле Валарм.

Рекомендуется изменить значение `client_max_body_size` с директивой `location` только для адреса, где принимаются загружаемые файлы. Такая конфигурация предотвратит поступление объемных запросов на главную страницу.

Измените значение `client_max_body_size`:

1. Откройте для редактирования конфигурационный файл в папке `/etc/nginx-wallarm`.
2. Укажите новое значение:

	```
	location /file/upload {
	 client_max_body_size 16m;
	}
	```

	* `/file/upload` – адрес, где принимаются загружаемые файлы.

Подробное описание директивы доступно в [официальной документации NGINX](https://nginx.org/ru/docs/http/ngx_http_core_module.html#client_max_body_size).

## Как исправить ошибки вида: signature could not be verified for wallarm-node, yum doesn't have enough cached data to continue?

При истечении срока действия GPG-ключей для RPM-пакетов Валарм вы можете получить ошибки вида:

```
https://repo.wallarm.com/centos/wallarm-node/7/2.18/x86_64/repodata/repomd.xml:
[Errno -1] repomd.xml signature could not be verified for wallarm-node_2.18`

One of the configured repositories failed (Wallarm Node for CentOS 7 - 2.18),
and yum doesn't have enough cached data to continue.`
```

Чтобы исправить ошибки, связанные с GPG-ключами, необходимо:

1. Удалить предыдущий добавленный репозиторий, используя команду:

	```bash
	sudo yum remove wallarm-node-repo
	```
2. Добавить новый репозиторий, используя команду для подходящей версии CentOS и WAF-ноды:

	=== "CentOS 6.x"
		```bash
		# WAF-нода и постаналитика версии 2.14
		sudo rpm --install https://repo.wallarm.com/centos/wallarm-node/6/2.14/x86_64/Packages/wallarm-node-repo-1-6.el6.noarch.rpm
		```
	=== "CentOS 7.x или Amazon Linux"
		```bash
		# WAF-нода и постаналитика версии 2.14
		sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/7/2.14/x86_64/Packages/wallarm-node-repo-1-6.el7.noarch.rpm

		# WAF-нода и постаналитика версии 2.16
		sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/7/2.16/x86_64/Packages/wallarm-node-repo-1-6.el7.noarch.rpm

		# WAF-нода и постаналитика версии 2.18
		sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/7/2.18/x86_64/Packages/wallarm-node-repo-1-6.el7.noarch.rpm
		```
	=== "CentOS 8.x"
		```bash
		# WAF-нода и постаналитика версии 2.16
		sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/8/2.16/x86_64/Packages/wallarm-node-repo-1-6.el8.noarch.rpm

		# WAF-нода и постаналитика версии 2.18
		sudo rpm -i https://repo.wallarm.com/centos/wallarm-node/8/2.18/x86_64/Packages/wallarm-node-repo-1-6.el8.noarch.rpm
		```
