+++
title = "Ubuntu 22.04 local setting"
date = 2023-02-14
[taxonomies]
tags = ["env setting"]
[extra]
author = "JS970"
+++
<aside>
๐ก ์ด๋ฏธ ์๋์ฐ ๋ฑ ํ ํ๊ฒฝ์์ ์ฐ๋ถํฌ iosํ์ผ๋ก ์ฐ๋ถํฌ ์ค์น usb๋ ๋ง๋ค์ด์ ์ฐ๋ถํฌ๋ ์ค์น๋์๋ค๊ณ  ๊ฐ์ ํ๋ค.

</aside>

# ํ/์ ๋ณํ ์ค์ 

- fcitx5๋ฅผ ์ด์ฉํ๋ค.
- ibus, uim๋ฑ์ ๋ฐฉ๋ฒ์ ์ฌ์ฉํ  ์๋ ์์ง๋ง ์ด๋ ์ถํ์ ์ถ๊ฐํ๋ค.(2/14/2023)

## fcitx5

- ๋ค์ ๋ช๋ น์ด๋ฅผ ํฐ๋ฏธ๋์ ์๋ ฅํ์ฌ fcitx5๋ฅผ ์ค์นํ๋ค.

```bash
sudo apt install fcitx5
```

- ์ค์น๊ฐ ์๋ฃ๋๋ฉด Settings โ Region & Language โ Manage Installed Language์์ Keyboard input method system์ fcitx5๋ก ๋ณ๊ฒฝํ๋ค.
- ์์ ์ค์ ์ด ์๋ฃ๋๋ฉด ์ปดํจํฐ๋ฅผ ์ฌ๋ถํํ๋ค.

```bash
sudo shutdown now
```

- ์ฌ๋ถํ ์ดํ ์ฐ์ธก ์ํ ํ์์ค์ ๊ฐ์ฅ ์ผ์ชฝ์ ํค๋ณด๋ ๋ชจ์ ์์ด์ฝ์ด ์ถ๊ฐ๋ ๊ฒ์ ํ์ธํ  ์ ์๋ค.

![Screenshot from 2023-02-14 15-03-38.png](/image/Enviromnent_Settings/Ubuntu_22_04_Local_Setting/Screenshot_from_2023-02-14_15-03-38.png)
- ํค๋ณด๋ ์์ด์ฝ์ ํด๋ฆญํ ํ configure์์ Available input Method๋ก Hangul์ ์ถ๊ฐํ๋ค.
    
    ![Screenshot from 2023-02-14 15-05-16.png](/image/Enviromnent_Settings/Ubuntu_22_04_Local_Setting/Screenshot_from_2023-02-14_15-05-16.png)
    
- ์ด๋ฅผ ์ ์ฉํ๋ฉด ctrl+space๋ฅผ ํตํด ํ/์ ๋ณํ์ด ๊ฐ๋ฅํ๋ค.

## ibus
- fcitx๋ฅผ ํธํ๊ฒ ์ฌ์ฉ์ค์ด์์ง๋ง... ํ๊ธ๊ณผ์ปดํจํฐ ํ์ปด์คํผ์ค 2020 for linux์์ ํ๊ธ ์๋ ฅ์ ibus๋ง ์ธ์๋๋ค๊ณ  ํ๋ค... ์ด์ ibus๋ก ๋ค์ ์ค์ ํ๊ฒ ๋์๋ค.(2023-03-12)
- ์ค์  -> ์ง์ญ ๋ฐ ์ธ์ด -> Korean๋ฐ์ค๊ฐ ์ฒดํฌ๋์ด ์๋์ง ํ์ธ
	- ์ฒดํฌ๋์ด ์์ง ์๋ค๋ฉด ์ฒดํฌ ํ ์ฌ๋ถํ
- terminal์ ์๋์ ๊ฐ์ด ์๋ ฅ
```bash
ibus-setup
```
- ibus Preferences์์ Input Method์ ํ, ์ฌ๊ธฐ์ Korean - Hangul ์ถ๊ฐํ  ๊ฒ
![ibus preferences](/image/Enviromnent_Settings/Ubuntu_22_04_Local_Setting/ibus_setting.png)
- Setting์ Keyboard์์ Korean(Hangul) ์ถ๊ฐํ๊ณ  ๋๋จธ์ง๋ ์ ๋ถ ์ญ์ ํ  ๊ฒ
![Setting-ibus](/image/Enviromnent_Settings/Ubuntu_22_04_Local_Setting/ibus-settings.png)
- ์ฌ๋ถํํ๋ฉด ์ฐ์ธก ์๋จ์ ์ํ ํ์์ค์ ํ๊ธ ์๋ ฅ๊ธฐ๊ฐ ์ถ๊ฐ๋ ๊ฒ์ ๋ณผ ์ ์๋ค. ์ด๋ฅผ ์ฐํด๋ฆญํ์ฌ Setup์ ์ ํํ๋ฉด ์๋์ ๊ฐ์ ์ฐฝ์ด ํ์๋๋ค.
![ibusHangulSetup](/image/Enviromnent_Settings/Ubuntu_22_04_Local_Setting/ibus-pref.png)
- ์ด ์ฐฝ์์ ํ/์ ๋ณํ ํ ๊ธ ํค ์ค์ ์ด ๊ฐ๋ฅํ๋ค.

# nvidia graphic driver

- ์ฌ๋ฌ ๊ฐ์ง ์ค์น ๋ฐฉ๋ฒ์ด ์์ง๋ง ์ค์น์ ๊ฝค ์ ๋ฅผ ๋จน์๋ค.
- ๋ณธ ๊ธ์์๋ ํฐ๋ฏธ๋์์ ์ปค๋งจ๋๋ฅผ ์ด์ฉํด ์๋์ผ๋ก ๊ทธ๋ํฝ ๋๋ผ์ด๋ฒ๋ฅผ ์ค์นํ๋ค.

## ์๋ ์ค์น

- ์ฐ์  ์๋์ ์ปค๋งจ๋๋ฅผ ํตํด ํ์ฌ ์ฌ์ฉ์ค์ธ ๊ทธ๋ํฝ์นด๋๋ฅผ ํ์ธํ๋ค.

```bash
sudo lshw -c display
```

- ๋ค์ ์ปค๋งจ๋๋ฅผ ์ด์ฉํ์ฌ ์ค์น ๊ฐ๋ฅํ ๋๋ผ์ด๋ฒ ๋ชฉ๋ก์ ํ์ธํ๋ค.

```bash
ubuntu-drivers devices
```

- ์์ ์ ๊ทธ๋ํฝ์นด๋์ ๋ง๋ ๋ฒ์ ์ ์ค์น ๊ฐ๋ฅํ ๋๋ผ์ด๋ฒ๋ฅผ ์ค์นํ๋ค.

```bash
sudo apt install nvidia-driver-xxx
```

- ์ด๋ recommended๊ฐ ๋ถ์ด์๋ nvidia-driver-525-open์ ์ค์นํ๋ ค๊ณ  ์๋ํ์ผ๋ ์ด ๋๋ฌธ์ ๋ง์ ์๊ฐ์ ์๋นํ๋ค. open๋ฒ์ ์ด ์๋ ๋ฒ์ ์ผ๋ก ์ค์นํด์ผ ํ๋ค.

![Untitled](/image/Enviromnent_Settings/Ubuntu_22_04_Local_Setting/Untitled.png)

- ๋๋ผ์ด๋ฒ์ ์ค์น๊ฐ ์๋ฃ๋๋ฉด ์ปดํจํฐ๋ฅผ ์ฌ๋ถํํ๋ค.

```bash
sudo shutdown now
```

- ๋ง์ง๋ง์ผ๋ก ๋ค์ ์ปค๋งจ๋๋ฅผ ํตํด ๊ทธ๋ํฝ์นด๋ ๋๋ผ์ด๋ฒ์ ์ค์น๋ฅผ ํ์ธํ  ์ ์๋ค.

```bash
nvidia-smi
```

- ์์ ์ปค๋งจ๋๋ฅผ ์ด์ฉํ์ง ์๊ณ  application์์ nvidia x server๋ฅผ ์คํํ์ฌ ๊ทธ๋ํฝ์นด๋๋ฅผ ์ ์์ ์ผ๋ก ์ธ์ํ๋์ง ํ์ธํ  ์ ์๋ค.

# zsh

## zsh, oh-my-zsh ์ค์น

- mac์์ ์ต์ํ๊ฒ ์ฌ์ฉํ๋ zsh์ ์ค์นํ๋ค.

```bash
sudo apt-get install zsh
```

- ๊ธฐ๋ณธ shell์ ๋ณ๊ฒฝํ๋ค.

```bash
chsh -s $(which zsh)
```

- curl์ ์ด์ฉํด์ oh-my-zsh ์ค์น(zsh ์ค์ ์ ๊ด๋ฆฌํ๋ ํ๋ ์์ํฌ)

```bash
# curl์ค์น
sudo apt isntall curl
# oh-my-zsh์ค์น
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

- ํ๋ฌ๊ทธ์ธ ํ์ฑํ, ์ ์ค์  ๋ณ๊ฒฝ์ ~/.zshrc๋ฅผ ์์ ํ์ฌ ์ค์  ๊ฐ๋ฅํ๋ค.
- ์๋๋ ohmyzsh์ ๊นํ๋ธ ํ์ด์ง์ด๋ค.
    
    [https://github.com/ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
    

# Ref

[Ubuntu 22.04 ํ๊ธ ์๋ ฅ๊ธฐ 3๊ฐ์ง ์ค์  ๋ฐฉ๋ฒ(ibus, uim, fcitx) - ์ค์๊ธธ](https://osg.kr/archives/913#%ED%95%9C%EA%B8%80-%EC%9E%85%EB%A0%A5%EA%B8%B0-fcitx-%EC%84%A4%EC%B9%98-%EB%B0%8F-%EC%84%A4%EC%A0%95)

[์ฐ๋ถํฌ nvidia ๋๋ผ์ด๋ฒ ์ค์น | ๊ฐ๋ฐ์ ์ํ์ ํ๋ฃจํ๋ฃจ](https://hyeon.pro/dev/nvidia-drive-install-in-ubuntu/)

[Nvidia-smi outputs "No devices were found" on Ubuntu 22.04 + driver 520](https://forums.developer.nvidia.com/t/nvidia-smi-outputs-no-devices-were-found-on-ubuntu-22-04-driver-520/234829)