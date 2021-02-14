# AmazingCats
## Задача
Нужно написать приложение-просмотрщик картинок. Заходим в приложение, видим бесконечную ленту-галерею картинок (каждый элемент - сама картинка + мета-информация к ней в любом виде). При клике по картинке открываем картинку подробно, цель этого экрана - показать картинку в полном размере. Также на экране картинки подробно надо показать дату ее скачивания.
- Язык приложения: Swift
- Минимальная версия iOS - 11
- Источник картинок - любое публичное АПИ
- Необходимо реализовать оффлайн-режим: приложение должно сохранять максимальную функциональность без сети (либо в случае нестабильной сети)
- Архитектура приложения - на выбор разработчика
- Использование сторонних решений приветствуется при необходимости, в этом случае нужно обоснование каждого из них (почему используется именно это решение)
- Цель приложения: минимальным количеством кода и сложности добиться качественной реализации поставленной задачи
- Непринципиальные вопросы решаются на усмотрение разработчика (с обоснованием решения, почему так), принципиальные - уточняются по почте (при их возникновении) 

## Решение

 #### -Language: Swift
 #### -Network: URLSession
 #### -Offline handle: Persistent cache
 #### -Public API - [thecatapi](https://thecatapi.com/)
 #### -Supported platforms: iOS 11.0+
 #### -Supported devices: iPhone, iPad
 #### -Architecture: MVC
