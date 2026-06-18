# RL Godot Racer

A 3D racing simulation built in Godot with the long-term goal of training a Reinforcement Learning (RL) agent to drive and race autonomously.

## Project Overview

This project started as a simple racing environment and is gradually evolving into a training ground for reinforcement learning experiments. The idea is to create a realistic enough driving environment where an RL agent can learn vehicle control, track following, and eventually compete against a human player.

## Current Features

### Environment

* Custom racing map
* HDR skybox using a high-quality `.exr` environment texture
* Dynamic lighting and shadows
* Basic racing circuit layout with cone markers

### Vehicle Controls

* **W** – Accelerate
* **A** – Steer Left
* **S** – Brake
* **D** – Steer Right
* **Q** – Reset vehicle position
* **R** – Reverse 

### Gameplay Systems

* Real-time speed tracking
* Session time tracking
* Cone collision detection
* Penalty points awarded when cones are hit
* Visual score and telemetry display

### Visuals

* HDR environment lighting
* Directional sunlight
* Dynamic shadows
* Improved scene depth and realism through environmental lighting

---

## Planned Improvements

### Gameplay

* [ ] Checkpoint system
* [ ] Lap validation using checkpoints
* [ ] Better reset logic
* [ ] Track boundary detection

### Environment

* [ ] Additional 3D assets

  * Buildings
  * Trees
  * Barriers
  * Trackside objects
* [ ] Kerbs along track edges
* [ ] Improved road materials
* [ ] Better terrain detailing

### Vehicle

* [ ] Improved vehicle physics
* [ ] Better tire grip model
* [ ] Suspension tuning
* [ ] Camera improvements

### Reinforcement Learning

* [ ] Observation space design
* [ ] Reward function implementation
* [ ] Checkpoint-based rewards
* [ ] Track completion rewards
* [ ] Collision penalties
* [ ] Training pipeline integration
* [ ] Agent evaluation framework

---

## Long-Term Goal

The ultimate objective of this project is to train a Reinforcement Learning agent that can:

1. Learn basic vehicle control.
2. Follow a racing line around the circuit.
3. Complete laps consistently.
4. Optimize lap times.
5. Race competitively against a human player.

The final vision is to have an AI driver that can share the track with me and continuously improve through training.

---

## Tech Stack

* **Engine:** Godot 4.6.2
* **Language:** GDScript
* **Target AI Framework:** Reinforcement Learning (future integration)

---

## Project Status

🚧 Active Development

Current focus:

1. Implement checkpoints.
2. Improve track visuals and realism.
3. Prepare the environment for RL training.
