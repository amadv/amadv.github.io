Subject: Uses

This is a page that lists things I use regularly.


## Hardware

### Desktop

- PC: [System76 Thelio Mira](https://system76.com/desktops/thelio-mira) with a 16-core AMD CPU and plenty of RAM
- GPU: AMD Radeon RX 6600 - great compatibility with Steam on Linux because of drivers, not expensive, gets the job done
- Keyboard: [NuPhy Air 75](https://nuphy.com/collections/keyboards/products/air75-v2). Mech, low profile, slightly clicky.
- Display: Lenovo ThinkVision T32p-20 (32", 4K, IPS). Nothing special about this one, it's just OK for lots of text.
- Headset: [Shokz OpenComm 2](https://shokz.com/pages/opencomm2). Bone conduction, quality microphone, good for lots of meetings.
- Camera: [Sony Alpha 6500](https://www.sony.co.uk/electronics/interchangeable-lens-cameras/ilce-6500-body-kit), with [RM-VPR1](https://www.sony.co.uk/electronics/interchangeable-lens-cameras-tripods-remotes/rm-vpr1) wired remote control, and a no-name dummy battery. I use it as "webcam" and to record "talking head" videos.
- HDMI capture card: [AVerMedia Live Streamer CAP 4K](https://www.avermedia.com/uk/product-detail/BU113) to present the Sony camera as a "webcam" in Linux. Plug-and-play, no drivers required.
- Pen tablet: [Wacom Intuos M](https://www.wacom.com/en-gb/products/pen-tablets/wacom-intuos) for drawing diagrams and signing documents.

### Laptop

- [Framework 13](https://frame.work/gb/en/products/laptop13-diy-intel-ultra-1) - light, fast, aluminum body, great Linux compatibility, repairable

### Mobile

- Phone: [Pixel 9 Pro](https://store.google.com/gb/product/pixel_9_pro) with [GrapheneOS](https://grapheneos.org/). Completely de-Googled, great security and privacy defaults.

### Network Equpment

- Linksys E8450 router with WiFi 6, running [OpenWrt](https://openwrt.org) open-source firmware.

## Software

### Operating System

- Linux distro of choice for both desktop and personal servers: [NixOS](https://nixos.org/). [Config](https://git.amadv.com/amadv/nixos).
- Desktop environment: [Sway](https://swaywm.org/). Like i3, but for Wayland. Fast and super stable.

### Text Editor

- On servers: Vim
- On the desktop: Emacs with Vim keybindings and a [bespoke config](https://git.amadv.com/amadv/nixos/src/branch/master/emacs.el)

Emacs plugins:

- Theme: [modus-operandi](https://protesilaos.com/emacs/modus-themes-pictures). Highly readable.
- Note taking: [org-mode](https://orgmode.org/) together with [org-roam](https://www.orgroam.com/) to keep a personal knowledge base.
- Git UI: [magit](https://magit.vc/)
- Completion and fuzzy matching: [corfu](https://github.com/minad/corfu), [cape](https://github.com/minad/cape) and [vertico](https://github.com/minad/vertico)
- Language Server client: [eglot](https://github.com/joaotavora/eglot)
- Using LLMs: [gptel](https://github.com/karthink/gptel)

### Browser

- Browser itself: Firefox
- Plugins: [uBlock Origin](https://ublockorigin.com/), [Sidebery](https://addons.mozilla.org/en-GB/firefox/addon/sidebery/)

### AI

- Local LLM: [Ollama](https://ollama.com/) with various models, e.g. [codellama](https://ollama.com/library/codellama)

### Other software

- Hand-drawing diagrams and signing PDFs: [xournal++](https://xournalpp.github.io/)

## Self-hosting

- Chat: [Dendrite](https://github.com/matrix-org/dendrite) Matrix server.
- Git forge: [Forgejo](https://forgejo.org/). Libre fork of Gitea. Easy to setup, low maintenance.
- VPN to home PC: [Headscale](https://headscale.net/). An OSS implementation of Tailscale server. Compatible with regular Tailscale apps.
- Hosting videos: [Peertube](https://joinpeertube.org/). I'm not an active video creator, but occasionally upload to my own instance.

## Security

- [YubiKey](https://www.yubico.com/gb/product/yubikey-5-series/yubikey-5c-nfc/) for authentication and signing
- [Pass](https://www.passwordstore.org/) with YubiKey to store passwords
- GPG with YubiKey for signing git commits and packages

## Paid services

Most of these are paid, monthly or yearly subscription.

- E-Mail: [FastMail](https://fastmail.com)
- Search Engine: [Kagi](https://kagi.com)
- Domain Registrar: [Gandi](https://www.gandi.net/)
- VPS: [Vultr](https://www.vultr.com/) for most things, and [BuyVM](https://buyvm.net/) for video
- Music: [Bandcamp](https://bandcamp.com/). I usually just buy full albums from there.
- VPN: [Mullvad](https://mullvad.net)

## Free services

- Social - Mastodon. Instance: [mas.to](https://mas.to/home)
