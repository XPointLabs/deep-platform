# Deep Session Alias Spec (обновлено: 2026-05-31)

## Цель

Добавить в Deep человекочитаемые alias-ы для Session ID в стиле original Session ONS, но в продуктовой модели, подходящей для мессенджера и premium-монетизации.

Alias должен:

- позволять пользователю делиться коротким идентификатором вместо длинного Session ID;
- быть удобным для поиска, добавления контакта и упоминаний;
- не требовать публикации raw Session ID в блокчейне;
- поддерживать premium-модель для коротких имен;
- быть совместимым с текущей моделью on-chain/off-chain оплаты.

## Ключевое решение

Для Deep alias-ы являются **off-chain canonical registry** с возможностью оплаты как `off-chain`, так и `on-chain`.

Это отличается от original Session ONS в одном важном пункте:

- original Session использовал on-chain ONS alias -> Session ID mapping;
- Deep использует Session-style alias format, но хранит entitlement и ownership в backend registry.

Причина:

- лучше UX;
- проще renewal и возврат имен в пул;
- проще reserved names, anti-abuse и dispute resolution;
- нет жесткой публичной связки alias -> wallet.

## Термины

- `Session ID`: основной идентификатор аккаунта в сети Deep.
- `Alias`: человекочитаемое уникальное имя аккаунта.
- `Canonical alias`: alias без префикса `@`, в нижнем регистре.
- `Display alias`: alias в UI-форме с префиксом `@`.
- `Lease`: срок владения alias-ом.
- `Primary alias`: единственный активный alias аккаунта в v1.

## Формат alias

### Каноническая форма

В storage и API alias хранится **без** префикса `@`.

Примеры:

- `alice`
- `deep`
- `bob_42`
- `team_ops`

### Отображаемая форма

В UI alias показывается с префиксом `@`.

Примеры:

- `@alice`
- `@deep`
- `@bob_42`

### Разрешенные символы

Разрешены только ASCII-символы:

- `a-z`
- `0-9`
- `_`
- `-`

Unicode, пробелы, emoji, точки и другие символы не допускаются.

### Нормализация

Перед валидацией alias приводится к canonical form:

1. удаляется ведущий `@`, если он есть;
2. строка trim-ится по краям;
3. строка приводится к lowercase ASCII.

Примеры нормализации:

- `@Alice` -> `alice`
- ` Deep-Session ` -> `deep`
- `@BOB_42` -> `bob_42`

### Ограничения синтаксиса

Alias должен удовлетворять всем условиям:

1. длина от `3` до `32` символов;
2. первый символ: `a-z` или `0-9`;
3. последний символ: `a-z` или `0-9`;
4. символы внутри: `a-z`, `0-9`, `_`, `-`;
5. нельзя использовать подряд разделители:
   `--`, `__`, `-_`, `_-` запрещены;
6. alias не может состоять только из цифр.

### Регулярное выражение v1

Базовое regex-правило:

```text
^[a-z0-9](?:[a-z0-9]|[_-](?=[a-z0-9])){1,30}[a-z0-9]$
```

Дополнительная бизнес-валидация:

- строка не должна быть all-numeric;
- строка не должна попадать в reserved list.

## Семантика длины

Хотя original Session ONS допускал длинные `session` names, Deep v1 сознательно ограничивает alias до `32` символов.

Причины:

- лучше UX для ввода и упоминаний;
- проще визуальная проверка;
- меньше сквоттинга длинных форм;
- ближе к ожиданиям пользователей от username-модели.

### Length tiers

- `3-4` символа: premium aliases;
- `5-32` символа: standard aliases;
- `1-2` символа: не выдаются в v1, зарезервированы под будущий premium/auction rollout.

## Ownership-модель

### Общие правила

1. alias глобально уникален;
2. сравнение alias-ов case-insensitive;
3. один аккаунт может иметь только один `primary alias` в v1;
4. один alias может принадлежать только одному аккаунту одновременно.

### Привязка

Registry хранит:

- `alias`
- `sessionId`
- `ownerAccountId` или эквивалентную внутреннюю ссылку
- `leaseStartUtc`
- `leaseEndUtc`
- `status`
- `tier`

### Статусы

- `active`
- `grace`
- `quarantine`
- `released`
- `reserved`
- `blocked`

## Lease и lifecycle

### Базовая модель

Alias не продается навсегда. Он выдается как renewable lease.

### Сроки v1

- базовый lease: `365` дней;
- grace period после expiry: `30` дней;
- quarantine после явного release или истечения grace: `30` дней.

### Правила жизненного цикла

1. Пользователь регистрирует alias.
2. Alias получает статус `active` до `leaseEndUtc`.
3. После expiry alias переходит в `grace`.
4. В `grace` текущий владелец еще может продлить alias.
5. После `grace` alias переходит в `quarantine`.
6. В `quarantine` alias не может быть зарегистрирован новым владельцем.
7. После `quarantine` alias возвращается в свободный пул.

### Смена alias

При смене primary alias:

1. новый alias активируется сразу;
2. старый alias уходит в `quarantine`;
3. мгновенное перевыдавание старого alias другому аккаунту не допускается.

Это снижает impersonation-риск после rename.

## Pricing policy

### v1 tiers

- standard (`5-32`): фиксированная цена;
- premium (`3-4`): повышенная фиксированная цена;
- ultra-short (`1-2`): не продаются в v1.

### Payment rails

Поддерживаются оба канала оплаты:

1. `off-chain`: карта, app store, web checkout, бот, OTC;
2. `on-chain`: XPNT payment.

### Settlement

Независимо от канала оплаты canonical entitlement выдается backend registry.

Если оплата идет on-chain:

1. пользователь платит XPNT;
2. backend подтверждает settlement;
3. backend активирует или продлевает alias lease.

Таким образом alias не становится on-chain asset.

## Reserved names

### Категории reserved names

1. системные:
   `admin`, `support`, `help`, `system`, `security`, `settings`, `all`, `everyone`, `here`;
2. брендовые:
   `deep`, `session`, `oxen`, `telegram`, `signal`, `whatsapp`;
3. инфраструктурные:
   `api`, `cdn`, `push`, `router`, `registry`, `wallet`, `billing`;
4. локализованные варианты критических брендов и support-ролей;
5. известные impersonation-risk names.

### Правила reserved names

- reserved names нельзя зарегистрировать через публичный flow;
- reserved names могут быть назначены только вручную через admin flow;
- список reserved names versioned и хранится отдельно от runtime-кода.

## Anti-abuse и security rules

### Обязательные правила v1

1. ASCII-only aliases;
2. no confusable Unicode;
3. no all-numeric aliases;
4. quarantine после release/expiry;
5. rate limit на проверки доступности и регистрации;
6. audit log для create/renew/release/reassign/admin override.

### Рекомендуемые дополнительные правила

1. deny-list по брендам и phishing-шаблонам;
2. manual review для части premium aliases;
3. отдельные лимиты на массовые регистрации;
4. risk scoring для suspicious signup/payment patterns.

## Resolve-модель

### Ввод пользователя

Клиент должен принимать:

- raw Session ID;
- canonical alias;
- display alias c `@`.

### Resolve flow

1. Пользователь вводит `alice` или `@alice`.
2. Клиент нормализует ввод до `alice`.
3. Backend resolve endpoint возвращает Session ID и metadata alias-а.
4. Клиент открывает чат или карточку контакта по Session ID.

### Resolve contract

Минимальный ответ resolve API:

- `alias`
- `displayAlias`
- `sessionId`
- `status`
- `expiresAtUtc`

Если alias не найден или неактивен, клиент получает typed error без раскрытия лишних внутренних данных.

## UX-правила

### Отображение

- в профиле показывается `@alias`;
- в deep links и internal mentions используется display form;
- в backend, DB и API-идентификаторах используется canonical form.

### Проверка доступности

UI должен показывать 3 состояния:

- `available`
- `unavailable`
- `reserved`

Опционально:

- `premium`
- `comingSoon` для `1-2` символов.

### Mention parsing

Парсер упоминаний должен поддерживать `@alias`, где alias соответствует canonical syntax.

## Backend API v1

### Resolve

- `GET /api/aliases/{alias}`

### Availability check

- `POST /api/aliases/check`

Request:

- `alias`

Response:

- `normalizedAlias`
- `availability`
- `tier`
- `price`

### Register

- `POST /api/aliases/register`

Request:

- `alias`
- `sessionId`
- `paymentReference`
- `paymentChannel`

### Renew

- `POST /api/aliases/renew`

### Release

- `POST /api/aliases/release`

## Admin API v1

Только для privileged flows:

- reserve alias;
- unblock alias;
- reassign alias;
- extend lease manually;
- force release alias.

Все admin-операции должны логироваться в audit trail.

## Privacy considerations

1. Alias считается публичным идентификатором аккаунта.
2. Alias не должен публиковаться on-chain как ownership record в v1.
3. On-chain payment не должен автоматически раскрывать `alias -> wallet` mapping.
4. Resolve API должен возвращать только минимум, необходимый для открытия чата и UX.

## Совместимость с on-chain subscription stack

Alias registry не должен зависеть от on-chain `recipientAlias` из subscription contracts.

Это разные сущности:

- `recipientAlias` в контрактах: `bytes32` subscription subject key для on-chain entitlement lookup;
- `session alias` в мессенджере: публичный human-readable username.

Для режима, где ноды должны независимо проверять подписку без центрального entitlement service, в v1 фиксируется следующая договоренность:

- `recipientAlias` детерминированно вычисляется из Session ID;
- рекомендуемая форма: `keccak256("deep-subscription-v1" || normalizedSessionIdBytes)`;
- `normalizedSessionIdBytes` означает каноническое бинарное представление Session ID аккаунта, включая стандартный `05` prefix.

Что это дает:

1. Любая нода может по одному и тому же алгоритму вычислить `recipientAlias` и проверить `activeUntil` / `isActive` в контракте.
2. Raw Session ID не публикуется on-chain в явном виде.
3. Это дает псевдонимизацию, а не полную приватность: любой, кто уже знает конкретный Session ID, сможет вычислить тот же hash и проверить наличие подписки.

Следствие для архитектуры:

1. Human-readable alias registry остается отдельной продуктовой сущностью.
2. Username ownership и resolve API не должны смешиваться с on-chain subscription subject.
3. Для on-chain subscription checks отдельный backend registry не требуется.

## Решения v1

Зафиксировать в v1:

1. canonical alias без `@`;
2. display alias с `@`;
3. ASCII lowercase slug;
4. длина `3-32`;
5. `3-4` premium, `5-32` standard, `1-2` reserved for future;
6. one primary alias per account;
7. off-chain canonical registry;
8. renewable lease вместо perpetual ownership;
9. on-chain payment разрешен только как payment rail, не как ownership layer.

## Open questions

1. Нужен ли secondary alias set в v2.
2. Нужен ли public alias directory/search index.
3. Нужна ли auction-модель для `1-2` символов.
4. Нужен ли Merkle/audit anchoring snapshot on-chain.
5. Нужна ли transferable alias ownership-модель в отдельном premium продукте.