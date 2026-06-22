# Deep XPNT Reward Distribution and Tokenomics Spec (обновлено: 2026-05-31)

## Цель

Зафиксировать в одном документе, как **сейчас** в Deep работает распределение наград и подписочная tokenomics-модель XPNT.

Документ предназначен для:

- маркетинга;
- BD и партнерских материалов;
- продуктовых описаний;
- внутренних FAQ и go-to-market коммуникации.

## Scope

Этот документ описывает только **текущую реализованную** economic-модель для:

- XPNT-подписок;
- reward stream;
- treasury reserve;
- ops budget escrow;
- связанных inflow-механик в reward pool.

Этот документ **не** фиксирует:

- окончательную публичную цену подписки;
- total supply narrative как маркетинговое обещание;
- vesting/migration/listing policy;
- будущие governance-изменения;
- будущие username/alias monetization rules.

## Executive Summary

Текущая implemented-модель Deep устроена так:

1. Подписки оплачиваются в XPNT.
2. Каждая подписка делится по правилу `40 / 20 / 40`.
3. `40%` сразу направляется в reward stream.
4. `20%` уходит в permanent treasury reserve.
5. `40%` уходит в monthly ops budget escrow.
6. Если ops budget не выбран вовремя, его остаток автоматически возвращается в rewards.

Практический вывод:

- rewards гарантированно получают минимум `40%` от каждой подписки;
- rewards могут получить до `80%`, если ops budget за период не выбран полностью;
- permanent reserve всегда сохраняет `20%` каждой подписки.

## Core Economic Principles

Текущая XPNT-модель для подписок строится на четырех принципах:

1. **Reward-first design**: подписки напрямую подпитывают reward stream.
2. **Permanent reserve**: часть дохода всегда накапливается в постоянном treasury reserve и не сгорает.
3. **Use-it-or-return-it ops budget**: операционный бюджет выдается по epoch-модели и не зависает навсегда.
4. **Gradual reward emission**: rewards попадают не в рынок одномоментно, а выпускаются постепенно через reward pool.

## Subscription Revenue Split

### Базовое распределение

Каждая покупка подписки делится так:

| Поток | Доля | Назначение |
|---|---:|---|
| Rewards | `40%` | Сразу депонируется в reward stream |
| Permanent treasury reserve | `20%` | Уходит в постоянный treasury reserve |
| Monthly ops budget escrow | `40%` | Уходит в ops escrow текущего периода |

### Простое объяснение

Если пользователь покупает подписку на `100 XPNT`, то на старте деньги распределяются так:

- `40 XPNT` -> rewards
- `20 XPNT` -> permanent reserve
- `40 XPNT` -> ops escrow

Если за этот период ops-команда использовала только `10 XPNT` из escrow, то остаток `30 XPNT` после дедлайна возвращается в rewards.

Итоговая фактическая картина для этой покупки будет:

- `70 XPNT` -> rewards
- `20 XPNT` -> permanent reserve
- `10 XPNT` -> ops

## Reward Stream Mechanics

### Как rewards попадают в систему

Rewards получают XPNT из двух источников:

1. из подписок через `SubscriptionManager`;
2. из невыбранного ops budget через `OpsBudgetEscrow`.

Дополнительно reward pool может получать и другие inflow-поступления, если они маршрутизированы через `deposit(...)`.

### Не мгновенная раздача

XPNT, направленные в rewards, **не раздаются мгновенно**. Они сначала попадают в `RewardRatePool`, а затем постепенно выпускаются бенефициару reward-системы.

Это значит:

- подписка создает reward backing сразу;
- фактическая выдача reward-токенов в систему происходит постепенно;
- reward stream имеет сглаженную, а не импульсную форму.

### Current reward release model

Текущий reward pool считает выплату **от фактического текущего остатка пула**, а не фиксированно от первоначального депозита.

В коде используется simple annual payout coefficient `15.1%`, который пропорционально времени применяется к текущему балансу на момент расчета.

Это означает следующее:

- если в пул положили `40 млн XPNT`, первая серия выплат считается от этих `40 млн`;
- если позже в пуле осталось `30 млн XPNT`, следующие выплаты считаются уже от `30 млн`;
- по мере уменьшения баланса абсолютный размер выплат тоже уменьшается.

Формулировка про примерно `14%` effective annual outflow означает не “всегда `14%` от первого депозита”, а “при регулярной реализации выплат годовой отток на убывающем балансе оказывается примерно эквивалентен `14%` от баланса на начало такого периода”.

Маркетингово это лучше формулировать так:

- rewards выпускаются **постепенно и предсказуемо**;
- reward pool рассчитан на **долгосрочную streaming-модель**, а не на разовую эмиссию.

### Reward pool safety note

Текущая реализация уже включает cap на выплату текущим балансом пула, чтобы pool не зависал после долгого простоя.

Для маркетинга это не является user-facing claim и обычно не должно выноситься в публичные материалы.

## Permanent Treasury Reserve

### Что это такое

Permanent treasury reserve получает `20%` каждой подписки.

### Его свойства

1. Этот поток не участвует в expire/sweep механике.
2. Эти средства не возвращаются автоматически в rewards.
3. Это долгосрочный финансовый buffer для экосистемы.

### Как это лучше описывать

Маркетингово reserve можно описывать как:

- постоянный treasury layer;
- устойчивый long-term reserve;
- базовый резерв для развития, операций и resilience.

## Monthly Ops Budget Escrow

### Что это такое

`40%` каждой подписки направляется в ops escrow текущей monthly epoch.

### Как это работает

1. Деньги текущего периода аккумулируются в escrow.
2. Назначенный ops claimer может выбрать их только после закрытия периода.
3. Выборка возможна лишь в течение ограниченного claim window.
4. После истечения окна любой может инициировать возврат невыбранного остатка в rewards.

### Economic effect

Эта модель делает ops budget:

- реальным и usable;
- ограниченным по времени;
- некапсулирующимся навсегда вне reward economy.

### Marketing takeaway

Это можно описывать так:

- у протокола есть **реальный операционный бюджет**;
- если он не используется, value **возвращается сообществу через rewards**.

## Effective Reward Share Range

### Минимум

Rewards всегда получают минимум `40%` от подписки.

### Максимум

Если ops budget не выбран вообще, rewards в конечном счете получают:

- исходные `40%` subscription rewards;
- плюс весь `40%` ops escrow,

то есть суммарно `80%` подписочного платежа.

### Формула

Фактический reward share для одной подписки находится в диапазоне:

`40%` -> `80%`

в зависимости от того, какая часть ops escrow была реально использована.

Permanent reserve при этом всегда остается `20%`.

## Subscription Pricing Model

### Что важно сейчас

Цена подписки **не является hardcoded protocol constant**.

Она задается через subscription plan configuration и может изменяться governance/admin flow без апгрейда логики.

### Что это означает для маркетинга

1. Нельзя называть цену “навсегда зашитой в контракте”.
2. Публичные pricing materials должны ссылаться на **актуальный утвержденный plan catalog**.
3. Контракт задает economic split, но не фиксирует навсегда public list price.

### Current implementation facts

Текущая implementation поддерживает:

- plan-based pricing;
- duration per plan;
- active/inactive plans;
- ограничение количества периодов за одну покупку.

## Payment Rails

### Supported model

Текущая экономическая модель совместима с двумя payment rails:

1. `on-chain` payment в XPNT;
2. `off-chain` payment с последующим settlement.

### Economic invariant

Независимо от payment rail, целевая economic logic должна оставаться одинаковой:

- один и тот же subscription entitlement;
- один и тот же `40 / 20 / 40` split;
- один и тот же reward/reserve/ops behavior.

### Marketing takeaway

Это позволяет говорить о:

- единой tokenomics-модели;
- мультиканальной оплате;
- consistent economics независимо от способа покупки.

## Privacy and Identity Angle

### Что реализовано сейчас

Подписочный on-chain flow не публикует raw Session ID в контракте.

Вместо этого используется blinded `bytes32` recipient alias с off-chain signature grant.

### Что это означает

1. Подписку можно покупать giftable-способом.
2. Raw Session ID не пишется on-chain.
3. Платежная логика отделена от публичного account identifier.

### Marketing caution

Это лучше описывать как:

- privacy-aware purchase flow;
- no raw Session ID in on-chain subscription records.

Не стоит обещать абсолютную анонимность или unlinkability без отдельного privacy review и product approval.

## Additional Reward Inflows

Помимо подписок, reward pool может получать дополнительные inflows из других protocol flows, если они маршрутизируются через `deposit(...)`.

В текущем reference stack к таким inflow относится pool-share от liquidation path в `ServiceNodeRewards`.

Для маркетинга это не обязательный публичный месседж, но внутри команды полезно помнить:

- reward stream подпитывается не только subscription revenue;
- subscriptions являются самым понятным и прямым user-facing reward source.

## Current Reference Deployment Defaults

В текущих deployment scripts есть reference defaults, которые полезны как инженерный ориентир, но не должны автоматически становиться публичным маркетинговым обещанием.

Такие значения включают:

- token symbol: `XPNT`;
- reference token supply default в shared deploy script;
- initial reward pool funding default;
- reference monthly plan setup через env-config.

Если marketing materials хотят использовать конкретные числа supply, pool funding или public price, они должны подтверждаться отдельным launch decision и governance sign-off.

## What Marketing Can Safely Say

Ниже формулировки, которые соответствуют текущей implemented-модели:

1. Подписки в XPNT напрямую подпитывают reward economy Deep.
2. Базовое распределение подписочного платежа: `40%` в rewards, `20%` в permanent reserve, `40%` в time-limited ops budget.
3. Неиспользованный ops budget автоматически возвращается в rewards.
4. Это дает rewards минимум `40%` и до `80%` subscription revenue в зависимости от использования ops budget.
5. Reward emissions идут постепенно через dedicated reward stream, а не выбрасываются в рынок единым куском.
6. Deep сочетает growth funding, sustainable reserve и community reward alignment в одной модели.
7. Подписочный on-chain flow не публикует raw Session ID.

## What Marketing Should Not Say

Без отдельного утверждения не стоит публиковать такие утверждения:

1. фиксированная и навсегда неизменная цена подписки;
2. гарантированная доходность пользователя или валидатора;
3. обещание конкретного APY как маркетингового обязательства;
4. утверждение, что `80%` подписок всегда идут в rewards;
5. утверждение, что система полностью on-chain или полностью off-chain;
6. утверждение об абсолютной анонимности.

## Recommended Public Positioning

Рекомендуемое короткое описание модели:

> Deep routes XPNT subscription revenue into a three-part economic model: a live community reward stream, a permanent ecosystem reserve, and a time-limited operational budget whose unused portion flows back into rewards. This creates a system where every subscription supports both long-term sustainability and community-aligned incentives.

Рекомендуемое более прикладное описание:

> Every XPNT subscription feeds the Deep economy. A fixed share supports the reward stream, a fixed share strengthens the permanent treasury reserve, and the remaining share funds monthly operations on a use-it-or-return-it basis. If operations do not use the full monthly allocation, the leftover value returns to rewards.

## Open Items for Future Marketing Versions

Эта spec может быть расширена позже, когда будут отдельно утверждены:

1. public pricing table;
2. final supply narrative;
3. staking/liquidation communication policy;
4. alias monetization policy;
5. versioned tokenomics one-pager для сайта и инвесторских материалов.