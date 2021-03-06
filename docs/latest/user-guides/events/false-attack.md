[link-analyzing-attacks]:       analyze-attack.md
[img-false-attack]:             ../../images/user-guides/events/false-attack.png
[img-popup]:                    ../../images/user-guides/events/pop-up-accept.png
[img-removed-atack-info]:       ../../images/user-guides/events/removed-attack-info.png

# Работа с ложным срабатыванием: Атаки

## Что такое ложное срабатывание?

[Ложное срабатывание](../../about-wallarm-waf/protecting-against-attacks.md#ложные-срабатывания) — обнаружение признаков атаки в легитимном запросе.

Проанализировав атаку, вы можете прийти к выводу, что все запросы в атаке или часть из них являются ложным срабатыванием. Чтобы WAF‑нода не распознавала такие запросы как атаки при дальнейшем анализе трафика, вы можете отметить несколько запросов или атаку полностью как ложное срабатывание.

## Как работает отметка о ложном срабатывании?

* При добавлении отметки о ложном срабатывании к атаке любого типа, кроме [Раскрытие информации](../../attacks-vulns-list.md#раскрытие-информации-англ-information-exposure), в системе автоматически создается правило, которое отключает анализ таких же запросов на обнаруженные признаки атаки ([токены](../../about-wallarm-waf/protecting-against-attacks.md#библиотека-libproton)).
* При добавлении отметки о ложном срабатывании к инциденту с типом атаки [Раскрытие информации](../../attacks-vulns-list.md#раскрытие-информации-англ-information-exposure), в системе автоматически создается правило, которое отключает анализ ответов на обнаруженные [признаки уязвимости](../../about-wallarm-waf/detecting-vulnerabilities.md#методы-обнаружения-уязвимостей) для таких же запросов.

Созданное правило будет применяться при анализе запросов к защищаемым приложениям. Правило не отображается в Консоли управления Валарм, для удаления или изменения правила необходимо написать в [техническую поддержку Валарм](mailto:support@wallarm.ru).

## Отметка ложного хита

Чтобы отметить отдельный хит как ложное срабатывание:

1. Выберите атаку в секции **События**.
2. Разверните список запросов в атаке.
3. Определите легитимный запрос и нажмите **Ошибка** в столбце **Действия**.

    ![!Ложное срабатывание][img-false-attack]

## Отметка ложной атаки

Чтобы отметить все хиты в атаке как ложное срабатывание:

1. Определите атаку с легитимными запросами в секции **События**.
2. Нажмите **Отметить атаку как ложную**. 

    ![!Ложное срабатывание (атака)](../../images/user-guides/events/analyze-attack.png)

Если все запросы в атаке будут помечены ложными, то информация об атаке будет выглядеть следующим образом:

![!Атака помечена ошибочной][img-removed-atack-info]

## Отмена отметки о ложном срабатывании

Чтобы отменить отметку о ложном срабатывании хита или атаки, пожалуйста, напишите в [техническую поддержку Валарм](mailto:support@wallarm.ru). Также, вы можете отменить действие через диалоговое окно в Консоли управления в течение нескольких секунд после отметки.