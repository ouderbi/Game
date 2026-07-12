from __future__ import annotations

from dataclasses import dataclass

from leviata.core.clock import FixedStepClock
from leviata.core.sim import Simulation
from leviata.render.camera import Camera
from leviata.world.generation import generate_world


@dataclass(frozen=True, slots=True)
class HeadlessResult:
    seed: int
    tick: int
    year: int
    checksum: int


def run_headless(seed: int, ticks: int) -> HeadlessResult:
    if ticks < 0:
        raise ValueError("ticks must be non-negative")

    simulation = Simulation(generate_world(seed=seed))
    for _ in range(ticks):
        simulation.tick()
    state = simulation.state
    return HeadlessResult(
        seed=state.meta.seed,
        tick=state.meta.tick,
        year=state.meta.year,
        checksum=state.world_map.checksum(),
    )


class GameApp:
    WINDOW_SIZE = (1280, 720)
    TARGET_FPS = 60

    def __init__(self, seed: int) -> None:
        self.seed = seed

    def run(self) -> None:
        import pygame

        from leviata.render.renderer import WorldRenderer
        from leviata.ui.overlay import Overlay

        pygame.init()
        pygame.display.set_caption("Leviatã — M0")
        screen = pygame.display.set_mode(self.WINDOW_SIZE, pygame.RESIZABLE)
        frame_clock = pygame.time.Clock()

        simulation = Simulation(generate_world(seed=self.seed))
        sim_clock = FixedStepClock(tick_seconds=0.25)
        camera = Camera.centered_on(
            simulation.state.world_map.pixel_width,
            simulation.state.world_map.pixel_height,
            *screen.get_size(),
        )
        renderer = WorldRenderer()
        overlay = Overlay()
        selected: tuple[int, int] | None = None
        dragging = False
        running = True

        while running:
            elapsed = frame_clock.tick(self.TARGET_FPS) / 1000.0
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.VIDEORESIZE:
                    screen = pygame.display.set_mode(event.size, pygame.RESIZABLE)
                    camera.set_viewport(*event.size)
                elif event.type == pygame.KEYDOWN:
                    running = self._handle_key(event.key, sim_clock, camera)
                elif event.type == pygame.MOUSEWHEEL:
                    camera.zoom_at(event.y, pygame.mouse.get_pos())
                elif event.type == pygame.MOUSEBUTTONDOWN:
                    if event.button == 1:
                        selected = camera.screen_to_tile(event.pos)
                    elif event.button == 3:
                        dragging = True
                elif event.type == pygame.MOUSEBUTTONUP and event.button == 3:
                    dragging = False
                elif event.type == pygame.MOUSEMOTION and dragging:
                    camera.pan(-event.rel[0], -event.rel[1])

            self._pan_with_keyboard(camera, elapsed)
            for _ in range(sim_clock.consume(elapsed)):
                simulation.tick()

            renderer.draw(screen, simulation.state, camera, selected)
            overlay.draw(screen, simulation.state, sim_clock, camera, selected)
            pygame.display.flip()

        pygame.quit()

    @staticmethod
    def _handle_key(key: int, clock: FixedStepClock, camera: Camera) -> bool:
        import pygame

        if key == pygame.K_ESCAPE:
            return False
        if key == pygame.K_SPACE:
            clock.toggle_pause()
        elif key in (pygame.K_1, pygame.K_2, pygame.K_3):
            clock.set_speed(key - pygame.K_0)
        elif key == pygame.K_r:
            camera.reset()
        return True

    @staticmethod
    def _pan_with_keyboard(camera: Camera, elapsed: float) -> None:
        import pygame

        keys = pygame.key.get_pressed()
        horizontal = int(keys[pygame.K_d] or keys[pygame.K_RIGHT]) - int(
            keys[pygame.K_a] or keys[pygame.K_LEFT]
        )
        vertical = int(keys[pygame.K_s] or keys[pygame.K_DOWN]) - int(
            keys[pygame.K_w] or keys[pygame.K_UP]
        )
        camera.pan(horizontal * 650 * elapsed, vertical * 650 * elapsed)
