export type Iterable<T> = {
    [number]: T,
    get: (self: Iterable<T>, index: number) -> T,
    add: (self: Iterable<T>, object: T) -> boolean,
    size: (self: Iterable<T>) -> number,
    indexOf: (self: Iterable<T>, object: T) -> number
}

declare extern type Server with
    tick: number
    playersCount: number
    locationData: LocationData?
    gameMode: GameMode
    isBattleEnded: boolean
    hasPoisonDisabled: boolean
    hasIntroSkip: boolean
    objectManager: GameObjectManager
    map: TileMap
    function getClientInfo(self, index: number): ClientInfo?
    function isIntroFinished(self): boolean
    function getRandomInt(self, N: number, M: number): number
    function debugFinishBattle(self, team: number): ()
end

declare extern type GameObjectManager with
    function getObject(self, id: number): LogicGameObject?
    function addObject(self, object: LogicGameObject?): ()
    function getCharacters(self): Iterable<LogicCharacter>
    function getAreaEffects(self): Iterable<LogicAreaEffect>
    function getItems(self): Iterable<LogicItem>
    function getProjectiles(self): Iterable<LogicProjectile>
end

declare extern type ClientInfo with
    index: number
    team: number
    objectId: number
    x: number
    y: number
    gamePoints: number
    isAlive: boolean
    isBot: boolean
    ultiCharge: number
    maxUltiCharge: number
    overchargeCharge: number
    maxOverchargeCharge: number
    ultiUsesLeft: number
    isRespawning: boolean
    emoteUsedIndex: number
    emoteUsedTick: number
    isOverchargeActive: boolean
    accessory: Accessory?
    function getSkinData(self): SkinData?
    function getAttackTeam(self): number
end

declare extern type LogicGameObject with
    id: number
    data: GameObjectData
    x: number
    y: number
    z: number
    index: number
    team: number
    dimension: number
    traits: Traits?
    function setPosition(self, x: number, y: number, z: number): ()
    function isAlive(self): boolean
    function getType(self): number
    function getSkinData(self): SkinData?
    function isOverchargeActive(self): boolean
    function setIndex(self, index: number, team: number): ()
end

declare extern type Traits with
    function add(self, data: TraitData?): ()
    function remove(self, data: TraitData?): boolean
    function getComponent(self, type: TraitType): TraitData?
end

declare extern type LogicCharacter extends LogicGameObject with
    angleLegs: number
    angleHead: number
    hitPoints: number
    maxHitPoints: number
    type: CharacterType
    isBot: boolean
    isStunned: boolean
    persistentSpeedBuff: number
    persistentReloadBuff: number
    heroUpgradeLevel: number
    gamePoints: number
    powerPoints: number
    linkedCharacter: LogicCharacter?
    lastDamageSourceIndex: number
    hasRespawnShield: boolean
    consShieldValue: number
    takingDamageListeners: List<DamageEventListener>
    dealingDamageListeners: List<DamageEventListener>
    deathListeners: List<SourceListener>
    skillUseListeners: List<SkillEventListener>
    startOverchargeListeners: List<BasicListener>
    function takeDamage(self, srcIndex: number, damage: number, ulti: number, attacker: LogicCharacter?, projectile: LogicProjectile?, hasIndication: boolean, hasHighlight: boolean, srcX: number, srcY: number, someData: Data?, forceProtected: boolean, origin: AttackOrigin, forceAll: boolean, makeVisible: boolean, disallowSpawns: boolean, extraValue: number): boolean
    function takeHeal(self, srcIndex: number, damage: number, hasIndication: boolean, someData: Data?, origin: AttackOrigin): boolean
    function stopMovement(self): ()
    function moveTo(self, x: number, y: number, hasCustomSpeed: boolean, customSpeed: number, isNw: boolean, useTeleports: boolean): ()
    function isPlayerControlRemoved(self): boolean
    function getWeaponSkill(self): Skill?
    function getUltiSkill(self): Skill?
    function getSkill(self, data: SkillData?): Skill?
    function useSkill(self, data: SkillData?, x: number, y: number, isAutoAim: boolean): boolean
    function increaseMaxHitPoints(self, value: number, powerUps: boolean): ()
    function teleport(self, x: number, y: number, srcAreaEffect: AreaEffectData?, destAreaEffect: AreaEffectData?, damage: number, ultiCharge: number): ()
    function spawnCirclingAreaEffect(self, damageBonus: number, data: AreaEffectData?, origin: AttackOrigin, applyOwnerBuffs: boolean, followOwner: boolean): LogicAreaEffect?
    function getPet(self, movingOnly: boolean, standingOnly: boolean): LogicCharacter?
    function blockHealthRegen(self): ()
    function addStatusEffect(self, data: StatusEffectData?, srcIndex: number, srcTeam: number, origin: AttackOrigin, attacker: LogicCharacter?): StatusEffect?
    function addStatusEffectSelf(self, data: StatusEffectData?, origin: AttackOrigin): StatusEffect?
    function setInvisibility(self, ticks: number, distanceToSee: number): ()
    function setConsumableShield(self, value: number, ticks: number): ()
    function gainShield(self, ticks: number, value: number): ()
    function setStun(self, ticks: number, skipImmunity: boolean, isSleepy: boolean, isCrossing: boolean): boolean
    function push(self, pushX: number, pushY: number, strength: number, canFly: boolean, a7: boolean, a8: boolean, a9: boolean, skipCCImmunity: boolean, a11: boolean, a12: boolean, a13: boolean, useFixedDistance: boolean, stunTicks: number, speedModifier: number): ()
end

declare extern type Skill with
    data: SkillData
    activeTicksLeft: number
    chargeValue: number
    function setUpgradeLevel(self, level: number): ()
    function getMaxCharge(self): number
    function charge(self, percent: number): ()
    function isWeaponSkill(self): boolean
    function isUltiSkill(self): boolean
end

declare extern type StatusEffect with
    data: StatusEffectData
    ticksTotal: number
    ticksLeft: number
    damageBase: number
    healingBase: number
    function cancel(self): ()
    function addTicks(self, arg0: number): ()
    function isActive(self): boolean
end

declare extern type LogicProjectile extends LogicGameObject with
    finishState: number
    shotCharacter: LogicCharacter?
    origin: AttackOrigin
    function setFinishState(self, finishState: number): ()
end

declare extern type LogicAreaEffect extends LogicGameObject with
    ownerCharacter: LogicCharacter?
    origin: AttackOrigin
    damage: number
    ultiEnergy: number
    function setSource(self, index: number, team: number, ownerCharacter: LogicCharacter?, origin: AttackOrigin): ()
    function isObjectInside(self, object: LogicGameObject?): boolean
    function destroy(self): ()
    function trigger(self): ()
end

declare extern type LogicItem extends LogicGameObject with
    isTriggered: boolean
    triggeredCharacter: LogicCharacter?
    ownerCharacter: LogicCharacter?
    origin: AttackOrigin
    sprayDataIndex: number
    function setSource(self, index: number, team: number, ownerCharacter: LogicCharacter?, origin: AttackOrigin): ()
    function destroy(self): ()
end

declare extern type Accessory with
    data: AccessoryData
    isActive: boolean
end

declare extern type TileMap with
    tileSizeX: number
    tileSizeY: number
    absSizeX: number
    absSizeY: number
    function destructTile(self, x: number, y: number, isBasicWeapon: boolean): ()
    function setDynamicTile(self, data: TileData?, x: number, y: number, ownerCharacter: LogicCharacter?): ()
    function getTile(self, x: number, y: number): Tile?
end

declare extern type Tile with
    data: TileData
    dataOriginal: TileData?
    x: number
    y: number
    function isDynamic(self): boolean
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
    function getIndex(self): number
    function getType(self): number
    function getGlobalId(self): number
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

