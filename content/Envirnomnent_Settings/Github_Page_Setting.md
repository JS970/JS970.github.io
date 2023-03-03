+++
title = "Github Page 구축"
date = 2023-03-03
[taxonomies]
tags = ["Github Page", "env setting"]
[extra]
author = "JS970"
+++
# Zola 사용하기

## Zola?

- Zola는 Static Site Generator(SSG)이다.
- Eleventy, Jekyll과 다르게 버전 관련 이슈가 없다.
- Hugo와 다르게 단순한 디렉토리 계층 구조를 가진다.
- 개인 Github Page등의 용도로 간단한 사이트를 생성하기에 적당하다.

[Overview](https://www.getzola.org/documentation/getting-started/overview/)

[Migrating to Zola](https://www.xypnox.com/blag/posts/migrating-to-zola/)

## Page 생성 및 실행

- 위의 Zola homepage에서 Docs를 참고하면 Zola의 설치를 어렵지 않게 할 수 있다.
- 원하는 경로에서 다음 명령어를 입력한다.
    
    ```powershell
    zola init myblog(수정가능)
    ```
    
- Zola Docs에서 설명한 요건을 충족한다면 아래 명령어를 통해 127.0.0.1(내부순환루프)에서 시뮬레이션이 가능하다.
    
    ```powershell
    zola serve
    ```
    

## Theme 적용하기

- 다른 SSG에 비해 비교적 테마 선택의 폭이 좁다는 단점이 있다.
- 개인 Github Blog용 Theme으로 DeepThought, xyblag를 사용해 보았다.
- xyblag가 깔끔하다고 판단되고 모바일에서도 정상적으로 작동하여 xyblag를 메인 테마로 사용할 예정이다.
- 하지만 xyblag테마 적용 시 글자 크기가 살짝 부담스러울 정도로 크다. 한글 폰트가 나눔 고딕이 아닌 바탕체인데 이것 역시 불편하다. 이것을 바꾸는 방법에 대해서 알아봐야 겠다.
- DeepThought의 경우 다양한 이미지가 포함된 테마이며, 많은 social link가 포함한다.
- DeepThought는 일부 환경에서 가로 폭이 너무 좁고, 양각을 표현하는 음영이 내 취향에는 맞지 않아 현재 사용하고 있지 않다. 하지만 xyblag와 달리 폰트 크기는 매우 만족스럽다.

[https://github.com/xypnox/blag](https://github.com/xypnox/blag)

[https://github.com/RatanShreshtha/DeepThought](https://github.com/RatanShreshtha/DeepThought)

- 기본적으로 Theme의 README.md를 읽어보고 따라하면 적용에는 큰 어려움이 없다.
- 하지만 github에 커밋하기 위해서는 $blogpath/theme/ 위치에서 서브모듈로 추가하는 것이 바람직하다. 아래는 이를 실행하는 코드이다.
    
    ```powershell
    cd themes
    git submodule add https://themepath
    ```
    
- 서브모듈로 theme폴더에 테마를 추가한 이후에는 다시 메인 경로에서 config.toml을 적용할 테마에 알맞은 형식으로 수정해야 한다.
- 이외에도 테마마다 필요로 하는 toml파일이 다르기 때문에 테마 템플릿의 파일 구조를 파악하여 필요한 파일을 복사해 넣어야 한다.
- blag, DeepThought는 content폴더가 비슷한 구조를 가지고 있어서 적은 비용으로 테마 변경이 가능하지만, 그렇지 않은 테마도 있으므로 잘 확인하고 적용해야 한다.
- 작동하지 않는 페이지가 있을 경우 해당 테마에서 제공하는 demo page를 확인하여 원인을 파악해야 한다.

# Github Action Configuration

## Github Action이란?

- Gtihub에서 제공하는 Auto Pipeline 기능이다.
- 자세하게는 더 알아봐야 겠지만 Github Page구축을 위한 Github Action 설정은 다음과 같다.
    - main브랜치에 push할 때마다 build해서 gh-pages브랜치에 적용
    - build는 구체적으로 zola의 기능을 이용하여 마크다운으로 기술된 포스트를 html, css, js로 변환하는 과정을 말한다.
    - github page blog를 위해서는 html을 기반으로 기술되어야 하므로 위와 같은 작업이 필요하다.

## Github Action 설정

- github repository내에 .github폴더를 생성한다.
- .github폴더 내에 workflows폴더를 생성한다.
- workflows폴더에는 main.yml파일이 있는데 이 파일을 통해 Github Action의 flow를 설정한다.
- 아래는 zola를 Github Action을 통해 커밋 즉시 페이지에 적용되도록 하는 main.yml 코드이다.
    
    ```yaml
    # On every push this script is executed
    on: push
    name: Build and deploy GH Pages
    jobs:
      build:
        runs-on: ubuntu-latest
        if: github.ref == 'refs/heads/main'
        steps:
          - name: checkout
            uses: actions/checkout@v3.0.0
          - name: build_and_deploy
            uses: shalzz/zola-deploy-action@v0.16.1
            env:
              # Target branch
              PAGES_BRANCH: gh-pages
              # Provide personal access token
              TOKEN: ${{ secrets.GITHUB_TOKEN }}
              # Or if publishing to the same repo, use the automatic token
              #TOKEN: ${{ secrets.GITHUB_TOKEN }}
    ```
    
- 자세한 yml파일의 설정 설명은 Zola docs를 참고한다.

[GitHub Pages](https://www.getzola.org/documentation/deployment/github-pages/)

## Pages 설정

- [계정이름.github.io](http://계정이름.github.io) 의 형태로 github repository를 생성한다.
- Settings의 Pages에서 Deploy from branch로 설정하고 Branch를 gh-pages로 설정한다.

# 마크다운 사용하기

- Zola(Eleventy, Jekyll역시 마찬가지이다)는 *.md파일로 페이지를 쉽고 빠르고 간단하게 작성하면 이를 static site로 변환해 주는 프레임워크이다.
- Notion등과 다르게 기본적인 마크다운 문법에 대해 숙지하고 있어야 원활한 사용이 가능하다.
- xyblag(DeepThought역시 마찬가지이다)의 tags 및 categories기능을 사용하기 위해서는 taxonomies를 설정해 주어야 한다.
- 아래와 같은 구문을 *.md파일 위에 기술하여 포스트의 제목 및 날짜, taxonomies의 설정이 가능하다.
    
    ```yaml
    +++
    title = "Post name"
    date = 2023-01-06
    
    [taxonomies]
    categories = ["category1"]
    tags = ["tag1", "tag2"]
    +++
    ```
    
- 기본적인 마크다운 문법에 관한 가이드로는 DeepThought 테마에서 템플릿 페이지로 있던 Basic Markdown Syntax를 참고하면 될 듯 하다.

[Basic Markdown Syntax](https://js970.github.io/posts/example/)

# TODO

- xyblag테마에서 한글 폰트 및 글자 크기 조정하는 방법 알아보기