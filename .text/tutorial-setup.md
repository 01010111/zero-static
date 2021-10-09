## Setting up Haxe and Dependencies

Before starting on your website, you need a few things. First, you'll need to download Haxe - an open source programming language and compiler. This is what zero-static uses to build your websites.

[Download Haxe here](https://haxe.org/)

After downloading and installing haxe, you'll need to install two haxe libraries, first we'll install `markdown`, which will enable zero-static to parse markdown files into html - open a terminal/console window and type:

```
haxelib install markdown
```

When that has completed, install zero-static by typing:

```
haxelib git zero-static https://github.com/01010111/zero-static
```

You'll probably want an IDE or code editor as well - I recommend [Visual Studio Code](https://code.visualstudio.com/).

If you do use Visual Studio Code, be sure to install the Haxe extension!

## Spinning up a project

Now that you have your development environment set up and ready, we can spin up a new project! Create a folder for your project, and create a file called `build.hxml`. An HXML file can store haxe compiler arguments so that it's easier to build. Inside `build.hxml` write the following:

```
-lib zero-static
 -lib markdown
```

This tells the haxe compiler to include these two libraries. Now all you have to do is compile - in a terminal/console window, make sure you're in your project folder, and type:

```
haxe build.hxml
```

Assuming things were set up right, you should now have everything you need to get started working! Your project folder should look something like this:

📁 my-project  
- 📁 .components  
- - 📄 header.html  
- 📁 .pages  
- - 📄 index.html  
- 📁 .static  
- 📁 .styles  
- - 📄 global.css  
- 📁 .text  
- - 📄 index-content.md  
- 📁 dist  
- - 📄 index.html  
- - 📄 style.css  
- 📄 build.hxml  

## Troubleshooting

Did something wrong happen? Try the following:

- Make sure haxe was installed by opening a terminal/console and typing `haxe --version`
- Make sure the libraries were installed by opening a terminal/console and typing `haxelib list`
- Make sure you ran `haxe build.hxml` from the correct directory
- Make sure you have write permissions for your project's directory