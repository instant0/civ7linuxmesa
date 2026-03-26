# 1) Environment

## Platform
- Host/guest model: Windows host with WSL2 Linux guest.
- Distro class: Ubuntu 24.04 LTS family.
- Kernel class: `6.6.x-microsoft-standard-WSL2`.

## GPU and driver path
- Vulkan driver under test: dzn (`libvulkan_dzn.so`) over D3D12.
- Adapter selection used in runs: NVIDIA discrete GPU.
- Vulkan driver info observed: Mesa `26.1.0-devel` (`git-16e15ee205`).

## Runtime profile used for stable diagnostics
- `MESA_VK_WSI_PRESENT_MODE=fifo`
- `MESA_VK_D3D12_SYNC=legacy`
- `MESA_VK_D3D12_THREAD_SUBMIT=0`
- `VK_LOADER_LAYERS_DISABLE=all`
- `DZN_EXPERIMENTAL_DUAL_SRC_BLEND=0`
- Validation/API-dump layers disabled for baseline stability runs.
