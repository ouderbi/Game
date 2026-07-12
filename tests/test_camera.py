import pytest

from leviata.render.camera import Camera


def test_camera_round_trip_to_tile() -> None:
    camera = Camera(x=48, y=24, viewport_width=800, viewport_height=600)

    point = camera.tile_to_screen(5, 3)

    assert camera.screen_to_tile(point) == (5, 3)


def test_zoom_keeps_anchor_in_place() -> None:
    camera = Camera(x=100, y=50, viewport_width=800, viewport_height=600)
    anchor = (400, 300)
    before = camera.screen_to_world(anchor)

    camera.zoom_at(1, anchor)

    assert camera.screen_to_world(anchor) == pytest.approx(before)
