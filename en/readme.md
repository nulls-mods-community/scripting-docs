# NB Scripting

#### Telegram channel: [@danyanull](https://t.me/danyanull)

NB Scripting is a technology that enables users to create and use custom scripts in Null’s Brawl battles.
## How does it work?

When each battle starts, the server checks if any custom scripts are set for it. If so, they are loaded.

Loaded scripts can only access their own battle. For more details on how we isolate scripts, see the [Security](#security) section.

Each script must define a global function `tick()`, which will be called on every game tick.

Scripts can also subscribe to various events, such as when a specific character takes damage.

When the battle ends, the scripts are destroyed.

## Programming language

Scripts are written in Lua. Currently, [Luau](https://luau.org) is used as the primary interpreter.

The behavior of Luau may differ in some aspects from standard Lua expectations. You can read more about this here: https://luau.org/compatibility/.

## Available API

Important note: Our battle server is written in Java. Because of this, our API is built on top of Java objects.

In Lua, each of these objects is represented as *userdata*, not a *table*. You cannot create such objects by yourself — you can only obtain them through our API.

Every Java object belongs to a class that determines its available fields and methods. A full list of classes can be found in a separate document: [API Reference](en/reference.md).

Every script has access to an object of the [Server](en/reference.md#server) class. This object exists as a single instance and is the main entry point to our API. It is available through the global variable **server**.

### Primary actions with Java objects

You can get and set fields just as you would with a regular Lua table:

```lua
clientInfo.ultiCharge = math.min(server.tick, clientInfo.maxUltiCharge)
```

Keep in mind that if a field is marked as readonly, attempting to modify it will not throw an error, but the value will not be changed either.

You can call the available methods with a colon operator:

```lua
clientInfo = server:getClientInfo(0)
```

For objects of the Iterable class and its descendants (List, ArrayList), you can use a for loop:

```lua
for i, character in server.objectManager:getCharacters() do
    ...
end
```

### Static fields of Java classes

Some classes in Java may implement **static** fields and methods. They differ from regular ones in that their behavior is not tied to any specific object. In most cases, such fields are used for constants, and the methods are used for helper functions.

For each Java class, a corresponding table is created in Lua, accessible as a global variable with the same name. For example, `AttackOrigin` or `LogicCharacter`.

This table is not a class, but it stores a **copy** of its static fields and methods.

That is especially relevant for enums, such as [AttackOrigin](en/reference.md#attackorigin) or [GameMode](en/reference.md#attackorigin). Objects of these classes are always constant and are stored as their static fields.

Usage example:
```lua
if server.gameMode ~= GameMode.GEM_GRAB then
    character:takeHeal(character.index, 4000, true, nil, AttackOrigin.WEAPON)
end
```

Please note: if a class has no accessible static fields or methods, the table will still be created and will be empty.

### Helper functions

Our API provides several helper functions. They do not interact directly with the server's Java code, but they allow you to create or access certain objects.

| Name           | Type                                    | Usage                                                                                  |
| :------------- | :-------------------------------------- | :------------------------------------------------------------------------------------- |
| lookup         | (subtype: number, name: string) ⇒ Data  | Allows you to get a `Data` object by its type and name.                                |
| createObject   | (data: Data) ⇒ LogicGameObject          | Allows you to create a new `LogicGameObject` instance for a specific `Data`.           |
| createCallback | (class: string, arg: function) ⇒ Object | Allows you to convert a Lua function into a Java object. Used for event subscriptions. |
| log            | (params: string...) ⇒ void              | Prints a message to the debug logs and to the friendly room chat, if applicable.       |
| event          | (action: string, data: table) ⇒ void    | Sends an event to the client.                                                          |

These functions are available globally.

### Standard Lua library

The Luau interpreter's standard library is available: https://luau.org/library/.

### Working with JSON

A library for working with JSON is globally available to every script: https://github.com/rxi/json.lua

An example:

```lua
local values = {}
values.key = "value"
log(json.encode(values))
```

### Inheritance and polymorphism

Some classes in Java can be abstract. Such classes cannot have instances. They are used to generalize several descendant classes into one type with shared fields or methods.

For example, [LogicGameObject](en/reference.md#logicgameobject) is an abstract class. When you call `createObject()` or `objectManager:getObject()`, you will actually receive an instance of one of its children: [LogicCharacter](en/reference.md#logiccharacter), [LogicItem](en/reference.md#logicitem),
[LogicProjectile](en/reference.md#logicprojectile) or [LogicAreaEffect](en/reference.md#logicareaeffect).


It works both ways: `objectManager:addObject()` will accept any of those child classes as an argument.

Moreover, this works not only with abstract classes. In Java, you can always pass or return an object of a child class, even if an object of a parent class is expected. However, there are currently no examples of such classes in the available API.

Additionally, it is worth considering Iterable, List, and ArrayList. ArrayList is a subclass of the abstract class List, which in turn inherits from the abstract class Iterable. Within the available API, no other subclasses of List or Iterable are used, meaning that if you see Iterable or List, it is always an ArrayList.

### Event subscriptions

Let’s examine [LogicCharacter](en/reference.md#logiccharacter) and its **takingDamageListeners** field. This is a list of subscriptions to the event of taking damage.

This list is presented as an ArrayList class. In other words, this is a Java object that stores **other** Java objects inside it. We cannot add an arbitrary Lua function to this list.

This is why `createCallback()` exists. Its usage looks like this:

```lua
local callback = function(target, projectile, damage, someData, origin)
    ...
end

local callbackImpl = createCallback("DamageEventListener", callback)
character.takingDamageListeners:add(callbackImpl)
```

Using this function, we have converted a Lua function into a Java DamageEventListener object, making it ready to be added to the list. Amazing!

Note: If you call `createCallback()` twice with the same function, it will return two different objects. Keep this in mind if you want to check for an event subscription using `takingDamageListeners:indexOf()`.

At the moment, the following classes are supported:

| Name                | Type                                                                                                                              |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| DamageEventListener | (source: LogicCharacter,<br/>projectile: LogicProjectile, <br/>damage: number,<br/> data: Data,<br/> origin: AttackOrigin) ⇒ void |
| SkillEventListener  | (skill: Skill) ⇒ void                                                                                                             |
| SourceListener      | (origin: AttackOrigin) ⇒ void                                                                                                     |
| BasicListener       | () ⇒ void                                                                                                                         |
| InputListener       | (index: number, spec0: number, spec1: number) ⇒ void                                                                              |

## Security

Each individual script is executed in its own isolated sandbox, with no access to system APIs. You can only work with the objects provided by the NB Scripting API, as well as some safe functions from the standard library.

Each script has a memory and a CPU Time quota. A script can be unloaded at any moment if the quota is exceeded.

| Resource | Base Quota                                                          |
| -------- | ------------------------------------------------------------------- |
| CPU Time | No more than 15 milliseconds of real time per single Lua code call. |
| Memory   | No more than 16 MiB for the entire script, excluding Java objects.  |

## Trivia

In Brawl Stars, the simulation of game logic takes place on the server at a rate of 20 ticks per second.

### Main tables with game data

| Type | File(s)                                           | Class                                             |
| ---- | ------------------------------------------------- | ------------------------------------------------- |
| 6    | projectiles_skin.csv, projectiles_logic.csv       | [ProjectileData](en/reference.md#projectiledata)  |
| 15   | locations.csv                                     | [LocationData](en/reference.md#locationdata)      |
| 16   | characters.csv                                    | [CharacterData](en/reference.md#characterdata)    |
| 17   | area_effects_skin.csv, area_effects_logic.csv     | [AreaEffectData](en/reference.md#areaeffectdata)  |
| 18   | items.csv                                         | [ItemData](en/reference.md#itemdata)              |
| 20   | skills.csv                                        | [SkillData](en/reference.md#skilldata)            |
| 23   | cards.csv                                         |                                                   |
| 27   | tiles.csv                                         | [TileData](en/reference.md#tiledata)              |
| 29   | skins.csv                                         | [SkinData](en/reference.md#skindata)              |
| 50   | accessories.csv                                   | [AccessoryData](en/reference.md#accessorydata)    |
| 52   | emotes.csv                                        |                                                   |
| 68   | sprays.csv                                        |                                                   |
| 108  | traits.csv                                        | [TraitData](en/reference.md#traitdata)            |
| 117  | status_effects_skin.csv, status_effects_logic.csv | [StatusEffectData](en/reference.md#statuseffectdata) |
