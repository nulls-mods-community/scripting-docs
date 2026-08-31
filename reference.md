# Server

Объект текущего боя. Существует в единственном экземпляре. Является точкой входа в API скриптинга.

### Поля:

| Название          | Тип                                                           | Предназначение                                                                                |
|-------------------|---------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| tick              | number <sup>(readonly)</sup>                                  | Текущий тик сервера. Монотонно увеличивается на 1 каждые 50 миллисекунд.                      |
| playersCount      | number <sup>(readonly)</sup>                                  | Количество игроков в бою.                                                                     |
| locationData      | [LocationData](#locationdata) <sup>(readonly)</sup>           | LocationData текущей локации. Может быть равен <b>nil</b>, если используется кастомная карта. |
| gameMode          | [GameMode](#gamemode) <sup>(readonly)</sup>                   | Текущий игровой режим.                                                                        |
| isBattleEnded     | boolean <sup>(readonly)</sup>                                 | Завершен ли бой?                                                                              |
| hasPoisonDisabled | boolean                                                       | Выключен ли яд игрового режима?                                                               |
| hasIntroSkip      | boolean                                                       | Пропустить ли интро-анимацию?                                                                 |
| objectManager     | [GameObjectManager](#gameobjectmanager) <sup>(readonly)</sup> | …                                                                                             |
| map               | [TileMap](#tilemap) <sup>(readonly)</sup>                     | …                                                                                             |

### Методы:

| Название        | Тип                                         | Предназначение                                                                                                              |
|-----------------|---------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| getClientInfo   | (index: number) ⇒ [ClientInfo](#clientinfo) | Позволяет получить объект ClientInfo по индексу игрока.                                                                     |
| isIntroFinished | () ⇒ boolean                                | Позволяет проверить, завершилась ли интро-анимация боя.                                                                     |
| getRandomInt    | (N: number, M: number) ⇒ number             | Позволяет получить случайное целое число от N до M: [N; M). Использует тот же генератор случайных чисел, что и логика игры. |

# GameObjectManager

Менеджер игровых объектов [LogicGameObject](#logicgameobject). Хранит игровые объекты и управляет их жизненным циклом.

### Методы:

| Название       | Тип                                                  | Предназначение                                     |
|----------------|------------------------------------------------------|----------------------------------------------------|
| getObject      | (id: number) ⇒ [LogicGameObject](#logicgameobject)   | Ищет объект по Object ID.                          |
| addObject      | (object: [LogicGameObject](#logicgameobject)) ⇒ void | Добавляет новый объект на поле боя.                |
| getCharacters  | () ⇒ Iterable                                        | Возвращает список объектов класса LogicCharacter.  |
| getAreaEffects | () ⇒ Iterable                                        | Возвращает список объектов класса LogicAreaEffect. |
| getItems       | () ⇒ Iterable                                        | Возвращает список объектов LogicItem.              |
| getProjectiles | () ⇒ Iterable                                        | Возвращает список объектов LogicProjectile.        |

# ClientInfo

Данные конкретного игрока. Для каждого игрока этот объект создается в единственном экземпляре на весь бой. Имейте в виду, что некоторые поля (например: x, y,
isAlive) обновляются только в конце игрового цикла каждый тик.

### Поля:

| Название            | Тип                           | Предназначение                                                                                                    |
|---------------------|-------------------------------|-------------------------------------------------------------------------------------------------------------------|
| index               | number <sup>(readonly)</sup>  | Индекс этого игрока.                                                                                              |
| team                | number <sup>(readonly)</sup>  | Номер команды игрока. Два игрока одной команды будут иметь одинаковое значение.                                   |
| objectId            | number <sup>(readonly)</sup>  | Object ID текущего LogicCharacter, за которого играет игрок.                                                      |
| x                   | number <sup>(readonly)</sup>  | …                                                                                                                 |
| y                   | number <sup>(readonly)</sup>  | Позиция камеры игрока. В большинстве случаев будет совпадать с позицией LogicCharacter, за которого играет игрок. |
| gamePoints          | number <sup>(readonly)</sup>  | Количество игровых очков. Предназначение зависит от режима.                                                       |
| isAlive             | boolean <sup>(readonly)</sup> | Равен <b>true</b>, если персонаж игрока жив и присутствует на карте.                                              |
| isBot               | boolean <sup>(readonly)</sup> | Показывает, является ли игрок ботом.                                                                              |
| ultiCharge          | number                        | …                                                                                                                 |
| maxUltiCharge       | number <sup>(readonly)</sup>  | …                                                                                                                 |
| overchargeCharge    | number                        | …                                                                                                                 |
| maxOverchargeCharge | number <sup>(readonly)</sup>  | …                                                                                                                 |
| ultiUsesLeft        | number <sup>(readonly)</sup>  | …                                                                                                                 |
| isRespawning        | boolean <sup>(readonly)</sup> | Равен <b>true</b>, если игрок возрождается и вот-вот заспавнится.                                                 |
| emoteUsedIndex      | number <sup>(readonly)</sup>  | …                                                                                                                 |
| emoteUsedTick       | number <sup>(readonly)</sup>  | …                                                                                                                 |
| isOverchargeActive  | boolean <sup>(readonly)</sup> | …                                                                                                                 |

### Методы:

| Название      | Тип                        | Предназначение                                                                                                                                                                             |
|---------------|----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| getSkinData   | () ⇒ [SkinData](#skindata) | Возвращает текущий [SkinData](#skindata) для этого игрока.                                                                                                                                 |
| getAttackTeam | () ⇒ number                | Возвращает эффективный номер команды игрока. Если игрок находится под контролем Виллоу, значение будет равно номеру команды этой Виллоу. В остальных случаях будет равно полю <i>team</i>. |

# LogicGameObject

Абстрактный класс. Игровой объект на поле боя.

### Поля:

| Название  | Тип                                 | Предназначение                                                                                            |
|-----------|-------------------------------------|-----------------------------------------------------------------------------------------------------------|
| id        | number <sup>(readonly)</sup>        | Уникальный Object ID этого объекта.                                                                       |
| data      | [Data](#data) <sup>(readonly)</sup> | …                                                                                                         |
| x         | number <sup>(readonly)</sup>        | …                                                                                                         |
| y         | number <sup>(readonly)</sup>        | …                                                                                                         |
| z         | number <sup>(readonly)</sup>        | …                                                                                                         |
| index     | number <sup>(readonly)</sup>        | Индекс игрока, которому принадлежит объект. Равен <b>-1</b>, если объект никому не принадлежит.           |
| team      | number <sup>(readonly)</sup>        | Номер команды, которой принадлежит объект. Равен <b>-1</b>, если объект нейтрален или враждебен для всех. |
| dimension | number <sup>(readonly)</sup>        | Измерение. Равен <b>1</b>, если объект находится в измерении Корделиуса, и <b>0</b> в остальных случаях.  |

### Методы:

| Название           | Тип                                      | Предназначение                                                                                                                               |
|--------------------|------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| setPosition        | (x: number, y: number, z: number) ⇒ void | Задает координаты объекта. Важно: игровая логика может перезаписать ваши координаты, если объект находится в движении.                       |
| isAlive            | () ⇒ boolean                             | Возвращает <b>false</b>, если объект был уничтожен или убит. В ином случае вернет <b>true</b>.                                               |
| getType            | () ⇒ number                              | Позволяет узнать тип этого объекта: <b>0</b> = LogicCharacter, <b>1</b> = LogicProjectile, <b>2</b> = LogicAreaEffect, <b>3</b> = LogicItem. |
| getSkinData        | () ⇒ [SkinData](#skindata)               | …                                                                                                                                            |
| isOverchargeActive | () ⇒ boolean                             | …                                                                                                                                            |
| setIndex           | (index: number, team: number) ⇒ void     | Позволяет задать игрока-владельца объекта. Рекомендуется вызывать только перед добавлением объекта в GameObjectManager.                      |

# LogicCharacter

Наследуется от [LogicGameObject](#logicgameobject).

Персонаж. Имеет здоровье, может двигаться по заданному пути и атаковать. Самый обширный класс объектов.

### Поля:

| Название               | Тип                                                     | Предназначение                                                                                                                                                                                   |
|------------------------|---------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| angleLegs              | number <sup>(readonly)</sup>                            | Угол направления ног персонажа. По этому значению можно определить направление его движения.                                                                                                     |
| angleHead              | number <sup>(readonly)</sup>                            | Угол направления головы персонажа.                                                                                                                                                               |
| hitPoints              | number <sup>(readonly)</sup>                            | Текущее количество здоровья.                                                                                                                                                                     |
| maxHitPoints           | number <sup>(readonly)</sup>                            | Максимальное количество здоровья.                                                                                                                                                                |
| type                   | [CharacterType](#charactertype) <sup>(readonly)</sup>   | Тип персонажа.                                                                                                                                                                                   |
| isBot                  | boolean <sup>(readonly)</sup>                           | Управляется ли персонаж ботом?                                                                                                                                                                   |
| isStunned              | boolean <sup>(readonly)</sup>                           | Есть ли стан у персонажа?                                                                                                                                                                        |
| persistentSpeedBuff    | number                                                  | …                                                                                                                                                                                                |
| persistentReloadBuff   | number                                                  | …                                                                                                                                                                                                |
| heroUpgradeLevel       | number                                                  | Уровень улучшения персонажа. Считается с нуля. Не все игровые механики используют это поле, поэтому вам также может понадобиться вызвать <i>setUpgradeLevel()</i> у конкретного [Skill](#skill). |
| linkedCharacter        | [LogicCharacter](#logiccharacter) <sup>(readonly)</sup> | Мяч (carryable), который держит персонаж. Если персонаж ничего не держит, то будет равен <b>nil</b>.                                                                                             |
| consShieldValue        | number <sup>(readonly)</sup>                            | Оставшееся здоровье consumable-щита.                                                                                                                                                             |
| takingDamageListeners  | List <sup>(readonly)</sup>                              | Список подписок на событие получения урона. Использует класс DamageEventListener.                                                                                                                |
| dealingDamageListeners | List <sup>(readonly)</sup>                              | Список подписок на событие нанесения урона. Использует класс DamageEventListener.                                                                                                                |
| deathListeners         | List <sup>(readonly)</sup>                              | Список подписок на событие смерти (когда здоровье опускается до нуля). Использует класс BasicEventListener.                                                                                      |
| skillUseListeners      | List <sup>(readonly)</sup>                              | Список подписок на событие использования атаки или супера. Использует класс SkillEventListener.                                                                                                  |

### Методы:

| Название                                    | Тип                                                                                                                                                                                                                                                                                                                                                                                                                | Предназначение                                                                                                                                                                                                                                                                                                                                                                                                                                             |
|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| takeDamage                                  | (srcIndex: number, damage: number, ulti: number, attacker: [LogicCharacter](#logiccharacter), projectile: [LogicProjectile](#logicprojectile), hasIndication: boolean, hasHighlight: boolean, srcX: number, srcY: number, someData: [Data](#data), forceProtected: boolean, origin: [AttackOrigin](#attackorigin), forceAll: boolean, makeVisible: boolean, disallowSpawns: boolean, extraValue: number) ⇒ boolean | Наносит определенный урон игроку.                                                                                                                                                                                                                                                                                                                                                                                                                          |
| takeHeal                                    | (srcIndex: number, damage: number, hasIndication: boolean, someData: [Data](#data), origin: [AttackOrigin](#attackorigin)) ⇒ boolean                                                                                                                                                                                                                                                                               | Лечит определенное количество здоровья игрока.                                                                                                                                                                                                                                                                                                                                                                                                             |
| stopMovement                                | () ⇒ void                                                                                                                                                                                                                                                                                                                                                                                                          | Останавливает движение персонажа.                                                                                                                                                                                                                                                                                                                                                                                                                          |
| moveTo                                      | (x: number, y: number, hasCustomSpeed: boolean, customSpeed: number, isNw: boolean, useTeleports: boolean) ⇒ void                                                                                                                                                                                                                                                                                                  | Строит путь и начинает перемещение к указанной точке. Если hasCustomSpeed = false, то используется скорость персонажа.                                                                                                                                                                                                                                                                                                                                     |
| isPlayerControlRemoved                      | () ⇒ boolean                                                                                                                                                                                                                                                                                                                                                                                                       | Возвращает <b>true</b>, если игрок не может управлять своим персонажем в данный момент.                                                                                                                                                                                                                                                                                                                                                                    |
| getWeaponSkill                              | () ⇒ [Skill](#skill)                                                                                                                                                                                                                                                                                                                                                                                               | Возвращает скилл основной атаки персонажа.                                                                                                                                                                                                                                                                                                                                                                                                                 |
| getUltiSkill                                | () ⇒ [Skill](#skill)                                                                                                                                                                                                                                                                                                                                                                                               | Возвращает скилл супера персонажа.                                                                                                                                                                                                                                                                                                                                                                                                                         |
| getSkill                                    | (data: [SkillData](#skilldata)) ⇒ [Skill](#skill)                                                                                                                                                                                                                                                                                                                                                                  | Возвращает скилл с соответствующим [SkillData](#skilldata), если такой присутствует у персонажа.                                                                                                                                                                                                                                                                                                                                                           |
| useSkill                                    | (data: [SkillData](#skilldata), x: number, y: number, isAutoAim: boolean) ⇒ boolean                                                                                                                                                                                                                                                                                                                                | Использует заданный скилл, если он доступен.                                                                                                                                                                                                                                                                                                                                                                                                               |
| increaseMaxHitPoints                        | (value: number, powerUps: boolean) ⇒ void                                                                                                                                                                                                                                                                                                                                                                          | Увеличивает максимальное количество здоровья у персонажа. Если второй аргумент равен <b>true</b>, то также увеличивает на 1 количество банок в ШД.                                                                                                                                                                                                                                                                                                         |
| teleport                                    | (x: number, y: number, srcAreaEffect: [AreaEffectData](#areaeffectdata), destAreaEffect: [AreaEffectData](#areaeffectdata), damage: number, ultiCharge: number) ⇒ void                                                                                                                                                                                                                                             | Телепортирует персонажа в указанную точку. Можно задать эффекты, которые появятся в исходной точке и точке назначения. Эти эффекты будут использовать заданный урон.                                                                                                                                                                                                                                                                                       |
| spawnCirclingAreaEffect                     | (damageBonus: number, data: [AreaEffectData](#areaeffectdata), origin: [AttackOrigin](#attackorigin), applyOwnerBuffs: boolean, followOwner: boolean) ⇒ [LogicAreaEffect](#logicareaeffect)                                                                                                                                                                                                                        | Создает новый эффект от имени этого персонажа. Конкретно этот метод предполагается для таких механик, как супер Эмз, эффект зарядки ульты Базза или эффект лечения от станции Пэм. В общем, разные долгоживущие эффекты, зачастую привязанные к персонажу.                                                                                                                                                                                                 |
| getPet                                      | (movingOnly: boolean, standingOnly: boolean) ⇒ [LogicCharacter](#logiccharacter)                                                                                                                                                                                                                                                                                                                                   | Позволяет получить первого питомца этого персонажа, если таковой присутствует. Иначе вернет <b>nil</b>.                                                                                                                                                                                                                                                                                                                                                    |
| blockHealthRegen                            | () ⇒ void                                                                                                                                                                                                                                                                                                                                                                                                          | Сбрасывает таймер восстановления здоровья.                                                                                                                                                                                                                                                                                                                                                                                                                 |
| addStatusEffect                             | (data: [StatusEffectData](#statuseffectdata), srcIndex: number, srcTeam: number, origin: [AttackOrigin](#attackorigin), attacker: [LogicCharacter](#logiccharacter)) ⇒ [StatusEffect](#statuseffect)                                                                                                                                                                                                               | Накладывает статус-эффект персонажу. Конкретное поведение эффекта определяется его StatusEffectData. Аргументы srcIndex, srcTeam, attacker позволяют определить от лица какого персонажа (и игрока) будет происходить действие (например, нанесение урона), если это применимо к этому эффекту. Может вернуть <b>nil</b>, если (1) эффект не может быть наложен, либо (2) если такой эффект уже наложен, при этом Stackable = FALSE и Refreshable = FALSE. |
| addStatusEffectSelf                         | (data: [StatusEffectData](#statuseffectdata), origin: [AttackOrigin](#attackorigin)) ⇒ [StatusEffect](#statuseffect)                                                                                                                                                                                                                                                                                               | Аналогично <i>addStatusEffect()</i>. Действие будет происходить от лица персонажа, на которого накладывается статус эффект.                                                                                                                                                                                                                                                                                                                                |
| setInvisibility <sup>[[1]](#01def85e)</sup> | (ticks: number, distanceToSee: number) ⇒ void                                                                                                                                                                                                                                                                                                                                                                      | Выдает классическую невидимость, как у супера Леона. Позволяет задать длительность и дистанцию, на которой персонаж становится принудительно видимым.                                                                                                                                                                                                                                                                                                      |
| setConsumableShield                         | (value: number, ticks: number) ⇒ void                                                                                                                                                                                                                                                                                                                                                                              | Выдает consumable-щит. Позволяет указать его количество здоровья (value) и длительность (ticks).                                                                                                                                                                                                                                                                                                                                                           |
| gainShield <sup>[[1]](#01def85e)</sup>      | (ticks: number, value: number) ⇒ void                                                                                                                                                                                                                                                                                                                                                                              | Выдает классический щит. Позволяет указать процент защиты (value) и длительность (ticks).                                                                                                                                                                                                                                                                                                                                                                  |
| setStun <sup>[[1]](#01def85e)</sup>         | (ticks: number, skipImmunity: boolean, isSleepy: boolean, isCrossing: boolean) ⇒ boolean                                                                                                                                                                                                                                                                                                                           | Накладывает классический эффект стана. Позволяет указать длительность (ticks) и подтип (isSleepy, isCrossing).                                                                                                                                                                                                                                                                                                                                             |

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

| Название        | Тип                      | Предназначение                                                                                                                                       |
|-----------------|--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| setUpgradeLevel | (level: number) ⇒ void   | Выставляет уровень улучшения этого скилла. Считается с нуля. Влияет на урон и другие параметры его атаки.                                            |
| getMaxCharge    | () ⇒ number              | Максимальное значение для патронов. Актуально только для основной атаки. Одна единица равна 1/1000 патрона.                                          |
| charge          | (percent: number) ⇒ void | Позволяет добавить или убавить текущие патроны. Актуально только для основной атаки. Аргумент выражается в 1/100 патрона и может быть отрицательным. |
| isWeaponSkill   | () ⇒ boolean             | Возвращает <b>true</b>, если это основная атака.                                                                                                     |
| isUltiSkill     | () ⇒ boolean             | Возвращает <b>true</b>, если это супер.                                                                                                              |

# StatusEffect

…

### Поля:

| Название   | Тип                                                         | Предназначение                                                                                  |
|------------|-------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| data       | [StatusEffectData](#statuseffectdata) <sup>(readonly)</sup> | …                                                                                               |
| ticksTotal | number <sup>(readonly)</sup>                                | Общее количество тиков, в течение которых действует этот статус-эффект.                         |
| ticksLeft  | number <sup>(readonly)</sup>                                | Оставшееся количество тиков, в течение которых действует этот статус-эффект. Монотонно убывает. |

### Методы:

| Название | Тип       | Предназначение                            |
|----------|-----------|-------------------------------------------|
| cancel   | () ⇒ void | Прекращает действие этого статус-эффекта. |

# LogicProjectile

Наследуется от [LogicGameObject](#logicgameobject).

Снаряд. Летит по заданной траектории, может наносить урон персонажам и не только.

### Поля:

| Название      | Тип                                                     | Предназначение                                                                                                                                                                                                                                                   |
|---------------|---------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| finishState   | number <sup>(readonly)</sup>                            | Изначально равен нулю. При завершении движения выставляется положительное значение: <b>1</b> — достигнута предельная дистанция, <b>2</b> — попадание в границу карты, <b>3</b> — попадание в персонажа, <b>4</b> — попадание в блок, <b>5</b> — уничтожен извне. |
| shotCharacter | [LogicCharacter](#logiccharacter) <sup>(readonly)</sup> | Изначально равен <b>nil</b>, но если попадание произошло в персонажа, то этот персонаж будет записан в это поле.                                                                                                                                                 |
| origin        | [AttackOrigin](#attackorigin) <sup>(readonly)</sup>     | …                                                                                                                                                                                                                                                                |

### Методы:

| Название       | Тип                          | Предназначение |
|----------------|------------------------------|----------------|
| setFinishState | (finishState: number) ⇒ void | …              |

# LogicAreaEffect

Наследуется от [LogicGameObject](#logicgameobject).

Зона с эффектом. Действует на персонажей (и некоторые снаряды), механика зависит от конкретного эффекта.

### Поля:

| Название | Тип                                                 | Предназначение |
|----------|-----------------------------------------------------|----------------|
| origin   | [AttackOrigin](#attackorigin) <sup>(readonly)</sup> | …              |

### Методы:

| Название | Тип       | Предназначение                     |
|----------|-----------|------------------------------------|
| destroy  | () ⇒ void | Уничтожает этот эффект немедленно. |

# LogicItem

Наследуется от [LogicGameObject](#logicgameobject).

Предмет. В большинстве случаев его можно поднять или активировать.

### Поля:

| Название | Тип                                                 | Предназначение |
|----------|-----------------------------------------------------|----------------|
| origin   | [AttackOrigin](#attackorigin) <sup>(readonly)</sup> | …              |

### Методы:

| Название | Тип       | Предназначение                      |
|----------|-----------|-------------------------------------|
| destroy  | () ⇒ void | Уничтожает этот предмет немедленно. |

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
| destructTile   | (x: number, y: number, isBasicWeapon: boolean) ⇒ void                                                         | Уничтожает блок на заданной клетке.                                                                      |
| setDynamicTile | (data: [TileData](#tiledata), x: number, y: number, ownerCharacter: [LogicCharacter](#logiccharacter)) ⇒ void | Выставляет динамический блок на заданной клетке. Данный блок должен иметь DynamicCode != 0.              |
| getTile        | (x: number, y: number) ⇒ [Tile](#tile)                                                                        | Возвращает тайл по тайловым (клеточным) координатам. Возвращает <b>nil</b>, если задана точка вне карты. |

# Tile

Конкретная клетка на карте.

### Поля:

| Название     | Тип                                         | Предназначение                                                                                |
|--------------|---------------------------------------------|-----------------------------------------------------------------------------------------------|
| data         | [TileData](#tiledata) <sup>(readonly)</sup> | Текущий [TileData](#data) этой клетки.                                                        |
| dataOriginal | [TileData](#tiledata) <sup>(readonly)</sup> | Оригинальный [TileData](#data) этой клетки. Загружается один раз и не меняется в течение боя. |
| x            | number <sup>(readonly)</sup>                | …                                                                                             |
| y            | number <sup>(readonly)</sup>                | …                                                                                             |

### Методы:

| Название  | Тип          | Предназначение                                                    |
|-----------|--------------|-------------------------------------------------------------------|
| isDynamic | () ⇒ boolean | Возвращает <b>true</b>, если этот тайл был выставлен динамически. |

# AttackOrigin

Является перечислением.

…

# CharacterType

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

# TileData

Наследуется от [Data](#data).

Хранит табличные данные для каждого тайла из <i>tiles.csv</i>.

# SkillData

Наследуется от [Data](#data).

Хранит табличные данные для каждого скилла из <i>skills.csv</i>.

# CharacterData

Наследуется от [Data](#data).

Хранит табличные данные для каждого персонажа из <i>characters.csv</i>.

# ItemData

Наследуется от [Data](#data).

Хранит табличные данные для каждого предмета из <i>items.csv</i>.

# ProjectileData

Наследуется от [Data](#data).

Хранит табличные данные для каждого снаряда из <i>projectiles_skin.csv</i> и <i>projectiles_logic.csv</i>.

# AreaEffectData

Наследуется от [Data](#data).

Хранит табличные данные для каждого скилла из <i>area_effects_skin.csv</i> и <i>area_effects_logic.csv</i>.

# LocationData

Наследуется от [Data](#data).

Хранит табличные данные для каждой локации из <i>locations.csv</i>.

# SkinData

Наследуется от [Data](#data).

Хранит табличные данные для каждого скина из <i>skins.csv</i>.

# StatusEffectData

Наследуется от [Data](#data).

Хранит табличные данные для каждого эффекта из <i>status_effects_skin.csv</i> и <i>status_effects_logic.csv</i>.

# ArrayList

Список.

### Методы:

| Название | Тип                | Предназначение                                                                         |
|----------|--------------------|----------------------------------------------------------------------------------------|
| get      | (number) ⇒ Object  | Получает объект из списка по индексу. Нумерация начинается с <b>нуля</b>.              |
| add      | (Object) ⇒ boolean | Добавляет объект в список.                                                             |
| size     | () ⇒ number        | Позволяет получить размер списка.                                                      |
| indexOf  | (Object) ⇒ number  | Позволяет получить индекс объекта в списке. Равен <b>-1</b>, если не объект не найден. |

