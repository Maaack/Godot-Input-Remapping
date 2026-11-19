@tool
class_name InputActionsDeviceGroups
extends InputActionsList
## Scene to list the input actions out as buttons by input type (keyboard, mouse, gamepad).
const KEYBOARD_AND_MOUSE_DEVICE = "Keyboard & Mouse"
const KEYBOARD_DEVICE =  "Keyboard"
const MOUSE_DEVICE = "Mouse"
const JOYPAD_DEVICE = "Gamepad"

const DEVICE_NAME_INPUT_HELPER_ENUM_MAP : Dictionary[StringName, Array] = {
	InputEventHelper.DEVICE_KEYBOARD : [0, 1],
	InputEventHelper.DEVICE_MOUSE : [0, 2],
	InputEventHelper.DEVICE_JOYPAD : [3],
	InputEventHelper.DEVICE_SCREEN : []
}

@export_enum(KEYBOARD_AND_MOUSE_DEVICE, KEYBOARD_DEVICE, MOUSE_DEVICE, JOYPAD_DEVICE) var action_group_input_devices : Array[int] :
	set(value):
		var _value_changed = action_group_input_devices != value
		action_group_input_devices = value
		if _value_changed:
			_refresh_action_group_names()

func _refresh_action_group_names() -> void:
	action_groups = action_group_input_devices.size()
	action_group_names.clear()
	for input_device_enum in action_group_input_devices:
		var group_name : String
		match(input_device_enum):
			0:
				group_name = KEYBOARD_AND_MOUSE_DEVICE
			1:
				group_name = KEYBOARD_DEVICE
			2:
				group_name = MOUSE_DEVICE
			3:
				group_name = JOYPAD_DEVICE
		action_group_names.append(group_name)

func _get_event_device_group(input_event : InputEvent) -> int:
	var device_name = InputEventHelper.get_input_device_name(input_event)
	var matching_enums = DEVICE_NAME_INPUT_HELPER_ENUM_MAP[device_name]
	for matching_enum in matching_enums:
		if matching_enum in action_group_input_devices:
			return action_group_input_devices.find(matching_enum)
	return -1

func _assign_input_event_to_action_group(input_event : InputEvent, action_name : String, action_group : int) -> void:
	_assign_input_event(input_event, action_name)
	var action_events := InputMap.action_get_events(action_name)
	action_events.resize(action_events.size() + 1)
	action_events[action_group] = input_event
	InputMap.action_erase_events(action_name)
	var final_action_events : Array[InputEvent]
	for input_action_event in action_events:
		if input_action_event == null: continue
		final_action_events.append(input_action_event)
		InputMap.action_add_event(action_name, input_action_event)
	AppSettings.set_config_input_events(action_name, final_action_events)
	action_group = _get_event_device_group(input_event)
	_update_assigned_inputs_and_button(action_name, action_group, input_event)

func _refresh_ui_list_button_content() -> void:
	var action_names : Array[StringName] = _get_all_action_names(show_built_in_actions)
	for action_name in action_names:
		var input_events := InputMap.action_get_events(action_name)
		if input_events.size() < 1:
			continue
		for input_event in input_events:
			var action_group = _get_event_device_group(input_event)
			_update_assigned_inputs_and_button(action_name, action_group, input_event)
			_update_next_button_disabled_state(action_name, action_group)

func _get_input_event_action_group(input_event: InputEvent, _input_events: Array[InputEvent]) -> int:
	return _get_event_device_group(input_event)

func _connect_button_and_add_to_maps(button : Button, input_name : String, action_name : String, group_iter : int) -> void:
	button.pressed.connect(_on_button_pressed.bind(action_name, group_iter))
	button_readable_input_map[button] = input_name
	_add_to_action_button_map(action_name, group_iter, button)
