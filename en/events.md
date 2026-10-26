# Events

For communication with the external environment, an **event** mechanism is used. Every dispatched event is handled by the main (lobby) server and, when applicable, the game client.

There is a limit of 20 events per second. If the limit is exceeded, the events will be placed in a queue. Once the queue reaches 30 events, new events will be dropped.

Events are serialized into JSON objects. Their structure is arbitrary and depends on the type, but some fields are shared:

| Name             | Type    | Purpose                                                                                 |
| ---------------- | ------- | --------------------------------------------------------------------------------------- |
| **target_index** | integer | If specified: deliver the event only to the player (ClientInfo) with the given _index_  |
| **target_team**  | integer | If specified: deliver the event only to the players (ClientInfo) with the given _team_  |
| **delay**        | float   | If specified: execute the action with a delay (after the specified number of seconds)   |

## “updateUIItem”

Handled by the client. Creates a UI element with the specified ID: a button, window, text, and so on. If an element with the given ID already exists, it will be updated without being recreated.

Elements are created from an existing TOML configuration (.ui file) and belong to the *TomlClipInstance* class. You can perform additional actions (set text, play an animation, or assign a callback to a button) using the properties of this event.

Properties:

| Name                             | Type                                     | Purpose                                                         |
| -------------------------------- | ---------------------------------------- | --------------------------------------------------------------- |
| **id** <sup>(required)</sup>     | integer                                  | Unique ID of this element                                       |
| **tomlId** <sup>(required)</sup> | string                                   | TOML ID                                                         |
| **animation**                    | string                                   | If specified: plays an animation by its name                    |
| **x**, **y**                     | float                                    | If specified: sets the position of an element on the screen     |
| **texts**                        | array of { binding, text }               | Sets the text for the specified text fields (by their bindings) |
| **buttons**                      | array of { binding, client_input_value } | Sets the callback for the specified buttons (by their bindings) |

Usage example:

```lua
event("updateUIItem", {
    tomlId = "nt_button_blue",
    id = 10,
    x = 300.0,
    y = 300.0,
    texts = {
        { binding = "txt", text = "Click!" }
    },
    buttons = {
        { binding = "button", client_input_value = 20 }
    }
})
```

## “removeUIItem”

Handled by the client. Deletes a UI element by its ID.

Properties:

| Name                         | Type    | Purpose                   |
| ---------------------------- | ------- | ------------------------- |
| **id** <sup>(required)</sup> | integer | Unique ID of this element |

Usage example:

```lua
event("removeUIItem", {
    id = 10
})
```

## “scheduleTasks”

Handled by the client. Allows you to schedule multiple tasks at once.

Properties:

| Name                            | Type  | Purpose             |
| ------------------------------- | ----- | ------------------- |
| **tasks** <sup>(required)</sup> | array | An array of events. |

Each event in the **tasks** array must have an **action** field (string) that specifies its type. Target filtering (via the **target_index** and **target_team** fields) is unsupported for internal events.

Usage example:

```lua
-- Spawn tutorial shelly popup and schedule its removal in 5 seconds
event("scheduleTasks", {
    tasks = {
        {
            action = "updateUIItem",
            tomlId = "nt_tutorial",
            id = 42,
            x = 300.0,
            y = 100.0,
            animation = "appear",
            texts = { { binding = "txt", "text" = "Hi there!" } }
        },
        {
            action = "removeUIItem",
            id = 42,
            delay = 5.0
        }
    },
    target_team = 0
})
```
