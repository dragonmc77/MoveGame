# MoveGame

MoveGame Extension for Playnite

Install as any extension:

    Create a folder called InstallGame in %appdata%\Playnite\Extensions.
    Copy the two files (MoveGame.ps1 and extension.yaml) to the folder.
    Make sure the extension is enabled in Playnite -> Settings -> Extensions.

To use, select a game and run the appropriate command from the Extensions menu.

History:

I have several drives I install games to, such as X:\, Y:\ and Z:\. For various reasons, I do not currently use any drivepooling or Storage Spaces to merge these together. Sometimes I install games on X:\Games, sometimes on Y:\Games, etc. I mostly choose the drive to install to based on free space.

Sometimes I want to move games around to optimize space usage between my drives, so to do that I move the game's installation folder, and then create a hard junction point (what some call symlink) in the original location pointing to the new location. This way, things like game launchers and shortcuts do not need to be reconfigured. The move is completely transparent to the system.

This extension automates that process so you can move games around without breaking anything.

This might also be useful to folks who have a bunch of games installed in C:\Program Files, but want to separate out their games from the rest of the programs by moving their games to a separate game directory, such as C:\Games.

NOTES:

Select a game, then click Move from the Extensions menu. Provided the installation directory is set in Game Details -> Installation -> Installation Directory, it will prompt for the location to move the game folder to. Once specified, the folder is moved to the new location and a hard junction point (symlink) to the new location will be left behind.

DO NOT create a new folder when asked where to move the game to. The folder with the name of the game will be automatically created. For example, when moving a game called Factorio from C:\Program Files\Factorio to C:\Games, choose C:\Games when asked where to move the game to. The Factorio folder will then be automatically created in C:\Games.

REQUIREMENTS:

Because the extension uses a Windows shell command to create symlinks, Playnite must be run with elevated privileges (Run as Administrator).

This extension was thoroughly tested on Windows 10, but no testing was done on Windows 7. However, all methods used in the extension shoudld be Window 7 compatible.
