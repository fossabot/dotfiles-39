{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.firefox.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.firefox.enable {
    programs.firefox = {
      enable = true;
      # Required for paxmod to work.
      package = pkgs.firefox-devedition;
      # The profile is named like this because firefox devedition 
      # refuses to open normal profiles.
      profiles."dev-edition-default" = {
        name = "dev-edition-default";
        isDefault = true;
        id = 0;
        
        # This doesn't work properly, it leads to issues with rebuilding and leaves
        # extensions stuck as disabled.
        /*
          extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
          keepa
          auto-tab-discard
          youtube-recommended-videos
          statshunters
        ];
        */

        userChrome = ''
          /* Make interface on a single bar */
          #navigator-toolbox {
            display: flex !important;
            height: 20px !important;
            flex-direction: row !important;
            align-items: center !important;
            border-bottom: 0 !important;
          }

          #nav-bar {
            order: 1 !important;
            background-color: transparent !important;
          }

          #titlebar {
            order: 2 !important;
            flex-grow: 1 !important;
            background-color: transparent !important;
          }

          /* Remove all shadows and round corners */
          * {
            border-radius: 0 !important;
            text-shadow: none !important;
            box-shadow: none !important;
          }

          /* Auto hide tab bar */
          #main-window:not([customizing]) #navigator-toolbox:focus-within #TabsToolbar,
          #main-window:not([customizing]) #nav-bar:focus-within #back-button {
            visibility: collapse !important;
          }

          /* Auto hide URL bar */
          #main-window:not([customizing]) #nav-bar #urlbar-container {
            width: 0 !important;
            margin: 0 !important;
          }

          #main-window:not([customizing]) #nav-bar:focus-within {
            width: 100% !important;
          }

          /* Remove border/separators from search results */
          #urlbar-background {
            outline: none !important;
          }

          #urlbar-input {
            margin-inline: 1mm !important;
            font-size: 16px !important; /* Adjust as needed */
            height: 20px !important; /* Set height */
            padding: 0 !important; /* Remove padding */
          }

          /* Center icons and text in URL bar */
          #urlbar-container {
            height: 20px !important; /* Match with the tab height */
            display: flex !important;
            align-items: center !important;
          }

          /* Remove padding, margins, and close buttons from non-selected/non-pinned tabs */
          .tabbrowser-tab {
            padding: 0 !important;
            display: flex !important;
            justify-content: center !important;
            align-items: center !important;
            height: 20px !important; /* Set to 20px */
            min-height: 20px !important; /* Prevent expansion */
            max-height: 20px !important; /* Prevent any potential expansion */
            width: auto !important; /* Allow width to adjust */
            flex-grow: 1 !important; /* Allow tabs to fill available space */
          }

          /* Set a consistent height for the tab bar and search bar */
          #TabsToolbar,
          #urlbar-container {
            height: 20px !important; /* Set to 20px */
            min-height: 20px !important; /* Ensure it doesn't expand */
            padding: 0 !important; /* Remove any default padding */
          }

          /* Adjust tab labels */
          .tab-label {
            margin: 0 !important; /* Remove default margin */
            text-align: center !important; /* Center text */
            line-height: 20px !important; /* Match with the tab height */
          }

          /* Center icons and text in tabs */
          .tabbrowser-tab > .tab-close-button,
          .tabbrowser-tab .tab-icon {
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            height: 20px !important; /* Match the height */
          }

          /* Remove specified elements */
          .titlebar-buttonbox-container,
          .urlbar-go-button,
          #identity-box,
          #PersonalToolbar,
          #context-navigation,
          #context-sep-navigation,
          #toolbar-menubar,
          #identity-icon-label,
          #tracking-protection-icon-container,
          #page-action-buttons > :not(#urlbar-zoom-button),
          #alltabs-button,
          #forward-button,
          #back-button,
          #PanelUI-menu-button {
            display: none !important;
          }

        '';
      };
    };

    # Asahi Widevine Support
    # Note that in order for Netflix to work, this needs to be paried with
    # a web user-agent spoofer configured to emulate Chrome on ChromeOS.
    home.file."firefox-widevinecdm" = lib.mkIf pkgs.stdenv.hostPlatform.isAarch64 {
      enable = true;
      target = ".mozilla/firefox/dev-edition-default/gmp-widevinecdm";
      source = pkgs.runCommandLocal "firefox-widevinecdm" {} ''
        out=$out/${pkgs.widevinecdm-aarch64.version}
        mkdir -p $out
        ln -s ${pkgs.widevinecdm-aarch64}/manifest.json $out/manifest.json
        ln -s ${pkgs.widevinecdm-aarch64}/libwidevinecdm.so $out/libwidevinecdm.so
      '';
      recursive = true;
    };
    programs.firefox.profiles."dev-edition-default".settings = lib.mkIf pkgs.stdenv.hostPlatform.isAarch64 {
      "media.gmp-widevinecdm.version" = pkgs.widevinecdm-aarch64.version;
      "media.gmp-widevinecdm.visible" = true;
      "media.gmp-widevinecdm.enabled" = true;
      "media.gmp-widevinecdm.autoupdate" = false;
      "media.eme.enabled" = true;
      "media.eme.encrypted-media-encryption-scheme.enabled" = true;
    };
  };
}
