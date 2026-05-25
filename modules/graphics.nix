{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
      intel-vaapi-driver
      vpl-gpu-rt
      mesa
      libvdpau-va-gl
    ];
  };
}
