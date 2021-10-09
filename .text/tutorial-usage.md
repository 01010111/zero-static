## Learning the project skeleton

To use zero-static efficiently, it's a good idea to familiarize yourself with the workspace. Let's go over each of the folders and talk about the contents of each and how they relate to the project as a whole.

### .pages

The `.pages` folder is the home to the pages of your site. They are html, and when the site is built, they are parsed and passed along to the `dist` folder. When authoring pages, you can add components and reference markdown documents to make page building easier. Let's take a look at the `index.html` page that gets generated on a new zero-static instance:

```
<!DOCTYPE html>
<html lang="en">
<head>
	%% component header.html
</head>
<body>
	%% markdown index-content.md
</body>
</html>
```

You can see it looks a lot like html, but it has a few special lines:

```
%% component header.html
```

Any line starting with `%%` tells zero-static to insert something, we call it a command block. Command blocks come in two flavors, components, and markdown. This one has three elements: 

- `%%` as we just covered just means "I am a command block!"
- `component` tells zero-static to replace this block with a component
- `header.html` tells zero-static which component to use from the `.components` folder

If you're feeling lazy (I encourage it), you could use `%% c header.html` instead! If you're feeling EXTRA lazy (why not?) omitting the command entirely will default the command block to a component command block: `%% header.html`

Checking out the other command block:

```
%% markdown index-content.md
```

We can see it's similar, but looking at the last two elements of this command block:

- `markdown` tells zero-static to replace this block with parsed markdown content
- `index-content.md` tells zero-static which markdown file to use from the `.text` folder

Again, if you're feeling lazy, you can shorten this command block to `%% md index-content.md`

### .components

The `.componenets` folder is the home to any components you'd like to make. You can think of components simply as html building blocks! They can be super utilitarian snippets of html that you want to place on every page on your site, or they can be bespoke, single use blocks of html - it's up to you!

Let's take a look at the `header.html` component that gets generated on a new zero-static instance:

```
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Hello World</title>
<link rel="stylesheet" href="style.css">
```

You can probably imagine this is a very handy component, because it contains all of the html you'd typically place in a document's `<head>` element. We can reuse this by adding `%% c header.html` to every page we make, and if we want to add a script to every page, or reference another stylesheet, or change the title of our site, we can just do it once and it'll propogate to all the pages we've added the component to!

### .text

The `.text` folder is the home to all of our markdown content. Authoring websites by hand can be a bore, and I've always loved writing using markdown, so I wanted to be able to write site content in markdown, and have that markdown parsed to html with no effort on my part. This way, content lives in it's own space, and editing it is both quick and accessible.

### .styles

The `.styles` folder is where you create your stylesheets! Every stylesheet in this folder gets bundled into one `style.css` file when your site is built, so now you can stay organized by having as many stylesheets as you need!

### .static

The `.static` folder is where you can store any files that don't get changed - they'll be moved directly into the `dist` folder when you build your site. Add whatever you need here - images, a favicon, other scripts, etc! It's a catch-all for _everything else_.

### dist

The `dist` folder is where your site gets built to! Dist is short for "distributable" - which means if you're uploading your site somewhere, you'd want to upload the contents of this folder.

## Advanced Usage

Here are a few tips for advanced usage!

If you don't want to author your content in markdown, you can simply remove the `-lib markdown` from your `build.hxml` file.

If you'd like a handy github action to push the `dist` folder to a `gh-pages` branch for super easy static webpage hosting, add the following to your `build.hxml`:

```
-D GH_PAGES
```

Don't forget, you can nest components inside other components, just be careful not to make a loop by referencing a component inside itself!