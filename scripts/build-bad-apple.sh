#!/usr/bin/env bash
# Rebuild the profile README Bad Apple GIFs from a local copy of the original PV.
# Source: Nico Nico Douga sm8628149 / archive.org item bad-apple-resources (480x360, 30fps).
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
src="${1:-}"
if [[ -z "$src" || ! -f "$src" ]]; then
  echo "usage: $0 /path/to/bad_apple.mp4" >&2
  exit 1
fi

mkdir -p "$root/assets"
vf_base="fps=12,scale=480:360:flags=lanczos,hue=s=0,eq=contrast=100"
vf_gif="format=rgb24,split[s0][s1];[s0]palettegen=max_colors=2:reserve_transparent=0:stats_mode=full[p];[s1][p]paletteuse=dither=none"

ffmpeg -y -i "$src" -vf "${vf_base},${vf_gif}" -loop 0 "$root/assets/bad-apple.gif"
ffmpeg -y -i "$src" -vf "${vf_base},negate,${vf_gif}" -loop 0 "$root/assets/bad-apple-light.gif"
ls -lh "$root/assets/bad-apple.gif" "$root/assets/bad-apple-light.gif"
