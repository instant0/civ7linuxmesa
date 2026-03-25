# 1) Environment

## Host / guest
- Windows host: Windows 11 (user environment from investigation).
- WSL2 kernel:
  - `Linux NBZ4 6.6.87.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 5 18:30:46 UTC 2025 x86_64`
- Distro:
  - Ubuntu 24.04.4 LTS

## GPU path
- Vulkan ICD under test:
  - `/home/username/projects/civ7linux/mesa-release/icd/dzn_release_icd.json`
- Driver seen by `vulkaninfo`:
  - `driverName = Dozen`
  - `driverInfo = Mesa 26.1.0-devel (git-16e15ee205)`
- GPU selection:
  - `MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA`
  - GPU shown: `Microsoft Direct3D12 (NVIDIA GeForce RTX 4080)`

## App under test
- Binary:
  - `Civ7_linux_Vulkan`
- App contract highlights (from `DZN_CONTRACT_LOG`):
  - Instance extensions: `VK_KHR_get_physical_device_properties2`, `VK_KHR_surface`, `VK_KHR_get_surface_capabilities2`, `VK_KHR_xlib_surface`
  - Device extensions: `VK_EXT_scalar_block_layout`, `VK_KHR_maintenance1`, `VK_KHR_get_memory_requirements2`, `VK_KHR_swapchain`

## Known-good runtime profile
- `MESA_VK_WSI_PRESENT_MODE=fifo`
- `MESA_VK_D3D12_THREAD_SUBMIT=0`
- `MESA_VK_D3D12_SYNC=legacy`
- `VK_LOADER_LAYERS_DISABLE=all`
- `DZN_EXPERIMENTAL_DUAL_SRC_BLEND=0` (default)

