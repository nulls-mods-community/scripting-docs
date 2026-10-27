# Server

The current battle object. Exists as a single instance. Serves as the entry point to the scripting API.

### Fields:

| Name                 | Type                                                                 | Purpose                                                                                             |
| -------------------- | -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| tick                 | number <sup>(readonly)</sup>                                         | Current server tick. Monotonically increases by 1 every 50 milliseconds.                            |
| playersCount         | number <sup>(readonly)</sup>                                         | Number of players in the battle.                                                                    |
| locationData         | [LocationData](#locationdata)? <sup>(readonly)</sup>                 | [LocationData](#locationdata) of the current location. Can be <b>nil</b> if a custom map is in use. |
| gameMode             | [GameMode](#gamemode) <sup>(readonly)</sup>                          | Current game mode.                                                                                  |
| isBattleEnded        | boolean <sup>(readonly)</sup>                                        | Is the battle finished?                                                                             |
| hasPoisonDisabled    | boolean                                                              | Is the game mode poison disabled?                                                                   |
| hasIntroSkip         | boolean                                                              | Should the intro animation be skipped?                                                              |
| objectManager        | [GameObjectManager](#gameobjectmanager) <sup>(readonly)</sup>        | …                                                                                                   |
| map                  | [TileMap](#tilemap) <sup>(readonly)</sup>                            | …                                                                                                   |
| customInputListeners | [List](#list)<[InputListener](#inputlistener)> <sup>(readonly)</sup> | …                                                                                                   |

### Methods:

| Name              | Type                                         | Purpose                                                                                                          |
| ----------------- | -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| getClientInfo     | (index: number) ⇒ [ClientInfo](#clientinfo)? | Allows you to retrieve a [ClientInfo](#clientinfo) object by player index.                                       |
| isIntroFinished   | () ⇒ boolean                                 | Allows you to check if the battle intro animation has ended.                                                     |
| getRandomInt      | (N: number, M: number) ⇒ number              | Allows you to get a random integer from N to M: [N, M). Uses the same random number generator as the game logic. |
| debugFinishBattle | (team: number) ⇒ ()                          | Forcefully ends the battle, specifying the winning team.                                                         |

# GameObjectManager

Manager of game objects [LogicGameObject](#logicgameobject). Stores game objects and manages their lifecycle.

### Methods:

| Name           | Type                                                            | Purpose                                                              |
| -------------- | --------------------------------------------------------------- | -------------------------------------------------------------------- |
| getObject      | (id: number) ⇒ [LogicGameObject](#logicgameobject)?             | Searches for an object by its Object ID.                             |
| addObject      | (object: [LogicGameObject](#logicgameobject)?) ⇒ ()             | Adds a new object to the battlefield.                                |
| getCharacters  | () ⇒ [Iterable](#iterable)<[LogicCharacter](#logiccharacter)>   | Returns a list of [LogicCharacter](#logiccharacter) class objects.   |
| getAreaEffects | () ⇒ [Iterable](#iterable)<[LogicAreaEffect](#logicareaeffect)> | Returns a list of [LogicAreaEffect](#logicareaeffect) class objects. |
| getItems       | () ⇒ [Iterable](#iterable)<[LogicItem](#logicitem)>             | Returns a list of [LogicItem](#logicitem) objects.                   |
| getProjectiles | () ⇒ [Iterable](#iterable)<[LogicProjectile](#logicprojectile)> | Returns a list of [LogicProjectile](#logicprojectile) objects.       |

# ClientInfo

Data for a specific player. A single instance of this object is created for each player for the entire battle. Keep in mind that some fields (e.g., `x`, `y`, `isAlive`) are only updated at the end of the game loop each tick.

### Fields:

| Name                | Type                                           | Purpose                                                                                                                                |
| ------------------- | ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| index               | number <sup>(readonly)</sup>                   | This player's index.                                                                                                                   |
| team                | number <sup>(readonly)</sup>                   | The player's team number. Two players on the same team will share this value.                                                          |
| objectId            | number <sup>(readonly)</sup>                   | Object ID of the current [LogicCharacter](#logiccharacter) that the player is playing as.                                              |
| x                   | number <sup>(readonly)</sup>                   | …                                                                                                                                      |
| y                   | number <sup>(readonly)</sup>                   | Player camera position. Will, in most cases, match the position of the [LogicCharacter](#logiccharacter) that the player is playing as. |
| gamePoints          | number                                         | Number of game points. Its purpose depends on the game mode.                                                                           |
| isAlive             | boolean <sup>(readonly)</sup>                  | Equals <b>true</b> if the player's character is alive and present on the map.                                                          |
| isBot               | boolean <sup>(readonly)</sup>                  | Indicates whether the player is a bot.                                                                                                 |
| ultiCharge          | number                                         | …                                                                                                                                      |
| maxUltiCharge       | number <sup>(readonly)</sup>                   | …                                                                                                                                      |
| overchargeCharge    | number                                         | …                                                                                                                                      |
| maxOverchargeCharge | number <sup>(readonly)</sup>                   | …                                                                                                                                      |
| ultiUsesLeft        | number <sup>(readonly)</sup>                   | …                                                                                                                                      |
| isRespawning        | boolean <sup>(readonly)</sup>                  | Equals <b>true</b> if the player is respawning and is about to spawn in.                                                               |
| emoteUsedIndex      | number <sup>(readonly)</sup>                   | …                                                                                                                                      |
| emoteUsedTick       | number <sup>(readonly)</sup>                   | …                                                                                                                                      |
| isOverchargeActive  | boolean <sup>(readonly)</sup>                  | …                                                                                                                                      |
| accessory           | [Accessory](#accessory)? <sup>(readonly)</sup> | …                                                                                                                                      |

### Methods:

| Name          | Type                        | Purpose                                                                                                                                                                                        |
| ------------- | --------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| getSkinData   | () ⇒ [SkinData](#skindata)? | Returns the current [SkinData](#skindata) for this player.                                                                                                                                     |
| getAttackTeam | () ⇒ number                 | Returns the player's effective team number. If the player is controlled by Willow, the value will be equal to that Willow's team number. Otherwise, it will be equal to the <i>team</i> field. |

# LogicGameObject

Abstract class. Game object on the battlefield.

### Fields:

| Name      | Type                                                    | Purpose                                                                                                         |
| --------- | ------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| id        | number <sup>(readonly)</sup>                            | Unique Object ID of this object.                                                                                |
| data      | [GameObjectData](#gameobjectdata) <sup>(readonly)</sup> | …                                                                                                               |
| x         | number <sup>(readonly)</sup>                            | …                                                                                                               |
| y         | number <sup>(readonly)</sup>                            | …                                                                                                               |
| z         | number <sup>(readonly)</sup>                            | …                                                                                                               |
| index     | number <sup>(readonly)</sup>                            | Index of the player the object belongs to. Equals <b>-1</b> if the object does not belong to anyone.            |
| team      | number <sup>(readonly)</sup>                            | The number of the team the object belongs to. Equals <b>-1</b> if the object is neutral or hostile to everyone. |
| dimension | number <sup>(readonly)</sup>                            | Dimension. Equals <b>1</b> if the object is in Cordelius's dimension, and <b>0</b> otherwise.                   |
| traits    | [Traits](#traits) <sup>(readonly)</sup>                 | …                                                                                                               |

### Methods:

| Name               | Type                                   | Purpose                                                                                                                                                                                                                            |
| ------------------ | -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| setPosition        | (x: number, y: number, z: number) ⇒ () | Sets the object's coordinates. Note: Game logic may overwrite your coordinates if the object is moving.                                                                                                                            |
| isAlive            | () ⇒ boolean                           | Returns <b>false</b> if the object was destroyed or killed. Otherwise, it returns <b>true</b>.                                                                                                                                     |
| getType            | () ⇒ number                            | Allows you to determine the type of this object: <b>0</b> = [LogicCharacter](#logiccharacter), <b>1</b> = [LogicProjectile](#logicprojectile), <b>2</b> = [LogicAreaEffect](#logicareaeffect), <b>3</b> = [LogicItem](#logicitem). |
| getSkinData        | () ⇒ [SkinData](#skindata)?            | …                                                                                                                                                                                                                                  |
| isOverchargeActive | () ⇒ boolean                           | …                                                                                                                                                                                                                                  |
| setIndex           | (index: number, team: number) ⇒ ()     | Allows setting the owner player of the object. It is recommended to call this only before adding the object to the [GameObjectManager](#gameobjectmanager).                                                                        |

# Traits

Manager of special abilities (traits) for a specific game object. New objects inherit traits from their parent objects.

### Methods:

| Name         | Type                                                       | Purpose                                                                                                                   |
| ------------ | ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| add          | (data: [TraitData](#traitdata)?) ⇒ ()                      | Adds a specific trait.                                                                                                    |
| remove       | (data: [TraitData](#traitdata)?) ⇒ boolean                 | Removes a specific trait.                                                                                                 |
| getComponent | (type: [TraitType](#traittype)) ⇒ [TraitData](#traitdata)? | Allows you to retrieve a specific trait by its type. Returns <b>nil</b> if the object does not have a trait of that type. |

# LogicCharacter

Inherits from [LogicGameObject](#logicgameobject).

Character. Has health, can move along a given path, and attack. The broadest object class.

### Fields:

| Name                     | Type                                                                             | Purpose                                                                                                                                                              |
| ------------------------ | -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| angleLegs                | number <sup>(readonly)</sup>                                                     | The direction angle of the character's legs. This value can be used to determine the character's movement direction.                                                 |
| angleHead                | number <sup>(readonly)</sup>                                                     | The direction angle of the character's head.                                                                                                                         |
| hitPoints                | number <sup>(readonly)</sup>                                                     | Current health amount.                                                                                                                                               |
| maxHitPoints             | number <sup>(readonly)</sup>                                                     | Maximum health amount.                                                                                                                                               |
| type                     | [CharacterType](#charactertype) <sup>(readonly)</sup>                            | The character's type.                                                                                                                                                |
| isBot                    | boolean <sup>(readonly)</sup>                                                    | Is the character controlled by a bot?                                                                                                                                |
| isStunned                | boolean <sup>(readonly)</sup>                                                    | Is the character stunned?                                                                                                                                            |
| persistentSpeedBuff      | number                                                                           | …                                                                                                                                                                    |
| persistentReloadBuff     | number                                                                           | …                                                                                                                                                                    |
| heroUpgradeLevel         | number                                                                           | Character upgrade level. Starts at zero. Not all game mechanics use this field, so you may also need to call <i>setUpgradeLevel()</i> on a specific [Skill](#skill). |
| gamePoints               | number                                                                           | Number of game points for the current character. Its purpose depends on the game mode and may differ from the field of the same name in [ClientInfo](#clientinfo).   |
| powerPoints              | number                                                                           | The number of Power Cubes from Showdown. Used for client-side display and for dropping items upon death. Does not affect the character's damage or HP.               |
| linkedCharacter          | [LogicCharacter](#logiccharacter)? <sup>(readonly)</sup>                         | The ball (carryable) that the character is holding. If the character is not holding anything, it will be equal to <b>nil</b>.                                        |
| lastDamageSourceIndex    | number <sup>(readonly)</sup>                                                     | Index of the player who most recently dealt damage to this character.                                                                                                |
| hasRespawnShield         | boolean <sup>(readonly)</sup>                                                    | …                                                                                                                                                                    |
| consShieldValue          | number <sup>(readonly)</sup>                                                     | Remaining health of the consumable shield.                                                                                                                           |
| statusEffects            | [StatusEffectList](#statuseffectlist)? <sup>(readonly)</sup>                     | …                                                                                                                                                                    |
| takingDamageListeners    | [List](#list)<[DamageEventListener](#damageeventlistener)> <sup>(readonly)</sup> | List of subscriptions to the damage received event.                                                                                                                  |
| dealingDamageListeners   | [List](#list)<[DamageEventListener](#damageeventlistener)> <sup>(readonly)</sup> | List of subscriptions to the damage dealt event.                                                                                                                     |
| deathListeners           | [List](#list)<[SourceListener](#sourcelistener)> <sup>(readonly)</sup>           | List of subscriptions to the death event (when health drops to zero).                                                                                                |
| skillUseListeners        | [List](#list)<[SkillEventListener](#skilleventlistener)> <sup>(readonly)</sup>   | List of subscriptions to the attack or Super used event.                                                                                                             |
| startOverchargeListeners | [List](#list)<[BasicListener](#basiclistener)> <sup>(readonly)</sup>             | List of subscriptions to the hypercharge used event.                                                                                                                 |

### Methods:

| Name                                        | Type                                                                                                                                                                                                                                                                                                                                                                                                                  | Purpose                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| takeDamage                                  | (srcIndex: number, damage: number, ulti: number, attacker: [LogicCharacter](#logiccharacter)?, projectile: [LogicProjectile](#logicprojectile)?, hasIndication: boolean, hasHighlight: boolean, srcX: number, srcY: number, someData: [Data](#data)?, forceProtected: boolean, origin: [AttackOrigin](#attackorigin), forceAll: boolean, makeVisible: boolean, disallowSpawns: boolean, extraValue: number) ⇒ boolean | Inflicts a certain amount of damage on the character.                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| takeHeal                                    | (srcIndex: number, damage: number, hasIndication: boolean, someData: [Data](#data)?, origin: [AttackOrigin](#attackorigin)) ⇒ boolean                                                                                                                                                                                                                                                                                 | Restores a certain amount of the character's health.                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| stopMovement                                | () ⇒ ()                                                                                                                                                                                                                                                                                                                                                                                                               | Stops the character's movement.                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| moveTo                                      | (x: number, y: number, hasCustomSpeed: boolean, customSpeed: number, isNw: boolean, useTeleports: boolean) ⇒ ()                                                                                                                                                                                                                                                                                                       | Builds a path and begins moving toward the specified point. If hasCustomSpeed = false, the character's speed is used.                                                                                                                                                                                                                                                                                                                                                                  |
| isPlayerControlRemoved                      | () ⇒ boolean                                                                                                                                                                                                                                                                                                                                                                                                          | Returns <b>true</b> if the player is currently unable to control their character.                                                                                                                                                                                                                                                                                                                                                                                                      |
| isInMovement                                | () ⇒ boolean                                                                                                                                                                                                                                                                                                                                                                                                          | Returns <b>true</b> if the character is currently moving.                                                                                                                                                                                                                                                                                                                                                                                                                              |
| getWeaponSkill                              | () ⇒ [Skill](#skill)?                                                                                                                                                                                                                                                                                                                                                                                                 | Returns the character's primary attack skill.                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| getUltiSkill                                | () ⇒ [Skill](#skill)?                                                                                                                                                                                                                                                                                                                                                                                                 | Returns the character's Super skill.                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| getSkill                                    | (data: [SkillData](#skilldata)?) ⇒ [Skill](#skill)?                                                                                                                                                                                                                                                                                                                                                                   | Returns a skill with the corresponding [SkillData](#skilldata) if the character has one.                                                                                                                                                                                                                                                                                                                                                                                               |
| useSkill                                    | (data: [SkillData](#skilldata)?, x: number, y: number, isAutoAim: boolean) ⇒ boolean                                                                                                                                                                                                                                                                                                                                  | Uses the specified skill, if available.                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| getWalkSpeed                                | (x: number, y: number) ⇒ number                                                                                                                                                                                                                                                                                                                                                                                       | Returns the current walking speed, taking buffs into account.                                                                                                                                                                                                                                                                                                                                                                                                                          |
| getSummaryDamageBuff                        | () ⇒ number                                                                                                                                                                                                                                                                                                                                                                                                           | Returns the total damage buff as a percentage.                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| changeCharacter                             | (data: [CharacterData](#characterdata)?) ⇒ [LogicCharacter](#logiccharacter)?                                                                                                                                                                                                                                                                                                                                         | Changes the current playable character to the specified one. Meg or Bonnie's Super mechanic.                                                                                                                                                                                                                                                                                                                                                                                           |
| increaseMaxHitPoints                        | (value: number, powerUps: boolean) ⇒ ()                                                                                                                                                                                                                                                                                                                                                                               | Increases the character's maximum health. If the second argument equals <b>true</b>, it will also increase the number of Showdown Power Cubes by 1.                                                                                                                                                                                                                                                                                                                                    |
| teleport                                    | (x: number, y: number, srcAreaEffect: [AreaEffectData](#areaeffectdata)?, destAreaEffect: [AreaEffectData](#areaeffectdata)?, damage: number, ultiCharge: number) ⇒ ()                                                                                                                                                                                                                                                | Teleports the character to the specified point. Effects can be specified to appear at the origin and destination points. These effects will use the specified damage amount.                                                                                                                                                                                                                                                                                                           |
| spawnCirclingAreaEffect                     | (damageBonus: number, data: [AreaEffectData](#areaeffectdata)?, origin: [AttackOrigin](#attackorigin), applyOwnerBuffs: boolean, followOwner: boolean) ⇒ [LogicAreaEffect](#logicareaeffect)?                                                                                                                                                                                                                         | Creates a new effect on behalf of this character. Specifically, this method is intended for mechanics like Emz's Super, Buzz's Super-charging area, or the healing effect from Pam's turret. In general, it's for various long-lasting effects that are often attached to a character.                                                                                                                                                                                                 |
| getPet                                      | (movingOnly: boolean, standingOnly: boolean) ⇒ [LogicCharacter](#logiccharacter)?                                                                                                                                                                                                                                                                                                                                     | Allows you to retrieve this character's first pet, if one exists. Otherwise, it returns <b>nil</b>.                                                                                                                                                                                                                                                                                                                                                                                    |
| blockHealthRegen                            | () ⇒ ()                                                                                                                                                                                                                                                                                                                                                                                                               | Resets the health regeneration timer.                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| addStatusEffect                             | (data: [StatusEffectData](#statuseffectdata)?, srcIndex: number, srcTeam: number, origin: [AttackOrigin](#attackorigin), attacker: [LogicCharacter](#logiccharacter)?) ⇒ [StatusEffect](#statuseffect)?                                                                                                                                                                                                               | Applies a status effect to a character. The specific behavior of the effect is determined by its [StatusEffectData](#statuseffectdata). The arguments srcIndex, srcTeam, and attacker allow you to specify on behalf of which character (and player) the action (e.g., dealing damage) will occur, if applicable to this effect. May return <b>nil</b> if (1) the effect cannot be applied, or (2) such an effect is already applied, while Stackable = FALSE and Refreshable = FALSE. |
| addStatusEffectSelf                         | (data: [StatusEffectData](#statuseffectdata)?, origin: [AttackOrigin](#attackorigin)) ⇒ [StatusEffect](#statuseffect)?                                                                                                                                                                                                                                                                                                | Same as <i>addStatusEffect()</i>. The action will occur on behalf of the character to whom the status effect is applied.                                                                                                                                                                                                                                                                                                                                                               |
| setInvisibility <sup>[[1]](#01def85e)</sup> | (ticks: number, distanceToSee: number) ⇒ ()                                                                                                                                                                                                                                                                                                                                                                           | Grants a classic invisibility effect, just like Leon's Super. Allows setting the duration and the distance at which the character is forcibly revealed.                                                                                                                                                                                                                                                                                                                                |
| setConsumableShield                         | (value: number, ticks: number) ⇒ ()                                                                                                                                                                                                                                                                                                                                                                                   | Grants a consumable shield. Allows specifying its health amount (value) and duration (ticks).                                                                                                                                                                                                                                                                                                                                                                                          |
| gainShield <sup>[[1]](#01def85e)</sup>      | (ticks: number, value: number) ⇒ ()                                                                                                                                                                                                                                                                                                                                                                                   | Grants a classic shield. Allows specifying the defense percentage (value) and duration (ticks).                                                                                                                                                                                                                                                                                                                                                                                        |
| setStun <sup>[[1]](#01def85e)</sup>         | (ticks: number, skipImmunity: boolean, isSleepy: boolean, isCrossing: boolean) ⇒ boolean                                                                                                                                                                                                                                                                                                                              | Applies a classic stun effect. Allows specifying the duration (ticks) and subtype (isSleepy, isCrossing).                                                                                                                                                                                                                                                                                                                                                                              |
| push                                        | (pushX: number, pushY: number, strength: number, canFly: boolean, a7: boolean, a8: boolean, a9: boolean, skipCCImmunity: boolean, a11: boolean, a12: boolean, a13: boolean, useFixedDistance: boolean, stunTicks: number, speedModifier: number) ⇒ ()                                                                                                                                                                 | Pushes the character away from the specified point. The strength determines the push distance.                                                                                                                                                                                                                                                                                                                                                                                         |

<span id="01def85e"><sup>[1]</sup> Whenever possible, it is recommended to use status effects instead of this method.</span>

# Skill

…

### Fields:

| Name            | Type                                          | Purpose                                                                                                                                                           |
| --------------- | --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| data            | [SkillData](#skilldata) <sup>(readonly)</sup> | …                                                                                                                                                                 |
| activeTicksLeft | number <sup>(readonly)</sup>                  | The number of ticks until the skill transitions from an active to an inactive state. Monotonically decreases. Equals zero if the skill is not in an active state. |
| chargeValue     | number <sup>(readonly)</sup>                  | Current ammo. Applies only to the primary attack. One unit is equal to 1/1000 of a round.                                                                         |

### Methods:

| Name            | Type                   | Purpose                                                                                                                                               |
| --------------- | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| setUpgradeLevel | (level: number) ⇒ ()   | Sets the upgrade level for this skill. Starts at zero. Affects the damage and other parameters of its attack.                                         |
| getMaxCharge    | () ⇒ number            | Maximum ammo value. Applies only to the primary attack. One unit is equal to 1/1000 of a round.                                                       |
| charge          | (percent: number) ⇒ () | Increases or decreases the current ammo count. Applies only to the primary attack. The argument is expressed in 1/100 of a round and may be negative. |
| isWeaponSkill   | () ⇒ boolean           | Returns <b>true</b> if this is the primary attack.                                                                                                    |
| isUltiSkill     | () ⇒ boolean           | Returns <b>true</b> if this is the Super.                                                                                                             |

# StatusEffectList

A list of status effects for a specific character or projectile.

### Methods:

| Name          | Type                                                                                                 | Purpose                                                                                                                      |
| ------------- | ---------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| getEffect     | (data: [StatusEffectData](#statuseffectdata)?) ⇒ [StatusEffect](#statuseffect)?                      | Searches for a specific effect based on its <i>data</i>. Returns <b>nil</b> if no such effect exists.                        |
| getEffectSpec | (data: [StatusEffectData](#statuseffectdata)?, sourceIndex: number) ⇒ [StatusEffect](#statuseffect)? | Searches for a specific effect based on its <i>data</i> and <i>sourceIndex</i>. Returns <b>nil</b> if no such effect exists. |

# StatusEffect

…

### Fields:

| Name        | Type                                                        | Purpose                                                                                           |
| ----------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| data        | [StatusEffectData](#statuseffectdata) <sup>(readonly)</sup> | …                                                                                                 |
| damageBase  | number                                                      | Base periodic damage value, excluding buffs and level.                                            |
| healingBase | number                                                      | Base periodic healing value, excluding buffs and level.                                           |
| sourceIndex | number <sup>(readonly)</sup>                                | Index of the player who applied the effect.                                                       |
| sourceTeam  | number <sup>(readonly)</sup>                                | Team number of the player who applied the effect.                                                 |
| ticksTotal  | number <sup>(readonly)</sup>                                | Total number of ticks during which the status effect remains active.                              |
| ticksLeft   | number <sup>(readonly)</sup>                                | Remaining number of ticks during which the status effect remains active. Monotonically decreases. |

### Methods:

| Name     | Type                | Purpose                                                                     |
| -------- | ------------------- | --------------------------------------------------------------------------- |
| cancel   | () ⇒ ()             | Cancels the status effect.                                                  |
| addTicks | (arg0: number) ⇒ () | Extends the duration of the status effect by the specified number of ticks. |
| isActive | () ⇒ boolean        | Checks if the status effect is currently active.                            |

# LogicProjectile

Inherits from [LogicGameObject](#logicgameobject).

A projectile. It travels along a set trajectory and can deal damage to characters and other targets.

### Fields:

| Name          | Type                                                         | Purpose                                                                                                                                                                                                                         |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| finishState   | number <sup>(readonly)</sup>                                 | Initially set to zero. Upon completion of movement, set to a positive value: <b>1</b> — maximum distance reached, <b>2</b> — hit map boundary, <b>3</b> — hit character, <b>4</b> — hit block, <b>5</b> — destroyed externally. |
| shotCharacter | [LogicCharacter](#logiccharacter)? <sup>(readonly)</sup>     | Initially equal to <b>nil</b>, but if a hit occurs on a character, that character will be recorded in this field.                                                                                                               |
| origin        | [AttackOrigin](#attackorigin) <sup>(readonly)</sup>          | …                                                                                                                                                                                                                               |
| angle         | number <sup>(readonly)</sup>                                 | Direction angle.                                                                                                                                                                                                                |
| damage        | number                                                       | The damage that this effect will deal to characters within its area of effect.                                                                                                                                                  |
| ultiEnergy    | number                                                       | The amount of Super charged each time the player deals damage.                                                                                                                                                                  |
| statusEffects | [StatusEffectList](#statuseffectlist)? <sup>(readonly)</sup> | …                                                                                                                                                                                                                               |

### Methods:

| Name           | Type                       | Purpose |
| -------------- | -------------------------- | ------- |
| setFinishState | (finishState: number) ⇒ () | …       |

# LogicAreaEffect

Inherits from [LogicGameObject](#logicgameobject).

An area with an effect. It affects characters (and certain projectiles); the mechanics depend on the specific effect.

### Fields:

| Name           | Type                                                     | Purpose                                                                        |
| -------------- | -------------------------------------------------------- | ------------------------------------------------------------------------------ |
| ownerCharacter | [LogicCharacter](#logiccharacter)? <sup>(readonly)</sup> | …                                                                              |
| origin         | [AttackOrigin](#attackorigin) <sup>(readonly)</sup>      | …                                                                              |
| damage         | number                                                   | The damage that this effect will deal to characters within its area of effect. |
| ultiEnergy     | number                                                   | The amount of Super charged each time the player deals damage.                 |

### Methods:

| Name           | Type                                                                                                                          | Purpose                                                                                                 |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| setSource      | (index: number, team: number, ownerCharacter: [LogicCharacter](#logiccharacter)?, origin: [AttackOrigin](#attackorigin)) ⇒ () | …                                                                                                       |
| isObjectInside | (object: [LogicGameObject](#logicgameobject)?) ⇒ boolean                                                                      | Checks whether a game object is within the effect's area of effect.                                     |
| destroy        | () ⇒ ()                                                                                                                       | Immediately destroys this effect.                                                                       |
| trigger        | () ⇒ ()                                                                                                                       | Initiates this effect. Must be called once after adding to the [GameObjectManager](#gameobjectmanager). |

# LogicItem

Inherits from [LogicGameObject](#logicgameobject).

An item. Can usually be picked up or activated.

### Fields:

| Name               | Type                                                     | Purpose                                                                            |
| ------------------ | -------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| isTriggered        | boolean <sup>(readonly)</sup>                            | …                                                                                  |
| triggeredCharacter | [LogicCharacter](#logiccharacter)? <sup>(readonly)</sup> | …                                                                                  |
| ownerCharacter     | [LogicCharacter](#logiccharacter)? <sup>(readonly)</sup> | …                                                                                  |
| origin             | [AttackOrigin](#attackorigin) <sup>(readonly)</sup>      | …                                                                                  |
| sprayDataIndex     | number                                                   | If the item is a spray (Spray), then it points to the index of the specific spray. |

### Methods:

| Name      | Type                                                                                                                          | Purpose                         |
| --------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| setSource | (index: number, team: number, ownerCharacter: [LogicCharacter](#logiccharacter)?, origin: [AttackOrigin](#attackorigin)) ⇒ () | …                               |
| destroy   | () ⇒ ()                                                                                                                       | Immediately destroys this item. |

# Accessory

…

### Fields:

| Name     | Type                                                  | Purpose |
| -------- | ----------------------------------------------------- | ------- |
| data     | [AccessoryData](#accessorydata) <sup>(readonly)</sup> | …       |
| isActive | boolean <sup>(readonly)</sup>                         | …       |

# TileMap

Battle map; contains a tile grid and allows working with it.

### Fields:

| Name      | Type                         | Purpose                       |
| --------- | ---------------------------- | ----------------------------- |
| tileSizeX | number <sup>(readonly)</sup> | Map width in tiles.           |
| tileSizeY | number <sup>(readonly)</sup> | Map height in tiles.          |
| absSizeX  | number <sup>(readonly)</sup> | Map width in absolute units.  |
| absSizeY  | number <sup>(readonly)</sup> | Map height in absolute units. |

### Methods:

| Name           | Type                                                                                                          | Purpose                                                                                                    |
| -------------- | ------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| destructTile   | (x: number, y: number, isBasicWeapon: boolean) ⇒ ()                                                           | Destroys the block at the specified tile.                                                                  |
| setDynamicTile | (data: [TileData](#tiledata)?, x: number, y: number, ownerCharacter: [LogicCharacter](#logiccharacter)?) ⇒ () | Sets a dynamic block at the specified tile. This block must have DynamicCode != 0.                         |
| getTile        | (x: number, y: number) ⇒ [Tile](#tile)?                                                                       | Returns the tile by tile (cell) coordinates. Returns <b>nil</b> if the specified point is outside the map. |

# Tile

A specific tile on the map.

### Fields:

| Name         | Type                                         | Purpose                                                                                                     |
| ------------ | -------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| data         | [TileData](#tiledata) <sup>(readonly)</sup>  | Current [TileData](#tiledata) of this tile.                                                                 |
| dataOriginal | [TileData](#tiledata)? <sup>(readonly)</sup> | Original [TileData](#tiledata) of this tile. It is loaded once and remains unchanged throughout the battle. |
| x            | number <sup>(readonly)</sup>                 | …                                                                                                           |
| y            | number <sup>(readonly)</sup>                 | …                                                                                                           |

### Methods:

| Name            | Type         | Purpose                                                                                                         |
| --------------- | ------------ | --------------------------------------------------------------------------------------------------------------- |
| isDynamic       | () ⇒ boolean | Returns <b>true</b> if this tile was set dynamically.                                                           |
| restoreOriginal | () ⇒ ()      | Restores the tile's initial state from the start of the battle. Should only be used to restore destroyed walls. |

# AttackOrigin

Is an enumeration.

Indicates the origin of damage (healing) or the Super charge source.

### Constants:

| Name               | Type                          | Purpose                                                                                       |
| ------------------ | ----------------------------- | --------------------------------------------------------------------------------------------- |
| UNKNOWN            | [AttackOrigin](#attackorigin) | …                                                                                             |
| WEAPON             | [AttackOrigin](#attackorigin) | …                                                                                             |
| ULTI               | [AttackOrigin](#attackorigin) | …                                                                                             |
| STAR_POWER         | [AttackOrigin](#attackorigin) | …                                                                                             |
| ACCESSORY          | [AttackOrigin](#attackorigin) | …                                                                                             |
| INCOMING_DAMAGE    | [AttackOrigin](#attackorigin) | Super charge gained from taking damage. Does not apply to damage dealt (or healing provided). |
| OVERCHARGE_ABILITY | [AttackOrigin](#attackorigin) | …                                                                                             |
| MODIFIER           | [AttackOrigin](#attackorigin) | …                                                                                             |
| EXTERNAL           | [AttackOrigin](#attackorigin) | …                                                                                             |
| UNUSED_9           | [AttackOrigin](#attackorigin) | Unused.                                                                                       |
| OVERCHARGE         | [AttackOrigin](#attackorigin) | …                                                                                             |
| GAME_MODE          | [AttackOrigin](#attackorigin) | …                                                                                             |
| NEW_ROUND          | [AttackOrigin](#attackorigin) | Used for damage that kills all characters before the start of a new round.                    |
| PASSIVE_HEALING    | [AttackOrigin](#attackorigin) | …                                                                                             |
| UNUSED_14          | [AttackOrigin](#attackorigin) | Unused.                                                                                       |
| UNUSED_15          | [AttackOrigin](#attackorigin) | Unused.                                                                                       |
| UNUSED_16          | [AttackOrigin](#attackorigin) | Unused.                                                                                       |
| UNUSED_17          | [AttackOrigin](#attackorigin) | Unused.                                                                                       |
| UNUSED_18          | [AttackOrigin](#attackorigin) | Unused.                                                                                       |
| MUTATION           | [AttackOrigin](#attackorigin) | Used by mutations and most special abilities from [Traits](#traits).                          |
| PASSIVE_CHARGING   | [AttackOrigin](#attackorigin) | …                                                                                             |
| BONUS_SKILL        | [AttackOrigin](#attackorigin) | Used by modern gadgets.                                                                       |
| COMPONENT          | [AttackOrigin](#attackorigin) | …                                                                                             |
| UNUSED_23          | [AttackOrigin](#attackorigin) | Unused.                                                                                       |
| REDIRECT_SHIELD    | [AttackOrigin](#attackorigin) | Used for Wendy's shield damage.                                                               |

# CharacterType

Is an enumeration.

…

# TraitType

Is an enumeration.

…

# GameMode

Is an enumeration.

…

# Data

Abstract class. Stores table data (.csv) for a specific object. For example, Wall1 from <i>tiles.csv</i> will be described by its own [TileData](#tiledata) object.

### Constants:

| Name               | Type   | Purpose |
| ------------------ | ------ | ------- |
| TYPE_PROJECTILE    | number | …       |
| TYPE_LOCATION      | number | …       |
| TYPE_CHARACTER     | number | …       |
| TYPE_AREA_EFFECT   | number | …       |
| TYPE_ITEM          | number | …       |
| TYPE_SKILL         | number | …       |
| TYPE_CARD          | number | …       |
| TYPE_TILE          | number | …       |
| TYPE_SKIN          | number | …       |
| TYPE_ACCESSORY     | number | …       |
| TYPE_EMOTE         | number | …       |
| TYPE_SPRAY         | number | …       |
| TYPE_TRAIT         | number | …       |
| TYPE_STATUS_EFFECT | number | …       |

### Methods:

| Name        | Type                             | Purpose                                                                                                                                                                                                                                                                                      |
| ----------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| getIndex    | () ⇒ number                      | Returns its index in the table.                                                                                                                                                                                                                                                              |
| getType     | () ⇒ number                      | Returns the numeric type of its table. Always identical for objects within the same table.                                                                                                                                                                                                   |
| getGlobalId | () ⇒ number                      | Returns its unique ID. Effectively calculated as: <code>(this.getType() * 1000000) + this.getIndex()</code>                                                                                                                                                                                  |
| getName     | () ⇒ string                      | Returns its name (Name).                                                                                                                                                                                                                                                                     |
| isSameAs    | (data: [Data](#data)?) ⇒ boolean | Returns <b>true</b> if the current and specified [Data](#data) describe the same object across different skins. For example, for <i>Brock_def_atk_area</i> and <i>Brock_002_atk_area</i> from <i>area_effects_skin.csv</i>. In essence, checks whether the <i>Logic</i> column values match. |

# GameObjectData

Inherits from [Data](#data).

Abstract class.

# ProjectileData

Inherits from [GameObjectData](#gameobjectdata).

Stores table data for each projectile from <i>projectiles_skin.csv</i> and <i>projectiles_logic.csv</i>.

# CharacterData

Inherits from [GameObjectData](#gameobjectdata).

Stores table data for each character from <i>characters.csv</i>.

# ItemData

Inherits from [GameObjectData](#gameobjectdata).

Stores table data for each item from <i>items.csv</i>.

# AreaEffectData

Inherits from [GameObjectData](#gameobjectdata).

Stores table data for each area of effect (AoE) from <i>area_effects_skin.csv</i> and <i>area_effects_logic.csv</i>.

# TileData

Inherits from [Data](#data).

Stores table data for each tile from <i>tiles.csv</i>.

# SkillData

Inherits from [Data](#data).

Stores table data for each skill from <i>skills.csv</i>.

# LocationData

Inherits from [Data](#data).

Stores table data for each location from <i>locations.csv</i>.

# SkinData

Inherits from [Data](#data).

Stores table data for each skin from <i>skins.csv</i>.

# StatusEffectData

Inherits from [Data](#data).

Stores table data for each effect from <i>status_effects_skin.csv</i> and <i>status_effects_logic.csv</i>.

# AccessoryData

Inherits from [Data](#data).

Stores table data for each gadget from <i>accessories.csv</i>.

# TraitData

Inherits from [Data](#data).

Stores table data for each trait from <i>traits.csv</i>.

# DamageEventListener

Interface. Represents a lambda function.

# SkillEventListener

Interface. Represents a lambda function.

# SourceListener

Interface. Represents a lambda function.

# BasicListener

Interface. Represents a lambda function.

# InputListener

Interface. Represents a lambda function.

# Iterable

Abstract class.

# List

Inherits from [Iterable](#iterable).

Abstract class.

### Methods:

| Name    | Type                     | Purpose                                                                               |
| ------- | ------------------------ | ------------------------------------------------------------------------------------- |
| get     | (index: number) ⇒ any    | Retrieves an object from the list by its index. Indexing starts at <b>zero</b>.       |
| add     | (element: any) ⇒ boolean | Adds an object to the list.                                                           |
| size    | () ⇒ number              | Returns the size of the list.                                                         |
| indexOf | (element: any) ⇒ number  | Returns the index of the object in the list, or <b>-1</b> if the object is not found. |

# ArrayList

Inherits from [List](#list).

A list.

