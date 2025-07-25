{
  system = {
    keyboard = {
      enableKeyMapping = true;
    };
    defaults = {
      controlcenter.BatteryShowPercentage = true;
      ActivityMonitor = {
        IconType = 6; # Show CPU history
        OpenMainWindow = true;
        ShowCategory = 101; # All Processes, Hierarchically
        SortColumn = "CPUUsage";
        SortDirection = 0; # Descending
      };
      LaunchServices.LSQuarantine = false;
      NSGlobalDomain = {
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleEnableSwipeNavigateWithScrolls = true;
        AppleFontSmoothing = null;
        AppleICUForce24HourTime = true;
        # Set to "Dark" for the dark theme
        # To set to light mode, set this to null and you'll need to manually run defaults delete -g AppleInterfaceStyle.
        AppleInterfaceStyle = null;
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        ApplePressAndHoldEnabled = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        AppleShowScrollBars = "WhenScrolling";
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 12;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = true;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = true;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSScrollAnimationEnabled = true;
        NSTableViewDefaultSizeMode = 3;
        NSWindowShouldDragOnGesture = false;
        _HIHideMenuBar = false;
        "com.apple.keyboard.fnState" = false;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.swipescrolldirection" = null; # Disable "Natural" scrolling direction
      };
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      WindowManager = {
        EnableStandardClickToShowDesktop = false;
        GloballyEnabled = false;
      };
      dock = {
        enable-spring-load-actions-on-all-items = false;
        appswitcher-all-displays = true;
        autohide = false;
        largesize = 16;
        launchanim = true;
        magnification = false;
        mineffect = "scale";
        minimize-to-application = true;
        mru-spaces = false;
        orientation = "bottom";
        persistent-others = null;
        show-process-indicators = true;
        show-recents = false;
        showhidden = true;
        slow-motion-allowed = false;
        tilesize = 43;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        CreateDesktop = true;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        QuitMenuItem = false;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = false;
        _FXSortFoldersFirst = true;
      };
      loginwindow = {
        DisableConsoleAccess = true;
        GuestEnabled = false;
      };
      menuExtraClock = {
        IsAnalog = false;
        Show24Hour = true;
        ShowAMPM = false;
        ShowDate = 1;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
        ShowSeconds = false;
      };
      screencapture.show-thumbnail = false;
      screensaver.askForPassword = true;
      spaces.spans-displays = false;
      trackpad = {
        ActuationStrength = 0;
        Clicking = true;
        Dragging = false;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = false;
        TrackpadThreeFingerTapGesture = 0;
      };
    };
  };
}
