from __future__ import annotations

import pygame

from leviata.core.clock import FixedStepClock
from leviata.render.camera import Camera
from leviata.world.state import WorldState


class Overlay:
    PANEL_COLOR = (14, 20, 28, 225)
    TEXT_COLOR = (232, 230, 216)
    MUTED_COLOR = (168, 174, 176)

    def __init__(self) -> None:
        self.title_font = pygame.font.Font(None, 32)
        self.body_font = pygame.font.Font(None, 22)

    def draw(
        self,
        surface: pygame.Surface,
        state: WorldState,
        clock: FixedStepClock,
        camera: Camera,
        selected: tuple[int, int] | None,
    ) -> None:
        panel = pygame.Surface((310, surface.get_height()), pygame.SRCALPHA)
        panel.fill(self.PANEL_COLOR)
        surface.blit(panel, (0, 0))

        y = 22
        y = self._line(surface, "LEVIATÃ", 22, y, title=True)
        y = self._line(surface, "M0 — Esqueleto", 22, y, muted=True)
        y += 18
        y = self._line(surface, f"Ano: {self._format_year(state.meta.year)}", 22, y)
        y = self._line(surface, f"Tick: {state.meta.tick}", 22, y)
        status = "PAUSADO" if clock.paused else f"{clock.speed}x"
        y = self._line(surface, f"Tempo: {status}", 22, y)
        y = self._line(surface, f"Semente: {state.meta.seed}", 22, y)
        y = self._line(surface, f"Zoom: {camera.zoom:.2f}x", 22, y)
        y += 18

        y = self._line(surface, "SELEÇÃO", 22, y, title=True)
        if selected is None:
            y = self._line(surface, "Clique em um tile", 22, y, muted=True)
        else:
            tile = state.world_map.tile_at(*selected)
            if tile is None:
                y = self._line(surface, "Fora do mapa", 22, y, muted=True)
            else:
                region = state.world_map.region_by_id(tile.region_id)
                y = self._line(surface, f"Coordenada: {selected[0]}, {selected[1]}", 22, y)
                y = self._line(surface, f"Bioma: {tile.biome.value}", 22, y)
                y = self._line(
                    surface,
                    f"Região: {region.name if region else 'oceano'}",
                    22,
                    y,
                )
                y = self._line(surface, f"Elevação: {tile.elevation:.2f}", 22, y)
                y = self._line(surface, f"Umidade: {tile.moisture:.2f}", 22, y)

        controls = "Espaço pausa · 1/2/3 velocidade · WASD move · roda zoom"
        text = self.body_font.render(controls, True, self.MUTED_COLOR)
        surface.blit(text, (330, surface.get_height() - 34))

    def _line(
        self,
        surface: pygame.Surface,
        text: str,
        x: int,
        y: int,
        *,
        title: bool = False,
        muted: bool = False,
    ) -> int:
        font = self.title_font if title else self.body_font
        color = self.MUTED_COLOR if muted else self.TEXT_COLOR
        rendered = font.render(text, True, color)
        surface.blit(rendered, (x, y))
        return y + rendered.get_height() + 5

    @staticmethod
    def _format_year(year: int) -> str:
        if year < 0:
            return f"{abs(year)} a.C."
        return f"{year} d.C."
