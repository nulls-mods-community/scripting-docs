# Server

Объект текущего боя. Существует в единственном экземпляре. Является точкой входа в API скриптинга.

### Поля:

| Название          | Тип                                                           | Предназначение                                                                                                 |
|-------------------|---------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|
| tick              | number <sup>(readonly)</sup>                                  | Текущий тик сервера. Монотонно увеличивается на 1 каждые 50 миллисекунд.                                       |
| playersCount      | number <sup>(readonly)</sup>                                  | Количество игроков в бою.                                                                                      |
| locationData      | [LocationData](#locationdata)? <sup>(readonly)</sup>          | [LocationData](#locationdata) текущей локации. Может быть равен <b>nil</b>, если используется кастомная карта. |
| gameMode          | [GameMode](#gamemode) <sup>(readonly)</sup>                   | Текущий игровой режим.                                                                                         |
| isBattleEnded     | boolean <sup>(readonly)</sup>                                 | Завершен ли бой?                                                                                               |
| hasPoisonDisabled | boolean                                                       | Выключен ли яд игрового режима?                                                                                |
| hasIntroSkip      | boolean                                                       | Пропустить ли интро-анимацию?                                                                                  |
| objectManager     | [GameObjectManager](#gameobjectmanager) <sup>(readonly)</sup> | …                                                                                                              |
| map               | [TileMap](#tilemap) <sup>(readonly)</sup>                     | …                                                                                                              |

### Методы:

| Название          | Тип                                          | Предназначение                                                                                                              |
|-------------------|----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| getClientInfo     | (index: number) ⇒ [ClientInfo](#clientinfo)? | Позволяет получить объект [ClientInfo](#clientinfo) по индексу игрока.                                                      |
| isIntroFinished   | () ⇒ boolean                                 | Позволяет проверить, завершилась ли интро-анимация боя.                                                                     |
| getRandomInt      | (N: number, M: number) ⇒ number              | Позволяет получить случайное целое число от N до M: [N; M). Использует тот же генератор случайных чисел, что и логика игры. |
| debugFinishBattle | (team: number) ⇒ ()                          | Принудительно завершает бой, задавая команду-победителя.                                                                    |

# GameObjectManager

Менеджер игровых объектов [LogicGameObject](#logicgameobject). Хранит игровые объекты и управляет их жизненным циклом.

### Методы:

| Название       | Тип                                                             | Предназначение                                                         |
|----------------|-----------------------------------------------------------------|------------------------------------------------------------------------|
| getObject      | (id: number) ⇒ [LogicGameObject](#logicgameobject)?             | Ищет объект по Object ID.                                              |
| addObject      | (object: [LogicGameObject](#logicgameobject)?) ⇒ ()             | Добавляет новый объект на поле боя.                                    |
| getCharacters  | () ⇒ [Iterable](#iterable)<[LogicCharacter](#logiccharacter)>   | Возвращает список объектов класса [LogicCharacter](#logiccharacter).   |
| getAreaEffects | () ⇒ [Iterable](#iterable)<[LogicAreaEffect](#logicareaeffect)> | Возвращает список объектов класса [LogicAreaEffect](#logicareaeffect). |
| getItems       | () ⇒ [Iterable](#iterable)<[LogicItem](#logicitem)>             | Возвращает список объектов [LogicItem](#logicitem).                    |
| getProjectiles | () ⇒ [Iterable](#iterable)<[LogicProjectile](#logicprojectile)> | Возвращает список объектов [LogicProjectile](#logicprojectile).        |

# ClientInfo

Данные конкретного игрока. Для каждого игрока этот объект создается в единственном экземпляре на весь бой. Имейте в виду, что некоторые поля (например: x, y,
isAlive) обновляются только в конце игрового цикла каждый тик.

### Поля:

| Название            | Тип                                            | Предназначение                                                                                                                       |
|---------------------|------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| index               | number <sup>(readonly)</sup>                   | Индекс этого игрока.                                                                                                                 |
| team                | number <sup>(readonly)</sup>                   | Номер команды игрока. Два игрока одной команды будут иметь одинаковое значение.                                                      |
| objectId            | number <sup>(readonly)</sup>                   | Object ID текущего [LogicCharacter](#logiccharacter), за которого играет игрок.                                                      |
| x                   | number <sup>(readonly)</sup>                   | …                                                                                                                                    |
| y                   | number <sup>(readonly)</sup>                   | Позиция камеры игрока. В большинстве случаев будет совпадать с позицией [LogicCharacter](#logiccharacter), за которого играет игрок. |
| gamePoints          | number                                         | Количество игровых очков. Предназначение зависит от режима.                                                                          |
| isAlive             | boolean <sup>(readonly)</sup>                  | Равен <b>true</b>, если персонаж игрока жив и присутствует на карте.                                                                 |
| isBot               | boolean <sup>(readonly)</sup>                  | Показывает, является ли игрок ботом.                                                                                                 |
| ultiCharge          | number                                         | …                                                                                                                                    |
| maxUltiCharge       | number <sup>(readonly)</sup>                   | …                                                                                                                                    |
| overchargeCharge    | number                                         | …                                                                                                                                    |
| maxOverchargeCharge | number <sup>(readonly)</sup>                   | …                                                                                                                                    |
| ultiUsesLeft        | number <sup>(readonly)</sup>                   | …                                                                                                                                    |
| isRespawning        | boolean <sup>(readonly)</sup>                  | Равен <b>true</b>, если игрок возрождается и вот-вот заспавнится.                                                                    |
| emoteUsedIndex      | number <sup>(readonly)</sup>                   | …                                                                                                                                    |
| emoteUsedTick       | number <sup>(readonly)</sup>                   | …                                                                                                                                    |
| isOverchargeActive  | boolean <sup>(readonly)</sup>                  | …                                                                                                                                    |
| accessory           | [Accessory](#accessory)? <sup>(readonly)</sup> | …                                                                                                                                    |

### Методы:

| Название      | Тип                         | Предназначение                                                                                                                                                                             |
|---------------|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| getSkinData   | () ⇒ [SkinData](#skindata)? | Возвращает текущий [SkinData](#skindata) для этого игрока.                                                                                                                                 |
| getAttackTeam | () ⇒ number                 | Возвращает эффективный номер команды игрока. Если игрок находится под контролем Виллоу, значение будет равно номеру команды этой Виллоу. В остальных случаях будет равно полю <i>team</i>. |

# LogicGameObject

Абстрактный класс. Игровой объект на поле боя.

### Поля:

| Название  | Тип                                                     | Предназначение                                                                                            |
|-----------|---------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| id        | number <sup>(readonly)</sup>                            | Уникальный Object ID этого объекта.                                                                       |
| data      | [GameObjectData](#gameobjectdata) <sup>(readonly)</sup> | …                                                                                                         |
| x         | number <sup>(readonly)</sup>                            | …                                                                                                         |
| y         | number <sup>(readonly)</sup>                            | …                                                                                                         |
| z         | number <sup>(readonly)</sup>                            | …                                                                                                         |
| index     | number <sup>(readonly)</sup>                            | Индекс игрока, которому принадлежит объект. Равен <b>-1</b>, если объект никому не принадлежит.           |
| team      | number <sup>(readonly)</sup>                            | Номер команды, которой принадлежит объект. Равен <b>-1</b>, если объект нейтрален или враждебен для всех. |
| dimension | number <sup>(readonly)</sup>                            | Измерение. Равен <b>1</b>, если объект находится в измерении Корделиуса, и <b>0</b> в остальных случаях.  |
| traits    | [Traits](#traits) <sup>(readonly)</sup>                 | …                                                                                                         |

### Методы:

| Название           | Тип                                    | Предназначение                                                                                                                                                                                                        |
|--------------------|----------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| setPosition        | (x: number, y: number, z: number) ⇒ () | Задает координаты объекта. Важно: игровая логика может перезаписать ваши координаты, если объект находится в движении.                                                                                                |
| isAlive            | () ⇒ boolean                           | Возвращает <b>false</b>, если объект был уничтожен или убит. В ином случае вернет <b>true</b>.                                                                                                                        |
| getType            | () ⇒ number                            | Позволяет узнать тип этого объекта: <b>0</b> = [LogicCharacter](#logiccharacter), <b>1</b> = [LogicProjectile](#logicprojectile), <b>2</b> = [LogicAreaEffect](#logicareaeffect), <b>3</b> = [LogicItem](#logicitem). |
| getSkinData        | () ⇒ [SkinData](#skindata)?            | …                                                                                                                                                                                                                     |
| isOverchargeActive | () ⇒ boolean                           | …                                                                                                                                                                                                                     |
| setIndex           | (index: number, team: number) ⇒ ()     | Позволяет задать игрока-владельца объекта. Рекомендуется вызывать только перед добавлением объекта в [GameObjectManager](#gameobjectmanager).                                                                         |

# Traits

Менеджер особых способностей (traits) конкретного игрового объекта. Новые объекты наследуют способности от родительских объектов.

### Методы:

| Название     | Тип                                                        | Предназначение                                                                                                             |
|--------------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| add          | (data: [TraitData](#traitdata)?) ⇒ ()                      | Добавляет конкретную способность.                                                                                          |
| remove       | (data: [TraitData](#traitdata)?) ⇒ boolean                 | Удаляет конкретную способность.                                                                                            |
| getComponent | (type: [TraitType](#traittype)) ⇒ [TraitData](#traitdata)? | Позволяет получить конкретную способность по её типу. Возвращает <b>nil</b>, если способности с таким типом у объекта нет. |

# LogicCharacter

Наследуется от [LogicGameObject](#logicgameobject).

Персонаж. Имеет здоровье, может двигаться по заданному пути и атаковать. Самый обширный класс объектов.

### Поля:

| Название                 | Тип                                                                              | Предназначение                                                                                                                                                                                   |
|--------------------------|----------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| angleLegs                | number <sup>(readonly)</sup>                                                     | Угол направления ног персонажа. По этому значению можно определить направление его движения.                                                                                                     |
| angleHead                | number <sup>(readonly)</sup>                                                     | Угол направления головы персонажа.                                                                                                                                                               |
| hitPoints                | number <sup>(readonly)</sup>                                                     | Текущее количество здоровья.                                                                                                                                                                     |
| maxHitPoints             | number <sup>(readonly)</sup>                                                     | Максимальное количество здоровья.                                                                                                                                                                |
| type                     | [CharacterType](#charactertype) <sup>(readonly)</sup>                            | Тип персонажа.                                                                                                                                                                                   |
| isBot                    | boolean <sup>(readonly)</sup>                                                    | Управляется ли персонаж ботом?                                                                                                                                                                   |
| isStunned                | boolean <sup>(readonly)</sup>                                                    | Есть ли стан у персонажа?                                                                                                                                                                        |
| persistentSpeedBuff      | number                                                                           | …                                                                                                                                                                                                |
| persistentReloadBuff     | number                                                                           | …                                                                                                                                                                                                |
| heroUpgradeLevel         | number                                                                           | Уровень улучшения персонажа. Считается с нуля. Не все игровые механики используют это поле, поэтому вам также может понадобиться вызвать <i>setUpgradeLevel()</i> у конкретного [Skill](#skill). |
| gamePoints               | number                                                                           | Количество игровых очков текущего персонажа. Предназначение зависит от режима и может отличаться от одноименного поля в [ClientInfo](#clientinfo).                                               |
| powerPoints              | number                                                                           | Количество очков усиления из ШД. Используется для отображения на клиенте и при выпадании предметов при смерти. Не влияет на урон или ХП персонажа.                                               |
| linkedCharacter          | [LogicCharacter](#logiccharacter)? <sup>(readonly)</sup>                         | Мяч (carryable), который держит персонаж. Если персонаж ничего не держит, то будет равен <b>nil</b>.                                                                                             |
| lastDamageSourceIndex    | number <sup>(readonly)</sup>                                                     | Индекс игрока, который в последний раз наносил урон этому персонажу.                                                                                                                             |
| hasRespawnShield         | boolean <sup>(readonly)</sup>                                                    | …                                                                                                                                                                                                |
| consShieldValue          | number <sup>(readonly)</sup>                                                     | Оставшееся здоровье consumable-щита.                                                                                                                                                             |
| takingDamageListeners    | [List](#list)<[DamageEventListener](#damageeventlistener)> <sup>(readonly)</sup> | Список подписок на событие получения урона.                                                                                                                                                      |
| dealingDamageListeners   | [List](#list)<[DamageEventListener](#damageeventlistener)> <sup>(readonly)</sup> | Список подписок на событие нанесения урона.                                                                                                                                                      |
| deathListeners           | [List](#list)<[SourceListener](#sourcelistener)> <sup>(readonly)</sup>           | Список подписок на событие смерти (когда здоровье опускается до нуля).                                                                                                                           |
| skillUseListeners        | [List](#list)<[SkillEventListener](#skilleventlistener)> <sup>(readonly)</sup>   | Список подписок на событие использования атаки или супера.                                                                                                                                       |
| startOverchargeListeners | [List](#list)<[BasicListener](#basiclistener)> <sup>(readonly)</sup>             | Список подписок на событие использования гиперзаряда.                                                                                                                                            |

### Методы:

| Название                                    | Тип                                                                                                                                                                                                                                                                                                                                                                                                                   | Предназначение                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
|---------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| takeDamage                                  | (srcIndex: number, damage: number, ulti: number, attacker: [LogicCharacter](#logiccharacter)?, projectile: [LogicProjectile](#logicprojectile)?, hasIndication: boolean, hasHighlight: boolean, srcX: number, srcY: number, someData: [Data](#data)?, forceProtected: boolean, origin: [AttackOrigin](#attackorigin), forceAll: boolean, makeVisible: boolean, disallowSpawns: boolean, extraValue: number) ⇒ boolean | Наносит определенный урон игроку.                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| takeHeal                                    | (srcIndex: number, damage: number, hasIndication: boolean, someData: [Data](#data)?, origin: [AttackOrigin](#attackorigin)) ⇒ boolean                                                                                                                                                                                                                                                                                 | Лечит определенное количество здоровья игрока.                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| stopMovement                                | () ⇒ ()                                                                                                                                                                                                                                                                                                                                                                                                               | Останавливает движение персонажа.                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| moveTo                                      | (x: number, y: number, hasCustomSpeed: boolean, customSpeed: number, isNw: boolean, useTeleports: boolean) ⇒ ()                                                                                                                                                                                                                                                                                                       | Строит путь и начинает перемещение к указанной точке. Если hasCustomSpeed = false, то используется скорость персонажа.                                                                                                                                                                                                                                                                                                                                                          |
| isPlayerControlRemoved                      | () ⇒ boolean                                                                                                                                                                                                                                                                                                                                                                                                          | Возвращает <b>true</b>, если игрок не может управлять своим персонажем в данный момент.                                                                                                                                                                                                                                                                                                                                                                                         |
| getWeaponSkill                              | () ⇒ [Skill](#skill)?                                                                                                                                                                                                                                                                                                                                                                                                 | Возвращает скилл основной атаки персонажа.                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| getUltiSkill                                | () ⇒ [Skill](#skill)?                                                                                                                                                                                                                                                                                                                                                                                                 | Возвращает скилл супера персонажа.                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| getSkill                                    | (data: [SkillData](#skilldata)?) ⇒ [Skill](#skill)?                                                                                                                                                                                                                                                                                                                                                                   | Возвращает скилл с соответствующим [SkillData](#skilldata), если такой присутствует у персонажа.                                                                                                                                                                                                                                                                                                                                                                                |
| useSkill                                    | (data: [SkillData](#skilldata)?, x: number, y: number, isAutoAim: boolean) ⇒ boolean                                                                                                                                                                                                                                                                                                                                  | Использует заданный скилл, если он доступен.                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| increaseMaxHitPoints                        | (value: number, powerUps: boolean) ⇒ ()                                                                                                                                                                                                                                                                                                                                                                               | Увеличивает максимальное количество здоровья у персонажа. Если второй аргумент равен <b>true</b>, то также увеличивает на 1 количество банок в ШД.                                                                                                                                                                                                                                                                                                                              |
| teleport                                    | (x: number, y: number, srcAreaEffect: [AreaEffectData](#areaeffectdata)?, destAreaEffect: [AreaEffectData](#areaeffectdata)?, damage: number, ultiCharge: number) ⇒ ()                                                                                                                                                                                                                                                | Телепортирует персонажа в указанную точку. Можно задать эффекты, которые появятся в исходной точке и точке назначения. Эти эффекты будут использовать заданный урон.                                                                                                                                                                                                                                                                                                            |
| spawnCirclingAreaEffect                     | (damageBonus: number, data: [AreaEffectData](#areaeffectdata)?, origin: [AttackOrigin](#attackorigin), applyOwnerBuffs: boolean, followOwner: boolean) ⇒ [LogicAreaEffect](#logicareaeffect)?                                                                                                                                                                                                                         | Создает новый эффект от имени этого персонажа. Конкретно этот метод предполагается для таких механик, как супер Эмз, эффект зарядки ульты Базза или эффект лечения от станции Пэм. В общем, разные долгоживущие эффекты, зачастую привязанные к персонажу.                                                                                                                                                                                                                      |
| getPet                                      | (movingOnly: boolean, standingOnly: boolean) ⇒ [LogicCharacter](#logiccharacter)?                                                                                                                                                                                                                                                                                                                                     | Позволяет получить первого питомца этого персонажа, если таковой присутствует. Иначе вернет <b>nil</b>.                                                                                                                                                                                                                                                                                                                                                                         |
| blockHealthRegen                            | () ⇒ ()                                                                                                                                                                                                                                                                                                                                                                                                               | Сбрасывает таймер восстановления здоровья.                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| addStatusEffect                             | (data: [StatusEffectData](#statuseffectdata)?, srcIndex: number, srcTeam: number, origin: [AttackOrigin](#attackorigin), attacker: [LogicCharacter](#logiccharacter)?) ⇒ [StatusEffect](#statuseffect)?                                                                                                                                                                                                               | Накладывает статус-эффект персонажу. Конкретное поведение эффекта определяется его [StatusEffectData](#statuseffectdata). Аргументы srcIndex, srcTeam, attacker позволяют определить от лица какого персонажа (и игрока) будет происходить действие (например, нанесение урона), если это применимо к этому эффекту. Может вернуть <b>nil</b>, если (1) эффект не может быть наложен, либо (2) если такой эффект уже наложен, при этом Stackable = FALSE и Refreshable = FALSE. |
| addStatusEffectSelf                         | (data: [StatusEffectData](#statuseffectdata)?, origin: [AttackOrigin](#attackorigin)) ⇒ [StatusEffect](#statuseffect)?                                                                                                                                                                                                                                                                                                | Аналогично <i>addStatusEffect()</i>. Действие будет происходить от лица персонажа, на которого накладывается статус эффект.                                                                                                                                                                                                                                                                                                                                                     |
| setInvisibility <sup>[[1]](#01def85e)</sup> | (ticks: number, distanceToSee: number) ⇒ ()                                                                                                                                                                                                                                                                                                                                                                           | Выдает классическую невидимость, как у супера Леона. Позволяет задать длительность и дистанцию, на которой персонаж становится принудительно видимым.                                                                                                                                                                                                                                                                                                                           |
| setConsumableShield                         | (value: number, ticks: number) ⇒ ()                                                                                                                                                                                                                                                                                                                                                                                   | Выдает consumable-щит. Позволяет указать его количество здоровья (value) и длительность (ticks).                                                                                                                                                                                                                                                                                                                                                                                |
| gainShield <sup>[[1]](#01def85e)</sup>      | (ticks: number, value: number) ⇒ ()                                                                                                                                                                                                                                                                                                                                                                                   | Выдает классический щит. Позволяет указать процент защиты (value) и длительность (ticks).                                                                                                                                                                                                                                                                                                                                                                                       |
| setStun <sup>[[1]](#01def85e)</sup>         | (ticks: number, skipImmunity: boolean, isSleepy: boolean, isCrossing: boolean) ⇒ boolean                                                                                                                                                                                                                                                                                                                              | Накладывает классический эффект стана. Позволяет указать длительность (ticks) и подтип (isSleepy, isCrossing).                                                                                                                                                                                                                                                                                                                                                                  |
| push                                        | (pushX: number, pushY: number, strength: number, canFly: boolean, a7: boolean, a8: boolean, a9: boolean, skipCCImmunity: boolean, a11: boolean, a12: boolean, a13: boolean, useFixedDistance: boolean, stunTicks: number, speedModifier: number) ⇒ ()                                                                                                                                                                 | Отталкивает персонажа от указанной точки. Сила (strength) определяет расстояние отталкивания.                                                                                                                                                                                                                                                                                                                                                                                   |

<span id="01def85e"><sup>[1]</sup> По возможности рекомендуется использовать статус-эффекты вместо этого метода.</span>

# Skill

…

### Поля:

| Название        | Тип                                           | Предназначение                                                                                                                                            |
|-----------------|-----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| data            | [SkillData](#skilldata) <sup>(readonly)</sup> | …                                                                                                                                                         |
| activeTicksLeft | number <sup>(readonly)</sup>                  | Количество тиков, через которое скилл перейдет из активного в неактивное состояние. Монотонно убывает. Если скилл не в активном состоянии, то равен нулю. |
| chargeValue     | number <sup>(readonly)</sup>                  | Текущие патроны. Актуально только для основной атаки. Одна единица равна 1/1000 патрона.                                                                  |

### Методы:

| Название        | Тип                    | Предназначение                                                                                                                                       |
|-----------------|------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| setUpgradeLevel | (level: number) ⇒ ()   | Выставляет уровень улучшения этого скилла. Считается с нуля. Влияет на урон и другие параметры его атаки.                                            |
| getMaxCharge    | () ⇒ number            | Максимальное значение для патронов. Актуально только для основной атаки. Одна единица равна 1/1000 патрона.                                          |
| charge          | (percent: number) ⇒ () | Позволяет добавить или убавить текущие патроны. Актуально только для основной атаки. Аргумент выражается в 1/100 патрона и может быть отрицательным. |
| isWeaponSkill   | () ⇒ boolean           | Возвращает <b>true</b>, если это основная атака.                                                                                                     |
| isUltiSkill     | () ⇒ boolean           | Возвращает <b>true</b>, если это супер.                                                                                                              |

# StatusEffect

…

### Поля:

| Название    | Тип                                                         | Предназначение                                                                                  |
|-------------|-------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| data        | [StatusEffectData](#statuseffectdata) <sup>(readonly)</sup> | …                                                                                               |
| ticksTotal  | number <sup>(readonly)</sup>                                | Общее количество тиков, в течение которых действует этот статус-эффект.                         |
| ticksLeft   | number <sup>(readonly)</sup>                                | Оставшееся количество тиков, в течение которых действует этот статус-эффект. Монотонно убывает. |
| damageBase  | number                                                      | Базовое значение периодического урона без учета баффов и уровня.                                |
| healingBase | number                                                      | Базовое значение периодического исцеления без учета баффов и уровня.                            |

### Методы:

| Название | Тип                 | Предназначение                                                       |
|----------|---------------------|----------------------------------------------------------------------|
| cancel   | () ⇒ ()             | Прекращает действие статус-эффекта.                                  |
| addTicks | (arg0: number) ⇒ () | Продлевает действие статус-эффекта на указанное количество тиков.    |
| isActive | () ⇒ boolean        | Позволяет узнать, активен ли статус-эффект в текущий момент времени. |

# LogicProjectile

Наследуется от [LogicGameObject](#logicgameobject).

Снаряд. Летит по заданной траектории, может наносить урон персонажам и не только.

### Поля:

| Название      | Тип                                                      | Предназначение                                                                                                                                                                                                                                                   |
|---------------|----------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| finishState   | number <sup>(readonly)</sup>                             | Изначально равен нулю. При завершении движения выставляется положительное значение: <b>1</b> — достигнута предельная дистанция, <b>2</b> — попадание в границу карты, <b>3</b> — попадание в персонажа, <b>4</b> — попадание в блок, <b>5</b> — уничтожен извне. |
| shotCharacter | [LogicCharacter](#logiccharacter)? <sup>(readonly)</sup> | Изначально равен <b>nil</b>, но если попадание произошло в персонажа, то этот персонаж будет записан в это поле.                                                                                                                                                 |
| origin        | [AttackOrigin](#attackorigin) <sup>(readonly)</sup>      | …                                                                                                                                                                                                                                                                |

### Методы:

| Название       | Тип                        | Предназначение |
|----------------|----------------------------|----------------|
| setFinishState | (finishState: number) ⇒ () | …              |

# LogicAreaEffect

Наследуется от [LogicGameObject](#logicgameobject).

Зона с эффектом. Действует на персонажей (и некоторые снаряды), механика зависит от конкретного эффекта.

### Поля:

| Название       | Тип                                                      | Предназначение                                                                   |
|----------------|----------------------------------------------------------|----------------------------------------------------------------------------------|
| ownerCharacter | [LogicCharacter](#logiccharacter)? <sup>(readonly)</sup> | …                                                                                |
| origin         | [AttackOrigin](#attackorigin) <sup>(readonly)</sup>      | …                                                                                |
| damage         | number                                                   | Урон, который будет наносить этот эффект персонажам в зоне действия.             |
| ultiEnergy     | number                                                   | Количество супера, которое будет заряжаться у игрока при каждом нанесения урона. |

### Методы:

| Название       | Тип                                                                                                                           | Предназначение                                                                                                           |
|----------------|-------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| setSource      | (index: number, team: number, ownerCharacter: [LogicCharacter](#logiccharacter)?, origin: [AttackOrigin](#attackorigin)) ⇒ () | …                                                                                                                        |
| isObjectInside | (object: [LogicGameObject](#logicgameobject)?) ⇒ boolean                                                                      | Проверяет, находится ли игровой объект внутри зоны действия эффекта.                                                     |
| destroy        | () ⇒ ()                                                                                                                       | Уничтожает этот эффект немедленно.                                                                                       |
| trigger        | () ⇒ ()                                                                                                                       | Начинает действие этого эффекта. Необходимо вызвать один раз после добавления в [GameObjectManager](#gameobjectmanager). |

# LogicItem

Наследуется от [LogicGameObject](#logicgameobject).

Предмет. В большинстве случаев его можно поднять или активировать.

### Поля:

| Название           | Тип                                                      | Предназначение                                                                     |
|--------------------|----------------------------------------------------------|------------------------------------------------------------------------------------|
| isTriggered        | boolean <sup>(readonly)</sup>                            | …                                                                                  |
| triggeredCharacter | [LogicCharacter](#logiccharacter)? <sup>(readonly)</sup> | …                                                                                  |
| ownerCharacter     | [LogicCharacter](#logiccharacter)? <sup>(readonly)</sup> | …                                                                                  |
| origin             | [AttackOrigin](#attackorigin) <sup>(readonly)</sup>      | …                                                                                  |
| sprayDataIndex     | number                                                   | Если предмет является спреем (Spray), тогда указывает на индекс конкретного спрея. |

### Методы:

| Название  | Тип                                                                                                                           | Предназначение                      |
|-----------|-------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| setSource | (index: number, team: number, ownerCharacter: [LogicCharacter](#logiccharacter)?, origin: [AttackOrigin](#attackorigin)) ⇒ () | …                                   |
| destroy   | () ⇒ ()                                                                                                                       | Уничтожает этот предмет немедленно. |

# Accessory

…

### Поля:

| Название | Тип                                                   | Предназначение |
|----------|-------------------------------------------------------|----------------|
| data     | [AccessoryData](#accessorydata) <sup>(readonly)</sup> | …              |
| isActive | boolean <sup>(readonly)</sup>                         | …              |

# TileMap

Карта боя, содержит тайловую сетку и позволяет работать с ней.

### Поля:

| Название  | Тип                          | Предназначение           |
|-----------|------------------------------|--------------------------|
| tileSizeX | number <sup>(readonly)</sup> | Ширина карты в клетках.  |
| tileSizeY | number <sup>(readonly)</sup> | Высота карты в клетках.  |
| absSizeX  | number <sup>(readonly)</sup> | Абсолютная ширина карты. |
| absSizeY  | number <sup>(readonly)</sup> | Абсолютная высота карты. |

### Методы:

| Название       | Тип                                                                                                           | Предназначение                                                                                           |
|----------------|---------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| destructTile   | (x: number, y: number, isBasicWeapon: boolean) ⇒ ()                                                           | Уничтожает блок на заданной клетке.                                                                      |
| setDynamicTile | (data: [TileData](#tiledata)?, x: number, y: number, ownerCharacter: [LogicCharacter](#logiccharacter)?) ⇒ () | Выставляет динамический блок на заданной клетке. Данный блок должен иметь DynamicCode != 0.              |
| getTile        | (x: number, y: number) ⇒ [Tile](#tile)?                                                                       | Возвращает тайл по тайловым (клеточным) координатам. Возвращает <b>nil</b>, если задана точка вне карты. |

# Tile

Конкретная клетка на карте.

### Поля:

| Название     | Тип                                          | Предназначение                                                                                    |
|--------------|----------------------------------------------|---------------------------------------------------------------------------------------------------|
| data         | [TileData](#tiledata) <sup>(readonly)</sup>  | Текущий [TileData](#tiledata) этой клетки.                                                        |
| dataOriginal | [TileData](#tiledata)? <sup>(readonly)</sup> | Оригинальный [TileData](#tiledata) этой клетки. Загружается один раз и не меняется в течение боя. |
| x            | number <sup>(readonly)</sup>                 | …                                                                                                 |
| y            | number <sup>(readonly)</sup>                 | …                                                                                                 |

### Методы:

| Название        | Тип          | Предназначение                                                    |
|-----------------|--------------|-------------------------------------------------------------------|
| isDynamic       | () ⇒ boolean | Возвращает <b>true</b>, если этот тайл был выставлен динамически. |
| restoreOriginal | () ⇒ ()      | Восстанавливает изначальное состояние тайла с момента начала боя. |

# AttackOrigin

Является перечислением.

…

# CharacterType

Является перечислением.

…

# TraitType

Является перечислением.

…

# GameMode

Является перечислением.

…

# Data

Абстрактный класс. Хранит табличные данные (.csv) для какого-то конкретного объекта. Например, Wall1 из <i>tiles.csv</i> будет описываться своим
объектом [TileData](#tiledata).

### Методы:

| Название    | Тип         | Предназначение                                                                                                     |
|-------------|-------------|--------------------------------------------------------------------------------------------------------------------|
| getIndex    | () ⇒ number | Возвращает свой индекс в таблице.                                                                                  |
| getType     | () ⇒ number | Возвращает тип (числовой) своей таблицы. Для объектов внутри одной таблицы всегда будет одинаковым.                |
| getGlobalId | () ⇒ number | Возвращает свой уникальный ID. Фактически считается так: <code>(this.getType() * 1000000) + this.getIndex()</code> |
| getName     | () ⇒ string | …                                                                                                                  |

# GameObjectData

Наследуется от [Data](#data).

Абстрактный класс.

# ProjectileData

Наследуется от [GameObjectData](#gameobjectdata).

Хранит табличные данные для каждого снаряда из <i>projectiles_skin.csv</i> и <i>projectiles_logic.csv</i>.

# CharacterData

Наследуется от [GameObjectData](#gameobjectdata).

Хранит табличные данные для каждого персонажа из <i>characters.csv</i>.

# ItemData

Наследуется от [GameObjectData](#gameobjectdata).

Хранит табличные данные для каждого предмета из <i>items.csv</i>.

# AreaEffectData

Наследуется от [GameObjectData](#gameobjectdata).

Хранит табличные данные для каждого скилла из <i>area_effects_skin.csv</i> и <i>area_effects_logic.csv</i>.

# TileData

Наследуется от [Data](#data).

Хранит табличные данные для каждого тайла из <i>tiles.csv</i>.

# SkillData

Наследуется от [Data](#data).

Хранит табличные данные для каждого скилла из <i>skills.csv</i>.

# LocationData

Наследуется от [Data](#data).

Хранит табличные данные для каждой локации из <i>locations.csv</i>.

# SkinData

Наследуется от [Data](#data).

Хранит табличные данные для каждого скина из <i>skins.csv</i>.

# StatusEffectData

Наследуется от [Data](#data).

Хранит табличные данные для каждого эффекта из <i>status_effects_skin.csv</i> и <i>status_effects_logic.csv</i>.

# AccessoryData

Наследуется от [Data](#data).

Хранит табличные данные для каждого гаджета из <i>accessories.csv</i>.

# TraitData

Наследуется от [Data](#data).

Хранит табличные данные для каждой способности из <i>traits.csv</i>.

# DamageEventListener

Интерфейс. Представляет лямбда-функцию.

# SkillEventListener

Интерфейс. Представляет лямбда-функцию.

# SourceListener

Интерфейс. Представляет лямбда-функцию.

# BasicListener

Интерфейс. Представляет лямбда-функцию.

# Iterable

Абстрактный класс.

# List

Наследуется от [Iterable](#iterable).

Абстрактный класс.

### Методы:

| Название | Тип                      | Предназначение                                                                         |
|----------|--------------------------|----------------------------------------------------------------------------------------|
| get      | (index: number) ⇒ any    | Получает объект из списка по индексу. Нумерация начинается с <b>нуля</b>.              |
| add      | (element: any) ⇒ boolean | Добавляет объект в список.                                                             |
| size     | () ⇒ number              | Позволяет получить размер списка.                                                      |
| indexOf  | (element: any) ⇒ number  | Позволяет получить индекс объекта в списке. Равен <b>-1</b>, если не объект не найден. |

# ArrayList

Наследуется от [List](#list).

Список.

