# ScreenSaverZ

English version of [madebyKir/ScreenSaverManager](https://github.com/madebyKir/ScreenSaverManager), a KUAL extension that swaps the stock and ad screensavers on a jailbroken Kindle for your own images. Everything's translated: the KUAL menu, the on-device messages, and the docs. There's also an image-prep tool bundled in so you don't have to wrestle with ImageMagick by hand.

No KOReader needed. The screensavers show up everywhere the device sleeps.

Heads up: this writes to system files on your Kindle. If it eats your data, bricks the thing, or voids your warranty, that's on you. Run Create Backup before you touch anything else.

## What you need

- A jailbroken Kindle with KUAL installed.
  - Newer devices (Paperwhite 6 / 12th gen, Colorsoft, etc): [Sanctuary](https://kindlemodding.org/jailbreaking/Sanctuary/)
  - Older devices (Kindle 11, etc): [WinterBreak](https://kindlemodding.org/jailbreaking/WinterBreak/)
  - Never done this before? Read the [jailbreak FAQ](https://kindlemodding.org/jailbreaking/jailbreak-faq.html) first.
- A Windows PC to prep images. [ImageMagick](https://imagemagick.org/) does the actual conversion, and the included tool installs it for you if you don't already have it.
- A USB cable.

Confirmed working on Kindle 11 (2022) with WinterBreak, and on Paperwhite 6 (12th gen) / Colorsoft with Sanctuary.

## What's in here

```
ScreenSaverZ/
  ScreenSaverManager/       the KUAL extension, this is the part that goes on the Kindle
    bin/                    scripts and the fbink binary
    backup_screensavers/    the stock screensavers (Restore Backup pulls from here)
    screens/                your processed images go here (bg_ss00.png, bg_ss01.png, ...)
    config.xml
    menu.json               the English KUAL menu
    readme.txt
  tools/
    process-images.ps1      resizes, greyscales and renames your images
  README.md
```

## Setup

### 1. Download

Code > Download ZIP, or clone it, then unzip.

The thing that trips people up: on the Kindle the folder has to be named exactly `ScreenSaverManager`. Not `ScreenSaverManager-main`, not `ScreenSaverZ`. The scripts point at `/mnt/us/extensions/ScreenSaverManager/` internally, so any other name just quietly does nothing. If you copy the inner `ScreenSaverManager` folder out of this repo in step 3, you're already fine.

### 2. Prep your images

Screensavers have to be the right size, greyscale, 8-bit PNGs named `bg_ss00.png`, `bg_ss01.png` and so on. The tool takes care of all of that.

1. Drop your pictures (.png) into the `tools` folder.
2. Right-click `process-images.ps1` and Run with PowerShell.
3. Pick your Kindle model from the dropdown. Hit Preview to check one before doing the whole batch.
4. Click OK. The finished files land in `tools/ProcessedImages`, named `bg_ss00.png`, `bg_ss01.png`, and so on.
5. Copy those into `ScreenSaverManager/screens`.

<details>
<summary>Models and resolutions</summary>

| Resolution | Devices |
| --- | --- |
| 600 x 800 | Kindle 1 / 2 / 4 / 5 / 7 / 8 / 10, Kindle Keyboard (K3) |
| 758 x 1024 | Paperwhite 1st / 2nd gen |
| 824 x 1200 | Kindle DX |
| 1072 x 1448 | Kindle 11 (2022), Kindle 2024, Paperwhite 3rd / 4th gen, Oasis 1st gen, Voyage |
| 1236 x 1648 | Paperwhite 5 (11th gen) and Signature Edition |
| 1264 x 1680 | Paperwhite 6 (12th gen) and Signature, Oasis 2nd / 3rd gen, Colorsoft and Signature |
| 1860 x 2480 | Scribe, Scribe 2024 |
| 1980 x 2640 | Scribe Colorsoft, Scribe 3 |
| Custom | whatever width and height you type in |

Colour devices (Colorsoft, Scribe Colorsoft) keep colour. E-ink devices get converted to dithered greyscale.

</details>

Rather do it yourself or online? The original author has a web tool for it: https://madebykir.github.io/kindle_custom_ScreenSaver/

### 3. Put it on the Kindle

1. Plug the Kindle in over USB.
2. Copy the `ScreenSaverManager` folder into the Kindle's `extensions` folder (`/mnt/us/extensions/`). Make the `extensions` folder yourself if it isn't there.
3. Eject.

### 4. Run it from KUAL

Open KUAL, go into Screensaver Manager, and run these in order:

1. Create Backup. Saves your current screensavers so you can get them back later. Do this first.
2. Update screensavers. Copies everything from `screens` over the stock ones.
3. Disable Ads. Stops the ad screensavers from coming back. Reboot for it to take effect.

Your images should show up now whenever the Kindle sleeps.

### Going back

- Restore Backup puts the originals back.
- Enable Ads turns the ad screensavers back on (needs a reboot).
- About the Author shows the credits and version.

## If something's off

- Nothing changed after Update screensavers: check the folder is named exactly `ScreenSaverManager`, your files are named `bg_ssNN.png` (two digits, starting at 00), and that you rebooted.
- Ads keep coming back: run Disable Ads and reboot. It installs a small boot job that unloads the ad module every time the Kindle starts.
- Images look stretched or cropped weird: run the tool again and pick your exact model, or use Custom with your resolution.
- KUAL doesn't list the extension: it has to sit in `/mnt/us/extensions/ScreenSaverManager/` with its `config.xml` and `menu.json` (both included). Reopen KUAL.

## Credits

- **@wellthatsnothing** on Discord, also goes by **@Life**. Found this obscure Russian project, translated it, worked out the whole process, and built the image-prep tool. None of the English side happens without him.
- **@Shalom_Kir / @Made.by.Kir** ([madebyKir](https://github.com/madebyKir/ScreenSaverManager)). Wrote the original ScreenSaverManager. All the actual on-device work is his.
- **Sanctuary** and the [KindleModding](https://github.com/KindleModding) crew, for making any of this possible on locked-down Kindles.

## License

This is a translation of a project that shipped without a license. The original code and the bundled screensavers belong to whoever made them (see Credits). Posted here for the Kindle community. If you're one of the original authors and want something changed or taken down, open an issue.
