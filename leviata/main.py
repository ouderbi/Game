from __future__ import annotations

import argparse
from collections.abc import Sequence

from leviata.app import GameApp, run_headless


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Leviatã grand-strategy prototype")
    parser.add_argument("--seed", type=int, default=1729, help="world generation seed")
    parser.add_argument("--headless", action="store_true", help="run without opening a window")
    parser.add_argument("--ticks", type=int, default=1000, help="ticks to run in headless mode")
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    if args.headless:
        result = run_headless(seed=args.seed, ticks=args.ticks)
        print(
            f"seed={result.seed} ticks={result.tick} year={result.year} checksum={result.checksum}"
        )
        return 0

    GameApp(seed=args.seed).run()
    return 0
