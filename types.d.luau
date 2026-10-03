export type Iterable<T> = {
    [number]: T,
    get: (self: Iterable<T>, index: number) -> T,
    add: (self: Iterable<T>, object: T) -> boolean,
    size: (self: Iterable<T>) -> number,
    indexOf: (self: Iterable<T>, object: T) -> number
}

declare extern type Server with
    --- Текущий тик сервера. Монотонно увеличивается на 1 каждые 50 миллисекунд.
    tick: number
    --- Количество игроков в бою.
    playersCount: number
    --- LocationData текущей локации. Может быть равен #nil, если используется кастомная карта.
    locationData: LocationData?
    --- Текущий игровой режим.
    gameMode: GameMode
    --- Завершен ли бой?
    isBattleEnded: boolean
    --- Выключен ли яд игрового режима?
    hasPoisonDisabled: boolean
    --- Пропустить ли интро-анимацию?
    hasIntroSkip: boolean
    --- …
    objectManager: GameObjectManager
    --- …
    map: TileMap
    --- Позволяет получить объект ClientInfo по индексу игрока.
    function getClientInfo(self, index: number): ClientInfo?
    --- Позволяет проверить, завершилась ли интро-анимация боя.
    function isIntroFinished(self): boolean
    --- Позволяет получить случайное целое число от N до M: [N; M). Использует тот же генератор случайных чисел, что и логика игры.
    function getRandomInt(self, N: number, M: number): number
    --- Принудительно завершает бой, задавая команду-победителя.
    function debugFinishBattle(self, team: number): ()
end

declare extern type GameObjectManager with
    --- Ищет объект по Object ID.
    function getObject(self, id: number): LogicGameObject?
    --- Добавляет новый объект на поле боя.
    function addObject(self, object: LogicGameObject?): ()
    --- Возвращает список объектов класса LogicCharacter.
    function getCharacters(self): Iterable<LogicCharacter>
    --- Возвращает список объектов класса LogicAreaEffect.
    function getAreaEffects(self): Iterable<LogicAreaEffect>
    --- Возвращает список объектов LogicItem.
    function getItems(self): Iterable<LogicItem>
    --- Возвращает список объектов LogicProjectile.
    function getProjectiles(self): Iterable<LogicProjectile>
end

declare extern type ClientInfo with
    --- Индекс этого игрока.
    index: number
    --- Номер команды игрока. Два игрока одной команды будут иметь одинаковое значение.
    team: number
    --- Object ID текущего LogicCharacter, за которого играет игрок.
    objectId: number
    --- …
    x: number
    --- Позиция камеры игрока. В большинстве случаев будет совпадать с позицией LogicCharacter, за которого играет игрок.
    y: number
    --- Количество игровых очков. Предназначение зависит от режима.
    gamePoints: number
    --- Равен #true, если персонаж игрока жив и присутствует на карте.
    isAlive: boolean
    --- Показывает, является ли игрок ботом.
    isBot: boolean
    --- …
    ultiCharge: number
    --- …
    maxUltiCharge: number
    --- …
    overchargeCharge: number
    --- …
    maxOverchargeCharge: number
    --- …
    ultiUsesLeft: number
    --- Равен #true, если игрок возрождается и вот-вот заспавнится.
    isRespawning: boolean
    --- …
    emoteUsedIndex: number
    --- …
    emoteUsedTick: number
    --- …
    isOverchargeActive: boolean
    --- …
    accessory: Accessory?
    --- Возвращает текущий SkinData для этого игрока.
    function getSkinData(self): SkinData?
    --- Возвращает эффективный номер команды игрока. Если игрок находится под контролем Виллоу, значение будет равно номеру команды этой Виллоу. В остальных случаях будет равно полю <i>team</i>.
    function getAttackTeam(self): number
end

declare extern type LogicGameObject with
    --- Уникальный Object ID этого объекта.
    id: number
    --- …
    data: GameObjectData
    --- …
    x: number
    --- …
    y: number
    --- …
    z: number
    --- Индекс игрока, которому принадлежит объект. Равен #-1, если объект никому не принадлежит.
    index: number
    --- Номер команды, которой принадлежит объект. Равен #-1, если объект нейтрален или враждебен для всех.
    team: number
    --- Измерение. Равен #1, если объект находится в измерении Корделиуса, и #0 в остальных случаях.
    dimension: number
    --- …
    traits: Traits
    --- Задает координаты объекта. Важно: игровая логика может перезаписать ваши координаты, если объект находится в движении.
    function setPosition(self, x: number, y: number, z: number): ()
    --- Возвращает #false, если объект был уничтожен или убит. В ином случае вернет #true.
    function isAlive(self): boolean
    --- Позволяет узнать тип этого объекта: #0 = LogicCharacter, #1 = LogicProjectile, #2 = LogicAreaEffect, #3 = LogicItem.
    function getType(self): number
    --- …
    function getSkinData(self): SkinData?
    --- …
    function isOverchargeActive(self): boolean
    --- Позволяет задать игрока-владельца объекта. Рекомендуется вызывать только перед добавлением объекта в GameObjectManager.
    function setIndex(self, index: number, team: number): ()
end

declare extern type Traits with
    --- Добавляет конкретную способность.
    function add(self, data: TraitData?): ()
    --- Удаляет конкретную способность.
    function remove(self, data: TraitData?): boolean
    --- Позволяет получить конкретную способность по её типу. Возвращает #nil, если способности с таким типом у объекта нет.
    function getComponent(self, type: TraitType): TraitData?
end

declare extern type LogicCharacter extends LogicGameObject with
    --- Угол направления ног персонажа. По этому значению можно определить направление его движения.
    angleLegs: number
    --- Угол направления головы персонажа.
    angleHead: number
    --- Текущее количество здоровья.
    hitPoints: number
    --- Максимальное количество здоровья.
    maxHitPoints: number
    --- Тип персонажа.
    type: CharacterType
    --- Управляется ли персонаж ботом?
    isBot: boolean
    --- Есть ли стан у персонажа?
    isStunned: boolean
    --- …
    persistentSpeedBuff: number
    --- …
    persistentReloadBuff: number
    --- Уровень улучшения персонажа. Считается с нуля. Не все игровые механики используют это поле, поэтому вам также может понадобиться вызвать <i>setUpgradeLevel()</i> у конкретного Skill.
    heroUpgradeLevel: number
    --- Количество игровых очков текущего персонажа. Предназначение зависит от режима и может отличаться от одноименного поля в ClientInfo.
    gamePoints: number
    --- Количество очков усиления из ШД. Используется для отображения на клиенте и при выпадании предметов при смерти. Не влияет на урон или ХП персонажа.
    powerPoints: number
    --- Мяч (carryable), который держит персонаж. Если персонаж ничего не держит, то будет равен #nil.
    linkedCharacter: LogicCharacter?
    --- Индекс игрока, который в последний раз наносил урон этому персонажу.
    lastDamageSourceIndex: number
    --- …
    hasRespawnShield: boolean
    --- Оставшееся здоровье consumable-щита.
    consShieldValue: number
    --- Список подписок на событие получения урона.
    takingDamageListeners: List<DamageEventListener>
    --- Список подписок на событие нанесения урона.
    dealingDamageListeners: List<DamageEventListener>
    --- Список подписок на событие смерти (когда здоровье опускается до нуля).
    deathListeners: List<SourceListener>
    --- Список подписок на событие использования атаки или супера.
    skillUseListeners: List<SkillEventListener>
    --- Список подписок на событие использования гиперзаряда.
    startOverchargeListeners: List<BasicListener>
    --- Наносит определенный урон игроку.
    function takeDamage(self, srcIndex: number, damage: number, ulti: number, attacker: LogicCharacter?, projectile: LogicProjectile?, hasIndication: boolean, hasHighlight: boolean, srcX: number, srcY: number, someData: Data?, forceProtected: boolean, origin: AttackOrigin, forceAll: boolean, makeVisible: boolean, disallowSpawns: boolean, extraValue: number): boolean
    --- Лечит определенное количество здоровья игрока.
    function takeHeal(self, srcIndex: number, damage: number, hasIndication: boolean, someData: Data?, origin: AttackOrigin): boolean
    --- Останавливает движение персонажа.
    function stopMovement(self): ()
    --- Строит путь и начинает перемещение к указанной точке. Если hasCustomSpeed = false, то используется скорость персонажа.
    function moveTo(self, x: number, y: number, hasCustomSpeed: boolean, customSpeed: number, isNw: boolean, useTeleports: boolean): ()
    --- Возвращает #true, если игрок не может управлять своим персонажем в данный момент.
    function isPlayerControlRemoved(self): boolean
    --- Возвращает скилл основной атаки персонажа.
    function getWeaponSkill(self): Skill?
    --- Возвращает скилл супера персонажа.
    function getUltiSkill(self): Skill?
    --- Возвращает скилл с соответствующим SkillData, если такой присутствует у персонажа.
    function getSkill(self, data: SkillData?): Skill?
    --- Использует заданный скилл, если он доступен.
    function useSkill(self, data: SkillData?, x: number, y: number, isAutoAim: boolean): boolean
    --- Увеличивает максимальное количество здоровья у персонажа. Если второй аргумент равен #true, то также увеличивает на 1 количество банок в ШД.
    function increaseMaxHitPoints(self, value: number, powerUps: boolean): ()
    --- Телепортирует персонажа в указанную точку. Можно задать эффекты, которые появятся в исходной точке и точке назначения. Эти эффекты будут использовать заданный урон.
    function teleport(self, x: number, y: number, srcAreaEffect: AreaEffectData?, destAreaEffect: AreaEffectData?, damage: number, ultiCharge: number): ()
    --- Создает новый эффект от имени этого персонажа. Конкретно этот метод предполагается для таких механик, как супер Эмз, эффект зарядки ульты Базза или эффект лечения от станции Пэм. В общем, разные долгоживущие эффекты, зачастую привязанные к персонажу.
    function spawnCirclingAreaEffect(self, damageBonus: number, data: AreaEffectData?, origin: AttackOrigin, applyOwnerBuffs: boolean, followOwner: boolean): LogicAreaEffect?
    --- Позволяет получить первого питомца этого персонажа, если таковой присутствует. Иначе вернет #nil.
    function getPet(self, movingOnly: boolean, standingOnly: boolean): LogicCharacter?
    --- Сбрасывает таймер восстановления здоровья.
    function blockHealthRegen(self): ()
    --- Накладывает статус-эффект персонажу. Конкретное поведение эффекта определяется его StatusEffectData. Аргументы srcIndex, srcTeam, attacker позволяют определить от лица какого персонажа (и игрока) будет происходить действие (например, нанесение урона), если это применимо к этому эффекту. Может вернуть #nil, если (1) эффект не может быть наложен, либо (2) если такой эффект уже наложен, при этом Stackable = FALSE и Refreshable = FALSE.
    function addStatusEffect(self, data: StatusEffectData?, srcIndex: number, srcTeam: number, origin: AttackOrigin, attacker: LogicCharacter?): StatusEffect?
    --- Аналогично <i>addStatusEffect()</i>. Действие будет происходить от лица персонажа, на которого накладывается статус эффект.
    function addStatusEffectSelf(self, data: StatusEffectData?, origin: AttackOrigin): StatusEffect?
    --- Выдает классическую невидимость, как у супера Леона. Позволяет задать длительность и дистанцию, на которой персонаж становится принудительно видимым.
    function setInvisibility(self, ticks: number, distanceToSee: number): ()
    --- Выдает consumable-щит. Позволяет указать его количество здоровья (value) и длительность (ticks).
    function setConsumableShield(self, value: number, ticks: number): ()
    --- Выдает классический щит. Позволяет указать процент защиты (value) и длительность (ticks).
    function gainShield(self, ticks: number, value: number): ()
    --- Накладывает классический эффект стана. Позволяет указать длительность (ticks) и подтип (isSleepy, isCrossing).
    function setStun(self, ticks: number, skipImmunity: boolean, isSleepy: boolean, isCrossing: boolean): boolean
    --- Отталкивает персонажа от указанной точки. Сила (strength) определяет расстояние отталкивания.
    function push(self, pushX: number, pushY: number, strength: number, canFly: boolean, a7: boolean, a8: boolean, a9: boolean, skipCCImmunity: boolean, a11: boolean, a12: boolean, a13: boolean, useFixedDistance: boolean, stunTicks: number, speedModifier: number): ()
end

declare extern type Skill with
    --- …
    data: SkillData
    --- Количество тиков, через которое скилл перейдет из активного в неактивное состояние. Монотонно убывает. Если скилл не в активном состоянии, то равен нулю.
    activeTicksLeft: number
    --- Текущие патроны. Актуально только для основной атаки. Одна единица равна 1/1000 патрона.
    chargeValue: number
    --- Выставляет уровень улучшения этого скилла. Считается с нуля. Влияет на урон и другие параметры его атаки.
    function setUpgradeLevel(self, level: number): ()
    --- Максимальное значение для патронов. Актуально только для основной атаки. Одна единица равна 1/1000 патрона.
    function getMaxCharge(self): number
    --- Позволяет добавить или убавить текущие патроны. Актуально только для основной атаки. Аргумент выражается в 1/100 патрона и может быть отрицательным.
    function charge(self, percent: number): ()
    --- Возвращает #true, если это основная атака.
    function isWeaponSkill(self): boolean
    --- Возвращает #true, если это супер.
    function isUltiSkill(self): boolean
end

declare extern type StatusEffect with
    --- …
    data: StatusEffectData
    --- Общее количество тиков, в течение которых действует этот статус-эффект.
    ticksTotal: number
    --- Оставшееся количество тиков, в течение которых действует этот статус-эффект. Монотонно убывает.
    ticksLeft: number
    --- Базовое значение периодического урона без учета баффов и уровня.
    damageBase: number
    --- Базовое значение периодического исцеления без учета баффов и уровня.
    healingBase: number
    --- Прекращает действие статус-эффекта.
    function cancel(self): ()
    --- Продлевает действие статус-эффекта на указанное количество тиков.
    function addTicks(self, arg0: number): ()
    --- Позволяет узнать, активен ли статус-эффект в текущий момент времени.
    function isActive(self): boolean
end

declare extern type LogicProjectile extends LogicGameObject with
    --- Изначально равен нулю. При завершении движения выставляется положительное значение: #1 — достигнута предельная дистанция, #2 — попадание в границу карты, #3 — попадание в персонажа, #4 — попадание в блок, #5 — уничтожен извне.
    finishState: number
    --- Изначально равен #nil, но если попадание произошло в персонажа, то этот персонаж будет записан в это поле.
    shotCharacter: LogicCharacter?
    --- …
    origin: AttackOrigin
    --- …
    function setFinishState(self, finishState: number): ()
end

declare extern type LogicAreaEffect extends LogicGameObject with
    --- …
    ownerCharacter: LogicCharacter?
    --- …
    origin: AttackOrigin
    --- Урон, который будет наносить этот эффект персонажам в зоне действия.
    damage: number
    --- Количество супера, которое будет заряжаться у игрока при каждом нанесения урона.
    ultiEnergy: number
    --- …
    function setSource(self, index: number, team: number, ownerCharacter: LogicCharacter?, origin: AttackOrigin): ()
    --- Проверяет, находится ли игровой объект внутри зоны действия эффекта.
    function isObjectInside(self, object: LogicGameObject?): boolean
    --- Уничтожает этот эффект немедленно.
    function destroy(self): ()
    --- Начинает действие этого эффекта. Необходимо вызвать один раз после добавления в GameObjectManager.
    function trigger(self): ()
end

declare extern type LogicItem extends LogicGameObject with
    --- …
    isTriggered: boolean
    --- …
    triggeredCharacter: LogicCharacter?
    --- …
    ownerCharacter: LogicCharacter?
    --- …
    origin: AttackOrigin
    --- Если предмет является спреем (Spray), тогда указывает на индекс конкретного спрея.
    sprayDataIndex: number
    --- …
    function setSource(self, index: number, team: number, ownerCharacter: LogicCharacter?, origin: AttackOrigin): ()
    --- Уничтожает этот предмет немедленно.
    function destroy(self): ()
end

declare extern type Accessory with
    --- …
    data: AccessoryData
    --- …
    isActive: boolean
end

declare extern type TileMap with
    --- Ширина карты в клетках.
    tileSizeX: number
    --- Высота карты в клетках.
    tileSizeY: number
    --- Абсолютная ширина карты.
    absSizeX: number
    --- Абсолютная высота карты.
    absSizeY: number
    --- Уничтожает блок на заданной клетке.
    function destructTile(self, x: number, y: number, isBasicWeapon: boolean): ()
    --- Выставляет динамический блок на заданной клетке. Данный блок должен иметь DynamicCode != 0.
    function setDynamicTile(self, data: TileData?, x: number, y: number, ownerCharacter: LogicCharacter?): ()
    --- Возвращает тайл по тайловым (клеточным) координатам. Возвращает #nil, если задана точка вне карты.
    function getTile(self, x: number, y: number): Tile?
end

declare extern type Tile with
    --- Текущий TileData этой клетки.
    data: TileData
    --- Оригинальный TileData этой клетки. Загружается один раз и не меняется в течение боя.
    dataOriginal: TileData?
    --- …
    x: number
    --- …
    y: number
    --- Возвращает #true, если этот тайл был выставлен динамически.
    function isDynamic(self): boolean
    --- Восстанавливает изначальное состояние тайла с момента начала боя.
    function restoreOriginal(self): ()
end

declare extern type AttackOrigin with
end

declare extern type CharacterType with
end

declare extern type TraitType with
end

declare extern type GameMode with
end

declare extern type Data with
    --- Возвращает свой индекс в таблице.
    function getIndex(self): number
    --- Возвращает тип (числовой) своей таблицы. Для объектов внутри одной таблицы всегда будет одинаковым.
    function getType(self): number
    --- Возвращает свой уникальный ID. Фактически считается так: <code>(this.getType() * 1000000) + this.getIndex()</code>
    function getGlobalId(self): number
    --- …
    function getName(self): string
end

declare extern type GameObjectData extends Data with
end

declare extern type ProjectileData extends GameObjectData with
end

declare extern type CharacterData extends GameObjectData with
end

declare extern type ItemData extends GameObjectData with
end

declare extern type AreaEffectData extends GameObjectData with
end

declare extern type TileData extends Data with
end

declare extern type SkillData extends Data with
end

declare extern type LocationData extends Data with
end

declare extern type SkinData extends Data with
end

declare extern type StatusEffectData extends Data with
end

declare extern type AccessoryData extends Data with
end

declare extern type TraitData extends Data with
end

declare extern type DamageEventListener with
end

declare extern type SkillEventListener with
end

declare extern type SourceListener with
end

declare extern type BasicListener with
end

export type List<T> = Iterable<T>

export type ArrayList<T> = List<T>

declare Server: {[string]: any}

declare GameObjectManager: {[string]: any}

declare ClientInfo: {[string]: any}

declare LogicGameObject: {[string]: any}

declare Traits: {[string]: any}

declare LogicCharacter: {[string]: any}

declare Skill: {[string]: any}

declare StatusEffect: {[string]: any}

declare LogicProjectile: {[string]: any}

declare LogicAreaEffect: {[string]: any}

declare LogicItem: {[string]: any}

declare Accessory: {[string]: any}

declare TileMap: {[string]: any}

declare Tile: {[string]: any}

declare AttackOrigin: {[string]: any}

declare CharacterType: {[string]: any}

declare TraitType: {[string]: any}

declare GameMode: {[string]: any}

declare Data: {[string]: any}

declare GameObjectData: {[string]: any}

declare ProjectileData: {[string]: any}

declare CharacterData: {[string]: any}

declare ItemData: {[string]: any}

declare AreaEffectData: {[string]: any}

declare TileData: {[string]: any}

declare SkillData: {[string]: any}

declare LocationData: {[string]: any}

declare SkinData: {[string]: any}

declare StatusEffectData: {[string]: any}

declare AccessoryData: {[string]: any}

declare TraitData: {[string]: any}

declare DamageEventListener: {[string]: any}

declare SkillEventListener: {[string]: any}

declare SourceListener: {[string]: any}

declare BasicListener: {[string]: any}

declare Iterable: {[string]: any}

declare List: {[string]: any}

declare ArrayList: {[string]: any}

