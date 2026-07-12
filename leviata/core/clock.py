from __future__ import annotations

from dataclasses import dataclass, field


@dataclass(slots=True)
class FixedStepClock:
    tick_seconds: float
    speed: int = 1
    paused: bool = False
    _accumulator: float = field(default=0.0, init=False)

    def __post_init__(self) -> None:
        if self.tick_seconds <= 0:
            raise ValueError("tick_seconds must be positive")
        self.set_speed(self.speed)

    def consume(self, elapsed_seconds: float) -> int:
        if elapsed_seconds < 0:
            raise ValueError("elapsed_seconds must be non-negative")
        if self.paused:
            return 0

        self._accumulator += elapsed_seconds * self.speed
        ticks = int(self._accumulator / self.tick_seconds)
        self._accumulator -= ticks * self.tick_seconds
        return ticks

    def toggle_pause(self) -> None:
        self.paused = not self.paused

    def set_speed(self, speed: int) -> None:
        if speed not in (1, 2, 3):
            raise ValueError("speed must be 1, 2, or 3")
        self.speed = speed
