extends AIController3D

func get_obs() -> Dictionary:
	var obs = Array(_player.sensor_rig.get_observation())
	obs.append(_player.linear_velocity.length() / 100.0)  # keep this local too, not PlayerSettings.speed
	return {"obs": obs}

func get_reward() -> float:
	return reward

func get_action_space() -> Dictionary:
	return {
		"steering": {"size": 1, "action_type": "continuous"},
		"engine": {"size": 1, "action_type": "continuous"},
		"braking": {"size": 1, "action_type": "continuous"},
	}

func set_action(action) -> void:
	print("raw action ", action)
	_player.applyAction(action["steering"][0], action["engine"][0], action["braking"][0])
