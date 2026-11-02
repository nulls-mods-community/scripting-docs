--- Lua-функция для представления DamageEventListener.
export type DamageEventCallback = (source: LogicCharacter?, projectile: LogicProjectile?, damage: number, data: Data?, origin: AttackOrigin) -> ()

--- Lua-функция для представления SkillEventListener.
export type SkillEventCallback = (skill: Skill) -> ()

--- Lua-функция для представления SourceListener.
export type SourceCallback = (origin: AttackOrigin) -> ()

--- Lua-функция для представления BasicListener.
export type BasicCallback = () -> ()

--- Lua-функция для представления InputListener.
export type InputCallback = (index: number, spec0: number, spec1: number) -> ()

type createCallback0 = (class: "DamageEventListener", callback: DamageEventCallback) -> DamageEventListener
type createCallback1 = (class: "SkillEventListener", callback: SkillEventCallback) -> SkillEventListener
type createCallback2 = (class: "SourceListener", callback: SourceCallback) -> SourceListener
type createCallback3 = (class: "BasicListener", callback: BasicCallback) -> BasicListener
type createCallback4 = (class: "InputListener", callback: InputCallback) -> InputListener

export type Text = {binding: string, text: string, [any]: never}
export type Button = {binding: string, client_input_value: number, [any]: never}
export type Task = {action: "updateUIItem" | "removeUIItem", id: number, tomlId: string?, animation: string?, x: number?, y: number?, texts: { Text }?, buttons: { Button }?, delay: number?, [any]: never}

type event0 = (action: "updateUIItem", data: {id: number, tomlId: string, animation: string?, x: number?, y: number?, texts: { Text }?, buttons: { Button }?, target_index: number?, target_team: number?, delay: number?, [any]: never}) -> ()
type event1 = (action: "removeUIItem", data: {id: number, target_index: number?, target_team: number?, delay: number?, tomlId: nil, animation: nil, x: nil, y: nil, texts: nil, buttons: nil, [any]: never}) -> ()
type event2 = (action: "scheduleTasks", data: {tasks: { Task }, target_index: number?, target_team: number?, delay: number?, id: nil, tomlId: nil, animation: nil, x: nil, y: nil, texts: nil, buttons: nil, [any]: never}) -> ()

--- Глобальный экземпляр класса Server.
declare server: Server

--- Ищет табличные данные (Data) по типу таблицы и имени.
declare lookup: <T>(subtype: number, name: string) -> (T & Data)

--- Создаёт LogicGameObject из соответствующего Data.
declare createObject: <T>(data: Data) -> (T & LogicGameObject)

--- Преобразует Lua-функцию в Java-объект (лямбду) соответствующего класса.
declare createCallback: createCallback0 & createCallback1 & createCallback2 & createCallback3 & createCallback4

--- Печатает строки в отладочные журналы и (если применимо) в чат дружеской комнаты.
declare function log(...: any): ()

--- Отправляет событие на клиент.
declare event: event0 & event1 & event2

--- Глобально доступная библиотека `rxi/json.lua` для кодирования и декодирования JSON.
declare json: {
    --- Кодирует поддерживаемое Lua-значение в JSON.
    encode: (value: any) -> string,
    --- Декодирует JSON-строку в Lua-значение.
    decode: (value: string) -> any,
}
