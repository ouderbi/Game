from leviata.app import run_headless
from leviata.world.generation import WorldGenerationConfig, generate_world
from leviata.world.state import Biome

SMALL_WORLD = WorldGenerationConfig(width=24, height=16, region_count=4)


def test_world_generation_is_deterministic() -> None:
    first = generate_world(42, SMALL_WORLD)
    second = generate_world(42, SMALL_WORLD)

    assert first.world_map == second.world_map
    assert first.world_map.checksum() == second.world_map.checksum()


def test_different_seeds_create_different_worlds() -> None:
    first = generate_world(42, SMALL_WORLD)
    second = generate_world(43, SMALL_WORLD)

    assert first.world_map.checksum() != second.world_map.checksum()


def test_world_contains_land_ocean_and_regions() -> None:
    state = generate_world(42, SMALL_WORLD)
    biomes = {tile.biome for row in state.world_map.tiles for tile in row}
    region_ids = {
        tile.region_id
        for row in state.world_map.tiles
        for tile in row
        if tile.region_id is not None
    }

    assert Biome.OCEAN in biomes
    assert len(region_ids) == SMALL_WORLD.region_count


def test_headless_simulation_advances_time() -> None:
    result = run_headless(seed=42, ticks=24)

    assert result.tick == 24
    assert result.year == -7998
