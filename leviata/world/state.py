from __future__ import annotations

from dataclasses import dataclass
from enum import StrEnum


class Biome(StrEnum):
    OCEAN = "ocean"
    COAST = "coast"
    PLAINS = "plains"
    FOREST = "forest"
    SAVANNA = "savanna"
    DESERT = "desert"
    TUNDRA = "tundra"
    MOUNTAIN = "mountain"
    SWAMP = "swamp"


@dataclass(frozen=True, slots=True)
class Tile:
    biome: Biome
    elevation: float
    moisture: float
    region_id: int | None


@dataclass(frozen=True, slots=True)
class Region:
    id: int
    name: str
    color: tuple[int, int, int]


@dataclass(frozen=True, slots=True)
class WorldMap:
    width: int
    height: int
    tile_size: int
    tiles: tuple[tuple[Tile, ...], ...]
    regions: tuple[Region, ...]

    @property
    def pixel_width(self) -> int:
        return self.width * self.tile_size

    @property
    def pixel_height(self) -> int:
        return self.height * self.tile_size

    def tile_at(self, x: int, y: int) -> Tile | None:
        if 0 <= x < self.width and 0 <= y < self.height:
            return self.tiles[y][x]
        return None

    def region_by_id(self, region_id: int | None) -> Region | None:
        if region_id is None:
            return None
        return self.regions[region_id]

    def checksum(self) -> int:
        value = 0
        for y, row in enumerate(self.tiles):
            for x, tile in enumerate(row):
                region = tile.region_id if tile.region_id is not None else -1
                tile_value = x * 7 + y * 13 + region * 17 + list(Biome).index(tile.biome)
                value = (value * 31 + tile_value) % (2**31 - 1)
        return value


@dataclass(slots=True)
class WorldMeta:
    seed: int
    tick: int = 0
    year: int = -8000
    ticks_per_year: int = 12
    schema_version: int = 1

    def advance(self) -> None:
        self.tick += 1
        if self.tick % self.ticks_per_year == 0:
            self.year += 1


@dataclass(slots=True)
class WorldState:
    meta: WorldMeta
    world_map: WorldMap
