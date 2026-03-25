#!/usr/bin/env bash
###############################################################################
# Civ7 Vulkan Trace Launcher (WSL)
#
# Purpose:
# - Capture Vulkan contract + validation + optional API dump for crash analysis
# - Keep all changes per-process only
# - Store run artifacts in docs/trace_runs/<timestamp>/
###############################################################################

set -u

GAME_PATH="/mnt/d/linx/civii/Base/Binaries/linux/Civ7_linux_Vulkan_FinalRelease"
ICD_JSON="/home/malware/projects/civ7linux/mesa-release/icd/dzn_release_icd.json"
TRACE_ROOT="/home/malware/projects/civ7linux/docs/trace_runs"

ADAPTER="NVIDIA"
ENABLE_VALIDATION=1
ENABLE_API_DUMP=1
ENABLE_D3D12_DEBUG=1
ENABLE_DUAL_SRC_BLEND=0
ENABLE_OODM_TRACE=0
SYNC_MODE="legacy"
THREAD_SUBMIT=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --adapter)
            ADAPTER="${2:-}"
            shift 2
            ;;
        --no-validation)
            ENABLE_VALIDATION=0
            shift
            ;;
        --no-api-dump)
            ENABLE_API_DUMP=0
            shift
            ;;
        --no-d3d12-debug)
            ENABLE_D3D12_DEBUG=0
            shift
            ;;
        --dual-src-blend)
            ENABLE_DUAL_SRC_BLEND=1
            shift
            ;;
        --oodm-trace)
            ENABLE_OODM_TRACE=1
            shift
            ;;
        --sync)
            SYNC_MODE="${2:-}"
            shift 2
            ;;
        --thread-submit)
            THREAD_SUBMIT="${2:-}"
            shift 2
            ;;
        -h|--help)
            cat <<'EOF'
Usage: launcher_trace_contract.sh [options]

Options:
  --adapter NAME       D3D12 adapter selector, e.g. NVIDIA or AMD
  --no-validation      Disable VK_LAYER_KHRONOS_validation
  --no-api-dump        Disable VK_LAYER_LUNARG_api_dump
  --no-d3d12-debug     Disable D3D12 debug/GBV flags in dzn
  --dual-src-blend     Experimental: expose dualSrcBlend feature in dzn
  --oodm-trace         Enable dzn out-of-device-memory telemetry (DZN_OODM_TRACE=1)
  --sync MODE          Set MESA_VK_D3D12_SYNC (legacy|none)
  --thread-submit N    Set MESA_VK_D3D12_THREAD_SUBMIT (0|1)
EOF
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            exit 2
            ;;
    esac
done

if [[ ! -x "$GAME_PATH" ]]; then
    echo "Game executable not found: $GAME_PATH" >&2
    exit 1
fi

if [[ ! -f "$ICD_JSON" ]]; then
    echo "ICD JSON not found: $ICD_JSON" >&2
    exit 1
fi

if [[ "$SYNC_MODE" != "legacy" && "$SYNC_MODE" != "none" ]]; then
    echo "Invalid --sync value: $SYNC_MODE (expected: legacy|none)" >&2
    exit 2
fi

if [[ "$THREAD_SUBMIT" != "0" && "$THREAD_SUBMIT" != "1" ]]; then
    echo "Invalid --thread-submit value: $THREAD_SUBMIT (expected: 0|1)" >&2
    exit 2
fi

if ! grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
    echo "This launcher is intended for WSL. Proceeding anyway..." >&2
fi

TS="$(date +%Y%m%d_%H%M%S)"
OUT_DIR="$TRACE_ROOT/$TS"
mkdir -p "$OUT_DIR"

echo "Trace output directory: $OUT_DIR"
echo "Adapter: $ADAPTER"

LAYER_LIST=()
if [[ "$ENABLE_VALIDATION" -eq 1 ]] && [[ -f /usr/share/vulkan/explicit_layer.d/VkLayer_khronos_validation.json ]]; then
    LAYER_LIST+=("VK_LAYER_KHRONOS_validation")
elif [[ "$ENABLE_VALIDATION" -eq 1 ]]; then
    echo "WARN: validation requested but VkLayer_khronos_validation.json not found; continuing without validation layer." >&2
fi
if [[ "$ENABLE_API_DUMP" -eq 1 ]] && [[ -f /usr/share/vulkan/explicit_layer.d/VkLayer_api_dump.json ]]; then
    LAYER_LIST+=("VK_LAYER_LUNARG_api_dump")
elif [[ "$ENABLE_API_DUMP" -eq 1 ]] && [[ -f /usr/share/vulkan/explicit_layer.d/VkLayer_LUNARG_api_dump.json ]]; then
    LAYER_LIST+=("VK_LAYER_LUNARG_api_dump")
elif [[ "$ENABLE_API_DUMP" -eq 1 ]]; then
    echo "WARN: api dump requested but VkLayer_api_dump.json/VkLayer_LUNARG_api_dump.json not found; continuing without api dump layer." >&2
fi

LAYERS_CSV=""
if [[ "${#LAYER_LIST[@]}" -gt 0 ]]; then
    LAYERS_CSV="$(IFS=:; echo "${LAYER_LIST[*]}")"
fi

{
    echo "timestamp=$TS"
    echo "game_path=$GAME_PATH"
    echo "icd_json=$ICD_JSON"
    echo "adapter=$ADAPTER"
    echo "layers=$LAYERS_CSV"
    echo "enable_validation=$ENABLE_VALIDATION"
    echo "enable_api_dump=$ENABLE_API_DUMP"
    echo "enable_d3d12_debug=$ENABLE_D3D12_DEBUG"
    echo "enable_dual_src_blend=$ENABLE_DUAL_SRC_BLEND"
    echo "enable_oodm_trace=$ENABLE_OODM_TRACE"
    echo "sync_mode=$SYNC_MODE"
    echo "thread_submit=$THREAD_SUBMIT"
    echo "kernel=$(uname -a)"
} > "$OUT_DIR/run_meta.txt"

# Baseline Vulkan info for this run context
env \
    VK_ICD_FILENAMES="$ICD_JSON" \
    VK_DRIVER_FILES="$ICD_JSON" \
    MESA_D3D12_DEFAULT_ADAPTER_NAME="$ADAPTER" \
    vulkaninfo --summary > "$OUT_DIR/vulkaninfo_summary.txt" 2>&1 || true

# Best effort: snapshot dmesg before run
dmesg > "$OUT_DIR/dmesg_before_raw.txt" 2>/dev/null || true
dmesg -T | tail -n 200 > "$OUT_DIR/dmesg_before_tail.txt" 2>/dev/null || true

DZN_DEBUG_VAL=""
if [[ "$ENABLE_D3D12_DEBUG" -eq 1 ]]; then
    DZN_DEBUG_VAL="d3d12,gbv"
fi

DZN_DUAL_SRC_BLEND_VAL="0"
if [[ "$ENABLE_DUAL_SRC_BLEND" -eq 1 ]]; then
    DZN_DUAL_SRC_BLEND_VAL="1"
fi

DZN_OODM_TRACE_VAL="0"
if [[ "$ENABLE_OODM_TRACE" -eq 1 ]]; then
    DZN_OODM_TRACE_VAL="1"
fi

echo "Launching game with trace instrumentation..."
if [[ -n "$LAYERS_CSV" ]]; then
    env \
        VK_ICD_FILENAMES="$ICD_JSON" \
        VK_DRIVER_FILES="$ICD_JSON" \
        VK_LOADER_LAYERS_DISABLE=all \
        VK_LOADER_DEBUG=error,warn \
        VK_INSTANCE_LAYERS="$LAYERS_CSV" \
        DZN_CONTRACT_LOG=1 \
        DZN_DEBUG="$DZN_DEBUG_VAL" \
        DZN_EXPERIMENTAL_DUAL_SRC_BLEND="$DZN_DUAL_SRC_BLEND_VAL" \
        DZN_OODM_TRACE="$DZN_OODM_TRACE_VAL" \
        MESA_D3D12_DEFAULT_ADAPTER_NAME="$ADAPTER" \
        MESA_VK_WSI_PRESENT_MODE=fifo \
        MESA_VK_D3D12_THREAD_SUBMIT="$THREAD_SUBMIT" \
        MESA_VK_D3D12_SYNC="$SYNC_MODE" \
        MESA_LOG_LEVEL=warning \
        "$GAME_PATH" > "$OUT_DIR/game_trace.log" 2>&1
else
    env \
        VK_ICD_FILENAMES="$ICD_JSON" \
        VK_DRIVER_FILES="$ICD_JSON" \
        VK_LOADER_LAYERS_DISABLE=all \
        VK_LOADER_DEBUG=error,warn \
        DZN_CONTRACT_LOG=1 \
        DZN_DEBUG="$DZN_DEBUG_VAL" \
        DZN_EXPERIMENTAL_DUAL_SRC_BLEND="$DZN_DUAL_SRC_BLEND_VAL" \
        DZN_OODM_TRACE="$DZN_OODM_TRACE_VAL" \
        MESA_D3D12_DEFAULT_ADAPTER_NAME="$ADAPTER" \
        MESA_VK_WSI_PRESENT_MODE=fifo \
        MESA_VK_D3D12_THREAD_SUBMIT="$THREAD_SUBMIT" \
        MESA_VK_D3D12_SYNC="$SYNC_MODE" \
        MESA_LOG_LEVEL=warning \
        "$GAME_PATH" > "$OUT_DIR/game_trace.log" 2>&1
fi
RC=$?

echo "$RC" > "$OUT_DIR/exit_code.txt"

# Best effort: snapshot dmesg after run
dmesg > "$OUT_DIR/dmesg_after_raw.txt" 2>/dev/null || true
dmesg -T | tail -n 300 > "$OUT_DIR/dmesg_after_tail.txt" 2>/dev/null || true

# Run-local kernel lines: remove everything already present before launch.
if [[ -f "$OUT_DIR/dmesg_before_raw.txt" ]] && [[ -f "$OUT_DIR/dmesg_after_raw.txt" ]]; then
    BEFORE_LINES="$(wc -l < "$OUT_DIR/dmesg_before_raw.txt" 2>/dev/null || echo 0)"
    tail -n "+$((BEFORE_LINES + 1))" "$OUT_DIR/dmesg_after_raw.txt" > "$OUT_DIR/dmesg_run_raw.txt" 2>/dev/null || true
    sed -n '1,300p' "$OUT_DIR/dmesg_run_raw.txt" > "$OUT_DIR/dmesg_run_head.txt" 2>/dev/null || true
fi

python3 - "$OUT_DIR" <<'PY' > "$OUT_DIR/trace_summary.txt" 2>/dev/null || true
import collections
import pathlib
import re
import sys

out_dir = pathlib.Path(sys.argv[1])
game_log = out_dir / "game_trace.log"
dmesg_log = out_dir / "dmesg_run_raw.txt"

vuid_counts = collections.Counter()
last_markers = []
marker_re = re.compile(r"(D3D12: Removing Device|VK_ERROR_|Segmentation fault|vkQueueSubmit\(\):|must call vkEndCommandBuffer|VUID-[^\s\]]+)")
vuid_re = re.compile(r"(VUID-[^\s\]]+)")

if game_log.exists():
    with game_log.open("r", errors="ignore") as f:
        for lineno, line in enumerate(f, 1):
            m = vuid_re.search(line)
            if m:
                vuid_counts[m.group(1)] += 1
            if marker_re.search(line):
                last_markers.append((lineno, line.rstrip()))
                if len(last_markers) > 120:
                    last_markers.pop(0)

print("Top VUIDs:")
if vuid_counts:
    for vuid, count in vuid_counts.most_common(12):
        print(f"  {count:7d}  {vuid}")
else:
    print("  (none)")

print("")
print("Last critical markers:")
if last_markers:
    for lineno, line in last_markers[-40:]:
        print(f"  {lineno}: {line}")
else:
    print("  (none)")

print("")
print("Recent dmesg crash lines:")
if dmesg_log.exists():
    any_line = False
    with dmesg_log.open("r", errors="ignore") as f:
        for line in f:
            if re.search(r"(segfault|dxgkio_|CaptureCrash|SIGSEGV|libnvwgf2umx)", line, re.IGNORECASE):
                print(f"  {line.rstrip()}")
                any_line = True
    if not any_line:
        print("  (none)")
else:
    print("  (dmesg log missing)")
PY

echo "Run complete. exit_code=$RC"
echo "Logs:"
echo "  $OUT_DIR/game_trace.log"
echo "  $OUT_DIR/vulkaninfo_summary.txt"
echo "  $OUT_DIR/dmesg_after_tail.txt"
echo "  $OUT_DIR/dmesg_run_raw.txt"
echo "  $OUT_DIR/trace_summary.txt"
exit "$RC"
