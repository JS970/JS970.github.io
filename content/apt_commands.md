+++
title = "apt commands"
date = 2023-02-14
[taxonomies]
tags = ["env setting"]
[extra]
author = "JS970"
+++

<aside>
๐ก ์๋ ์ปค๋ฉ๋ ์ค install์ ๋นผ๊ณ  ์ฌ์ฉํ  ๊ณณ์ด ์ผ๋ง๋ ์๋ ์ถ์ง๋งโฆ ๋ฉ์ฒญํ๊ฒ๋ /bin์์ ๋ค์ง๊ณ ์ง ์ญ์ ๋ฅผ ๊ฐํํ๋ ์ง์ ๋ฒ์ด๊ณ  ๋ ํ์ ์๋ apt purge๋ฅผ ์ฌ์ฉํด์ ์์  ์ญ์ ๊ฐ ๊ฐ๋ฅํ๋ค. ์ด๋ฐ ํน์ํ ๊ฒฝ์ฐ์ ๊ฝค๋ ์ ์ฉํ๊ฒ ์ฌ์ฉํ  ์ ์๋ค.

</aside>

# APT Usage

- ํจํค์ง ๋ชฉ๋ก ๊ฐฑ์ 

```bash
apt update
```

- ํจํค์ง ์๊ทธ๋ ์ด๋

```bash
apt upgrade
```

- ํจํค์ง ์ค์น(+dependency)

```bash
apt install <package>
```

- ํจํค์ง ์ญ์ (์ค์  ํ์ผ ์ ์ธ)

```bash
apt remove <package>
```

- ์ค์  ํ์ผ์ ํฌํจํ ํจํค์ง ์ญ์ 

```bash
apt purge <package>
```

- ๊ด๋ จ ํจํค์ง ๊ฒ์

```bash
apt search <package>
```

- ํจํค์ง ์ ๋ณด ์ถ๋ ฅ

```bash
apt show <package>
```

- ํจํค์ง ๋ชฉ๋ก ์ถ๋ ฅ

```bash
apt list
```

- ์ค์น๋ ํจํค์ง ๋ชฉ๋ก ์ถ๋ ฅ

```bash
apt list --installed
```

- ์๊ทธ๋ ์ด๋ ๊ฐ๋ฅ ํจํค์ง ๋ชฉ๋ก ์ถ๋ ฅ

```bash
apt list --upgradable
```

- ๋์๋ง

```bash
apt --help
```

# ref

[Ubuntu Server / apt / ํจํค์ง ์ค์น, ์ญ์ , ์๊ทธ๋ ์ด๋ํ๋ ๋ช๋ น์ด](https://www.manualfactory.net/11953)