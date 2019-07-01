# pi

Yet Another Yogurt - An AUR Helper Written in Go

#### Packages

[![pi](https://img.shields.io/aur/version/pi.svg?label=pi)](https://aur.archlinux.org/packages/pi/) [![pi-bin](https://img.shields.io/aur/version/pi-bin.svg?label=pi-bin)](https://aur.archlinux.org/packages/pi-bin/) [![pi-git](https://img.shields.io/aur/version/pi-git.svg?label=pi-git)](https://aur.archlinux.org/packages/pi-git/) [![GitHub license](https://img.shields.io/github/license/jguer/pi.svg)](https://github.com/Jguer/pi/blob/master/LICENSE)

## Objectives

There's a point in everyone's life when you feel the need to write an AUR helper because there are only about 20 of them.
So say hi to 20+1.

pi is based on the design of [yaourt](https://github.com/archlinuxfr/yaourt), [apacman](https://github.com/oshazard/apacman) and [pacaur](https://github.com/rmarquis/pacaur). It is developed with these objectives in mind:

- Provide an interface for pacman
- Yaourt-style interactive search/install
- Minimal dependencies
- Minimize user input
- Know when git packages are due for upgrades

## Features

- Perform advanced dependency solving
- Download PKGBUILDs from ABS or AUR
- Tab-complete the AUR
- Query user up-front for all input (prior to starting builds)
- Narrow search terms (`pi linux header` will first search `linux` and then narrow on `header`)
- Find matching package providers during search and allow selection
- Remove make dependencies at the end of the build process
- Run without sourcing PKGBUILD

## Installation

If you are migrating from another AUR helper, you can simply install pi with that helper.

Alternatively, the initial installation of pi can be done by cloning the PKGBUILD and
building with makepkg:

```sh
git clone https://aur.archlinux.org/pi.git
cd pi
makepkg -si
```

## Support

All support related to pi should be requested via GitHub issues. Since pi is not
officially supported by Arch Linux, support should not be sought out on the
forums, AUR comments or other official channels.

A broken AUR package should be reported as a comment on the package's AUR page.
A package may only be considered broken if it fails to build with makepkg.
Reports should be made using makepkg and include the full output as well as any
other relevant information. Never make reports using pi or any other external
tools.

## Frequently Asked Questions

#### pi does not display colored output. How do I fix it?

Make sure you have the `Color` option in your `/etc/pacman.conf`
(see issue [#123](https://github.com/Jguer/pi/issues/123)).

#### pi is not prompting to skip packages during system upgrade.

The default behavior was changed after
[v8.918](https://github.com/Jguer/pi/releases/tag/v8.918)
(see [3bdb534](https://github.com/Jguer/pi/commit/3bdb5343218d99d40f8a449b887348611f6bdbfc)
and issue [#554](https://github.com/Jguer/pi/issues/554)).
To restore the package-skip behavior use `--combinedupgrade` (make
it permanent by appending `--save`). Note: skipping packages will leave your
system in a
[partially-upgraded state](https://wiki.archlinux.org/index.php/System_maintenance#Partial_upgrades_are_unsupported).

#### Sometimes diffs are printed to the terminal, and other times they are paged via less. How do I fix this?

pi uses `git diff` to display diffs, which by default tells less not to
page if the output can fit into one terminal length. This behavior can be
overridden by exporting your own flags (`export LESS=SRX`).

#### pi is not asking me to edit PKGBUILDS, and I don't like the diff menu! What can I do?

`pi --editmenu --nodiffmenu --save`

#### How can I tell pi to act only on AUR packages, or only on repo packages?

`pi -{OPERATION} --aur`
`pi -{OPERATION} --repo`

#### An `Out Of Date AUR Packages` message is displayed. Why doesn't pi update them?

This message does not mean that updated AUR packages are available. It means
the packages have been flagged out of date on the AUR, but
their maintainers have not yet updated the `PKGBUILD`s
(see [outdated AUR packages](https://wiki.archlinux.org/index.php/Arch_User_Repository#Foo_in_the_AUR_is_outdated.3B_what_should_I_do.3F)).

#### pi doesn't install dependencies added to a PKGBUILD during installation.

pi resolves all dependencies ahead of time. You are free to edit the
PKGBUILD in any way, but any problems you cause are your own and should not be
reported unless they can be reproduced with the original PKGBUILD.

#### I know my `-git` package has updates but pi doesn't offer to update it

pi uses an hash cache for development packages. Normally it is updated at the end of the package install with the message `Found git repo`.
If you transition between aur helpers and did not install the devel package using pi at some point, it is possible it never got added to the cache. `pi -Y --gendb` will fix the current version of every devel package and start checking from there.

#### I want to help out!

Check `CONTRIBUTING.md` for more information.

## Examples of Custom Operations

| Command                        | Description                                                                                                                                         |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `pi <Search Term>`             | Present package-installation selection menu.                                                                                                        |
| `pi -Ps`                       | Print system statistics.                                                                                                                            |
| `pi -Yc`                       | Clean unneeded dependencies.                                                                                                                        |
| `pi -G <AUR Package>`          | Download PKGBUILD from ABS or AUR.                                                                                                                  |
| `pi -Y --gendb`                | Generate development package database used for devel update.                                                                                        |
| `pi -Syu --devel --timeupdate` | Perform system upgrade, but also check for development package updates and use PKGBUILD modification time (not version number) to determine update. |

## Images

<p float="left">
<img src="https://rawcdn.githack.com/Jguer/jguer.github.io/77647f396cb7156fd32e30970dbeaf6d6dc7f983/pi/pi.png" width="42%"/>
<img src="https://rawcdn.githack.com/Jguer/jguer.github.io/77647f396cb7156fd32e30970dbeaf6d6dc7f983/pi/pi-s.png" width="42%"/>
</p>

<p float="left">
<img src="https://rawcdn.githack.com/Jguer/jguer.github.io/77647f396cb7156fd32e30970dbeaf6d6dc7f983/pi/pi-y.png" width="42%"/> 
<img src="https://rawcdn.githack.com/Jguer/jguer.github.io/77647f396cb7156fd32e30970dbeaf6d6dc7f983/pi/pi-ps.png" width="42%"/> 
</p>
