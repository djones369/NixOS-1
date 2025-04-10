{ config, pkgs, ... }:

{
  # Enable dconf (System Management Tool)
  programs.dconf.enable = true;

  # Add user to libvirtd group
  # users.users.$user.extraGroups = [ "libvirtd" ];

  # Install necessary packages
  # environment.systemPackages = with pkgs; [
  # spice				# Complete open source solution for interaction with virtualized desktop devices
  # spice-gtk 		# GTK 3 SPICE widget
  # spice-protocol	# Protocol headers for the SPICE protocol
  # virt-manager      # Virtualization manager
  # virt-viewer		# Viewer for remote virtual machines
  # virtio-win	    # Windows VirtIO Drivers
  # win-spice			# Windows SPICE Drivers
  # gnome.adwaita-icon-theme
  # ];

  # Manage the virtualisation services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

}
