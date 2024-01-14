{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swapluks = {
              size = "64G";
              content = {
                type = "luks";
                name = "swapluks";
                passwordFile = "/tmp/secret.key";
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                  #keyFile = "/tmp/secret.key";
                };
                content = {
                  size = "100%";
                  type = "swap";
                  discardPolicy = "both";
                  resumeDevice = "true";
                };
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # disable settings.keyFile if you want to use interactive password entry
                passwordFile = "/tmp/secret.key"; # Interactive
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                  #keyFile = "/tmp/secret.key";
                };
                #additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" "ssd"];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" "ssd"];
                    };
                    "@varlog" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "compress=zstd" "noatime" "ssd"];
                    }
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" "ssd"];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
