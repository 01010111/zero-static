var index_html = '<!DOCTYPE html>
<html lang="en">
<head>
	%% component header.html
</head>
<body>
	%% markdown index-content.md
</body>
</html>';

var global_css = '* {
	margin: 0;
	padding: 0;
	-moz-box-sizing: border-box; 
	-webkit-box-sizing: border-box; 
	box-sizing: border-box; 
}';

var header_html = '<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hello World</title>
<link rel="stylesheet" href="style.css">';

var index_content_md = '# Hello World

This is my new website!';

var first_post_md = 'Title: My First Post
Author: 01010111
Date: 3-9-2022
Tags: first, miscellaneous
---
Hello World! This is my first blog post!
';

var post_template_html = '<!DOCTYPE html>
<html lang="en">
<head>
	%% component header.html
</head>
<body>
	<h1>
    %% post title
  </h1>
  <h3>
    %% post date
    %% post author
  </h3>
    %% post body
</body>
</html>';

var post_list_template = '
<a href="
  %% post url
">
  <div>
    <h1>
      %% post title
    </h1>
    <h3>
      %% post date
      %% post author
    </h3>
  </div>
</a>
';

var deploy_yml = "name: Build and Deploy
on: [push]
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout 👀
      uses: actions/checkout@v2.3.1
    
    - name: Setup Haxe 🚧
      uses: krdlab/setup-haxe@v1
  
    - name: Setup libs 📚
      run: |
        haxelib git zero-static https://github.com/01010111/zero-static --always --quiet
        haxelib install markdown --always --quiet
  
    - name: Build 🔨
      run: |
        haxe -lib zero-static -lib markdown
  
    - name: Push changes 🏃‍♀️
      uses: ad-m/github-push-action@master
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        branch: ${{ github.ref }}
        force: true
    
    - name: Deploy to GitHub Pages 🚀
      uses: Cecilapp/GitHub-Pages-deploy@v3
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        email: me@mysite.com
        build_dir: dist
        jekyll: no";