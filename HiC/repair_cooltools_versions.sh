#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: repair_cooltools_versions.sh [--dry-run] [WORK_DIR]

Repair malformed COOLTOOLS_INSULATION versions.yml files produced by
nf-core/hic 2.1.0. WORK_DIR defaults to ./work.

The script only repairs files with this exact structure:

  "NFCORE_HIC:HIC:TADS:COOLTOOLS_INSULATION":
      cooltools: Matplotlib created a temporary config/cache directory ...
  VERSION

Each changed file is backed up as versions.yml.before_cooltools_repair.
Existing backups are not overwritten.
EOF
}

dry_run=false

if [[ ${1:-} == "--dry-run" ]]; then
    dry_run=true
    shift
elif [[ ${1:-} == "--help" || ${1:-} == "-h" ]]; then
    usage
    exit 0
fi

work_dir=${1:-work}

if [[ $# -gt 1 ]]; then
    usage >&2
    exit 2
fi

if [[ ! -d $work_dir ]]; then
    printf 'ERROR: Work directory does not exist: %s\n' "$work_dir" >&2
    exit 1
fi

header='"NFCORE_HIC:HIC:TADS:COOLTOOLS_INSULATION":'
matched=0
repaired=0
skipped_backup=0

while IFS= read -r file; do
    line_1=$(sed -n '1p' "$file")
    line_2=$(sed -n '2p' "$file")
    line_3=$(sed -n '3p' "$file")
    line_4=$(sed -n '4p' "$file")

    [[ $line_1 == "$header" ]] || continue
    [[ $line_2 == "    cooltools: Matplotlib created a temporary config/cache directory"* ]] || continue
    [[ $line_3 =~ ^[0-9]+([.][0-9]+)+([+-][A-Za-z0-9._-]+)?$ ]] || continue
    [[ -z $line_4 ]] || continue

    matched=$((matched + 1))

    if $dry_run; then
        printf 'Would repair: %s (cooltools %s)\n' "$file" "$line_3"
        continue
    fi

    backup="${file}.before_cooltools_repair"
    if [[ -e $backup ]]; then
        # A previous run may have created the backup and then stopped before
        # replacing the malformed original. Continue only when the original
        # still matches that backup exactly.
        if ! cmp -s "$file" "$backup"; then
            printf 'Skipped (backup exists but differs): %s\n' "$file" >&2
            skipped_backup=$((skipped_backup + 1))
            continue
        fi
        printf 'Using existing backup: %s\n' "$backup"
    else
        cp -p "$file" "$backup"
    fi

    # Redirection truncates and rewrites the existing inode, preserving its
    # permissions portably on both macOS/BSD and Linux/GNU systems.
    printf '%s\n    cooltools: %s\n' "$header" "$line_3" > "$file"

    printf 'Repaired: %s (cooltools %s)\n' "$file" "$line_3"
    repaired=$((repaired + 1))
done < <(
    find "$work_dir" -mindepth 3 -maxdepth 3 -type f -name versions.yml \
        -exec grep -lFx "$header" {} +
)

if $dry_run; then
    printf '\nDry run complete: %d malformed file(s) found; no files changed.\n' "$matched"
else
    printf '\nRepair complete: %d repaired, %d skipped due to existing backups.\n' \
        "$repaired" "$skipped_backup"
fi

if [[ $matched -eq 0 ]]; then
    printf 'No matching malformed COOLTOOLS_INSULATION files were found.\n'
fi
