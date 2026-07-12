from __future__ import annotations

from dataclasses import dataclass

from leviata.world.state import WorldState


@dataclass(slots=True)
class Simulation:
    state: WorldState

    def tick(self) -> None:
        self.state.meta.advance()
