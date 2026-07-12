from __future__ import annotations

from typing import Final

import pygame

from leviata.render.camera import Camera
from leviata.world.state import Biome, WorldState

BIOME_COLORS: Final[dict[Biome, tuple[int, int, int]]] = {
    Biome.OCEAN: (25, 64, 91),
    Biome.COAST: (43, 102, 132),
    Biome.PLAINS: (130, 151, 83),
    Biome.FOREST: (55, 105, 67),
    Biome.SAVANNA: (169, 149, 78),
    Biome.DESERT: (188, 158, 99),
    Biome.TUNDRA: (171, 183, 177),
    Biome.MOUNTAIN: (100, 96, 91),
    Biome.SWAMP: (70, 105, 82),
}


class WorldRenderer:
    BACKGROUND = (12, 18, 24)

    def draw(
        self,
        surface: pygame.Surface,
        state: WorldState,
        camera: Camera,
        selected: tuple[int, int] | None,
    ) -> None:
        surface.fill(self.BACKGROUND)
        world_map = state.world_map
        left, top, right, bottom = camera.visible_tile_bounds(world_map.width, world_map.height)
        tile_size = max(1, round(camera.scaled_tile_size))

        for y in range(top, bottom):
            for x in range(left, right):
                tile = world_map.tiles[y][x]
                screen_x, screen_y = camera.tile_to_screen(x, y)
                rect = pygame.Rect(screen_x, screen_y, tile_size + 1, tile_size + 1)
                base = BIOME_COLORS[tile.biome]
                color = self._blend_region(base, tile.region_id, state)
                pygame.draw.rect(surface, color, rect)
                self._draw_border(surface, state, camera, x, y, rect)

        if selected is not None and world_map.tile_at(*selected) is not None:
            screen_x, screen_y = camera.tile_to_screen(*selected)
            pygame.draw.rect(
                surface,
                (248, 232, 168),
                pygame.Rect(screen_x, screen_y, tile_size, tile_size),
                max(2, round(camera.zoom * 2)),
            )

    @staticmethod
    def _blend_region(
        base: tuple[int, int, int],
        region_id: int | None,
        state: WorldState,
    ) -> tuple[int, int, int]:
        region = state.world_map.region_by_id(region_id)
        if region is None:
            return base
        return (
            round(base[0] * 0.72 + region.color[0] * 0.28),
            round(base[1] * 0.72 + region.color[1] * 0.28),
            round(base[2] * 0.72 + region.color[2] * 0.28),
        )

    @staticmethod
    def _draw_border(
        surface: pygame.Surface,
        state: WorldState,
        camera: Camera,
        x: int,
        y: int,
        rect: pygame.Rect,
    ) -> None:
        tile = state.world_map.tiles[y][x]
        if tile.region_id is None:
            return
        width = max(1, round(camera.zoom))
        neighbors = (
            (x - 1, y, "left"),
            (x + 1, y, "right"),
            (x, y - 1, "top"),
            (x, y + 1, "bottom"),
        )
        for neighbor_x, neighbor_y, side in neighbors:
            neighbor = state.world_map.tile_at(neighbor_x, neighbor_y)
            if neighbor is not None and neighbor.region_id == tile.region_id:
                continue
            if side == "left":
                points = (rect.topleft, rect.bottomleft)
            elif side == "right":
                points = (rect.topright, rect.bottomright)
            elif side == "top":
                points = (rect.topleft, rect.topright)
            else:
                points = (rect.bottomleft, rect.bottomright)
            pygame.draw.line(surface, (224, 215, 183), *points, width)
