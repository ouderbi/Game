import pytest

from leviata.core.clock import FixedStepClock


def test_fixed_step_clock_accumulates_deterministically() -> None:
    clock = FixedStepClock(tick_seconds=0.25)

    assert clock.consume(0.1) == 0
    assert clock.consume(0.15) == 1
    assert clock.consume(0.5) == 2


def test_pause_and_speed() -> None:
    clock = FixedStepClock(tick_seconds=0.25)
    clock.set_speed(3)

    assert clock.consume(0.25) == 3
    clock.toggle_pause()
    assert clock.consume(10) == 0


def test_clock_rejects_invalid_speed() -> None:
    clock = FixedStepClock(tick_seconds=0.25)

    with pytest.raises(ValueError):
        clock.set_speed(4)
