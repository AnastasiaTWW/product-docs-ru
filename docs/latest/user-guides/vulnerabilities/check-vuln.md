[link-false-vuln]:      false-vuln.md

[img-check-vuln]:       ../../images/user-guides/vulnerabilities/check-vuln.png
[img-sort-vulns]:       ../../images/user-guides/vulnerabilities/sort-vulns.png
[img-filter-vulns]:     ../../images/user-guides/vulnerabilities/filter-vulns.png
[img-switch-vulns]:     ../../images/user-guides/vulnerabilities/switch-tab-status.png

[glossary-vulnerability]:       ../../glossary-ru.md#уязвимость

# Просмотр уязвимостей

На вкладке *Уязвимости* веб‑интерфейса размещается информация об [уязвимостях][glossary-vulnerability].

По умолчанию все уязвимости разделены на группы по степени риска. В каждой группе список отсортирован по времени обнаружения уязвимости.

![!Просмотр уязвимостей][img-check-vuln]

Валарм хранит историю всех уязвимостей, периодически проверяя состояние каждой, включая закрытые. Если закрытая уязвимость откроется вновь, вы получите уведомление.

Нажатие на уязвимость выводит историю изменений уязвимости.

## Сортировка уязвимостей

Чтобы отсортировать уязвимости, выберите тип сортировки рядом с надписью «Сортировать»: 
*   По риску:
    *   Начиная с высокого;
    *   Начиная с низкого;
*   По дате:
    *   От настоящего времени;
    *   От самой ранней.
    
![!Сортировка уязвимостей][img-sort-vulns]
    
Вы можете отфильтровать уязвимости по степени риска, нажав на одну из следующих кнопок:
*   *Все* — отобразить уязвимости всех степеней риска;
*   *Высокий риск* — отобразить уязвимости с высокой степенью риска;
*   *Средний риск* — отобразить уязвимости со средней степенью риска;
*   *Низкий риск* — отобразить уязвимости с низкой степенью риска.

![!Фильтрация уязвимостей][img-filter-vulns]

## Просмотр активных или закрытых уязвимостей

Нажмите на вкладку *Активные* для просмотра активных уязвимостей.

Нажмите на вкладку *Закрытые* для просмотра закрытых уязвимостей.

![!Вкладки для просмотра уязвимостей][img-switch-vulns]

Закрытые уязвимости можно отфильтровать:

* *Все*&nbsp;— список исправленных уязвимостей и ложных срабатываний;
* *Исправленные*&nbsp;— список только исправленных уязвимостей;
* *Ложные*&nbsp;— список только ложных срабатываний.
