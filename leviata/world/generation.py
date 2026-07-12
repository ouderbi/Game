from __future__ import annotations

import math
import random
from dataclasses import dataclass

from leviata.world.state import Biome, Region, Tile, WorldMap, WorldMeta, WorldState


@dataclass(frozen=True, slots=True)
class WorldGenerationConfig:
    width: int = 96
    height: int = 54
    tile_size: int = 24
    region_count: int = 6
    sea_level: float = 0.43


DEFAULT_CONFIG = WorldGenerationConfig()


def generate_world(
    seed: int,
    config: WorldGenerationConfig = DEFAULT_CONFIG,
) -> WorldState:
    if config.width < 8 or config.height < 8:
        raise ValueError("world dimensions must be at least 8x8")
    if config.region_count < 1:
        raise ValueError("region_count must be positive")

    rng = random.Random(seed)
    phases = tuple(rng.uniform(0, math.tau) for _ in range(8))
    elevations = _field(config.width, config.height, phases[:4], latitude_bias=True)
    moisture = _field(config.width, config.height, phases[4:], latitude_bias=False)
    centers = _region_centers(elevations, config, rng)
    regions = tuple(
        Region(id=index, name=f"Polity {index + 1}", color=_region_color(index))
        for index in range(len(centers))
    )

    tiles: list[tuple[Tile, ...]] = []
    for y in range(config.height):
        row: list[Tile] = []
        for x in range(config.width):
            elevation = elevations[y][x]
            wetness = moisture[y][x]
            region_id = (
                _nearest_region(x, y, centers, config.width)
                if elevation >= config.sea_level
                else None
            )
            row.append(
                Tile(
                    biome=_classify_biome(
                        elevation,
                        wetness,
                        y / max(config.height - 1, 1),
                        config.sea_level,
                    ),
                    elevation=elevation,
                    moisture=wetness,
                    region_id=region_id,
                )
            )
        tiles.append(tuple(row))

    world_map = WorldMap(
        width=config.width,
        height=config.height,
        tile_size=config.tile_size,
        tiles=tuple(tiles),
        regions=regions,
    )
    return WorldState(meta=WorldMeta(seed=seed), world_map=world_map)


def _field(
    width: int,
    height: int,
    phases: tuple[float, ...],
    *,
    latitude_bias: bool,
) -> list[list[float]]:
    values: list[list[float]] = []
    for y in range(height):
        row: list[float] = []
        normalized_y = y / max(height - 1, 1)
        for x in range(width):
            normalized_x = x / max(width - 1, 1)
            value = (
                math.sin(normalized_x * math.tau * 1.3 + phases[0])
                + math.cos(normalized_y * math.tau * 1.7 + phases[1])
                + 0.55 * math.sin((normalized_x + normalized_y) * math.tau * 3.1 + phases[2])
                + 0.3 * math.cos((normalized_x - normalized_y) * math.tau * 5.3 + phases[3])
            )
            normalized = (value + 2.85) / 5.7
            if latitude_bias:
                normalized -= abs(normalized_y - 0.5) * 0.16
            row.append(max(0.0, min(1.0, normalized)))
        values.append(row)
    return values


def _region_centers(
    elevations: list[list[float]],
    config: WorldGenerationConfig,
    rng: random.Random,
) -> tuple[tuple[int, int], ...]:
    land = [
        (x, y)
        for y, row in enumerate(elevations)
        for x, elevation in enumerate(row)
        if elevation >= config.sea_level
    ]
    if not land:
        raise ValueError("generation produced no land")

    first = rng.choice(land)
    centers = [first]
    while len(centers) < min(config.region_count, len(land)):
        ranked = sorted(
            land,
            key=lambda point: min(
                _wrapped_distance_squared(point, center, config.width) for center in centers
            ),
            reverse=True,
        )
        candidate_pool = ranked[: max(1, len(ranked) // 8)]
        candidate = rng.choice(candidate_pool)
        if candidate not in centers:
            centers.append(candidate)
    return tuple(centers)


def _nearest_region(
    x: int,
    y: int,
    centers: tuple[tuple[int, int], ...],
    world_width: int,
) -> int:
    return min(
        range(len(centers)),
        key=lambda index: _wrapped_distance_squared((x, y), centers[index], world_width),
    )


def _wrapped_distance_squared(
    point: tuple[int, int],
    center: tuple[int, int],
    world_width: int,
) -> int:
    dx = abs(point[0] - center[0])
    dx = min(dx, world_width - dx)
    dy = point[1] - center[1]
    return dx * dx + dy * dy


def _classify_biome(
    elevation: float,
    moisture: float,
    latitude: float,
    sea_level: float,
) -> Biome:
    if elevation < sea_level - 0.04:
        return Biome.OCEAN
    if elevation < sea_level:
        return Biome.COAST
    if elevation > 0.78:
        return Biome.MOUNTAIN
    polar_distance = abs(latitude - 0.5) * 2
    if polar_distance > 0.82:
        return Biome.TUNDRA
    if moisture > 0.72 and elevation < 0.55:
        return Biome.SWAMP
    if moisture > 0.6:
        return Biome.FOREST
    if moisture < 0.3:
        return Biome.DESERT
    if moisture < 0.43:
        return Biome.SAVANNA
    return Biome.PLAINS


def _region_color(index: int) -> tuple[int, int, int]:
    palette = (
        (201, 80, 83),
        (79, 140, 201),
        (222, 172, 65),
        (98, 171, 116),
        (153, 101, 191),
        (211, 116, 64),
        (78, 178, 173),
        (188, 90, 148),
    )
    return palette[index % len(palette)]
