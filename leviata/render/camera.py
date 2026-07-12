from __future__ import annotations

from dataclasses import dataclass, field


@dataclass(slots=True)
class Camera:
    x: float
    y: float
    viewport_width: int
    viewport_height: int
    tile_size: int = 24
    zoom: float = 1.0
    min_zoom: float = 0.35
    max_zoom: float = 3.0
    _initial: tuple[float, float, float] = field(init=False)

    def __post_init__(self) -> None:
        self._initial = (self.x, self.y, self.zoom)

    @classmethod
    def centered_on(
        cls,
        world_width: int,
        world_height: int,
        viewport_width: int,
        viewport_height: int,
    ) -> Camera:
        return cls(
            x=(world_width - viewport_width) / 2,
            y=(world_height - viewport_height) / 2,
            viewport_width=viewport_width,
            viewport_height=viewport_height,
        )

    @property
    def scaled_tile_size(self) -> float:
        return self.tile_size * self.zoom

    def set_viewport(self, width: int, height: int) -> None:
        self.viewport_width = width
        self.viewport_height = height

    def pan(self, dx: float, dy: float) -> None:
        self.x += dx / self.zoom
        self.y += dy / self.zoom

    def zoom_at(self, direction: int, anchor: tuple[int, int]) -> None:
        if direction == 0:
            return
        world_anchor = self.screen_to_world(anchor)
        factor = 1.16 if direction > 0 else 1 / 1.16
        self.zoom = max(self.min_zoom, min(self.max_zoom, self.zoom * factor))
        self.x = world_anchor[0] - anchor[0] / self.zoom
        self.y = world_anchor[1] - anchor[1] / self.zoom

    def screen_to_world(self, point: tuple[int, int]) -> tuple[float, float]:
        return self.x + point[0] / self.zoom, self.y + point[1] / self.zoom

    def screen_to_tile(self, point: tuple[int, int]) -> tuple[int, int]:
        world_x, world_y = self.screen_to_world(point)
        return int(world_x // self.tile_size), int(world_y // self.tile_size)

    def tile_to_screen(self, x: int, y: int) -> tuple[int, int]:
        return (
            round((x * self.tile_size - self.x) * self.zoom),
            round((y * self.tile_size - self.y) * self.zoom),
        )

    def visible_tile_bounds(self, map_width: int, map_height: int) -> tuple[int, int, int, int]:
        left = max(0, int(self.x // self.tile_size) - 1)
        top = max(0, int(self.y // self.tile_size) - 1)
        right = min(
            map_width,
            int((self.x + self.viewport_width / self.zoom) // self.tile_size) + 2,
        )
        bottom = min(
            map_height,
            int((self.y + self.viewport_height / self.zoom) // self.tile_size) + 2,
        )
        return left, top, right, bottom

    def reset(self) -> None:
        self.x, self.y, self.zoom = self._initial
