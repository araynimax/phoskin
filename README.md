<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <h2 align="center">phoskin</h2>
  <p align="center">
    Sourcemod plugin to preview/generate any skins
    <br />
    <h3 align="center">!!!!! Valve banned servers using skin plugins in the past! Use it at your own risk !!!!!</h3>
    <br />
    <br />
    <a href="https://github.com/araynimax/phoskin/issues">Report Bug</a>
    ·
    <a href="https://github.com/araynimax/phoskin/issues">Request Feature</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li><a href="#features">Features</a></li>
    <li><a href="#upcoming-features">Upcoming features</a></li>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#commands">Commands</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

We all new the videos where people are just using commands like !gen or !i to inspect potential crafts or existing skins. 
A found about broskins server somewhat later and since I have a own server for me and the boys (Mainly for practice mode) I thought it would be nice to have this feature there too.

I thought I could just grab a plugin online and use it but I didnt find a good one that I like.

With the help of existing skin changer plugins from kgns:
- https://github.com/kgns/weapons
- https://github.com/kgns/gloves

I managed to create my own version of it named - phoskin -
The codebase is not the best I've made in my life, but its just a small plugin so what. Feel free to make pullrequest to change that!

### Features

- Generate skins with the known `!gen` and `!gengl` commands
- Edit skins directly with some helper commands e.g. changing the seed with `!pho seed` (See more under commands)
- Generate any skin from an inspect url by just pasting the url into the chat.

- This plugin does not save any skin to play with it multiple rounds and it will stay like this! This is not a classical skin changer. Its for previewing skins!

### Upcoming Features

There are existing convars but they are not really implemented yet. this is a thing I will work on if I find time for it.

You have an idea?
Submit it [here](https://github.com/araynimax/phoskin/issues).

### Dependecies

- ptah: https://ptah.zizt.ru/
- ripext: https://github.com/ErikMinekus/sm-ripext
- This plugin depends on the csgofloat api to generate skins from inspect urls

### Installation

0. Make sure you have installed the depedencies. (See Dependecies)
1. Take a look into the [release section](https://github.com/araynimax/phoskin/releases) and download the newest version of phoskin
2. Unzip the Zip-file in the servers "csgo" folder
3. Have fun

<!-- Commands -->

## Commands

Info: `!gen` and `!gengl` are supported but are just aliases for `!pho gen`
For `!i <inspect-url>` you should just paste the inspect url into the chat!

| Syntax| Description |
|---------|-------------|
|`!pho help` | Shows you a list of all commands in a similar fashion|
|`!pho gen <defIndex> <paintIndex> <paintSeed> <paintWear> [<stickerslot1> <stickerslot1wear>...]`|Generate a skin - `!gen` and `!gengl` are still available!|
|`!pho skin <paintIndex>`|Set skin index of the weapon you are currently holding|
|`!pho seed [paintSeed]`|Set seed of the weapon you are currently holding to a specific one or leave the paintseed blank for a random one|
|`!pho float <paintWear>`|Set float of the weapon you are currently holding|
|`!pho sticker [<stickerslot1> <stickerslot1wear>...]`|Set stickers of the weapon you are currently holding (without arguments will remove any stickers)|
|`!pho rename [newName]`|Add or remove nametag of weapon you are currently holding (without newName argument will remove the nametag)|
|`!pho stattrak <1\|0> [count]`|Enable/Disable stattrak of weapon you are currently holding|
|`!pho gloves skin <paintIndex>` |Set gloves skin|
|`!pho gloves float <paintWear>` |Sets gloves float to a specific float|
|`!pho gloves seed [paintSeed]` |Set gloves seed to specific one (without argument will choose a random seed)|

<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->

## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[forks-shield]: https://img.shields.io/github/forks/araynimax/phoskin?style=for-the-badge
[forks-url]: https://github.com/araynimax/phoskin/network/members
[stars-shield]: https://img.shields.io/github/stars/araynimax/phoskin?style=for-the-badge
[stars-url]: https://github.com/araynimax/phoskin/stargazers
[issues-shield]: https://img.shields.io/github/issues/araynimax/phoskin?style=for-the-badge
[issues-url]: https://github.com/araynimax/phoskin/issues
[license-shield]: https://img.shields.io/github/license/araynimax/phoskin?style=for-the-badge
[license-url]: https://github.com/araynimax/phoskin/blob/main/LICENSE.txt
