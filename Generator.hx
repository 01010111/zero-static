import BlogUtils.parse_post;
import haxe.Timer;
using sys.io.File;
using sys.FileSystem;
using Reflect;
using StringTools;
using Math;

function run() {
	var t = Timer.stamp();
	initialize_dist();
	move_static_content();
	generate_stylesheet();
	set_pages();
	set_components();
	set_markdown();
	#if BLOG
	set_posts();
	generate_posts();
	#end
	generate_pages();
	var diff = Timer.stamp() - t;
	diff = (diff * 10.pow(4)).round() / 10.pow(4);
	trace('Site built in $diff seconds!');
}

function initialize_dist() {
	FileUtils.delete_folder('dist');
	'dist'.createDirectory();
}

function move_static_content() {
	FileUtils.copy_folder('.static', 'dist');
}

function generate_stylesheet() {
	var stylesheet = '';
	for (file in '.styles'.readDirectory()) {
		var content = '/* $file */\n\n';
		content += '.styles/$file'.getContent();
		content += '\n\n';
		stylesheet += content;
	}
	File.saveContent('dist/style.css', stylesheet);
}

function set_pages() {
	for (file in '.pages'.readDirectory()) {
		Data.pages.set(file, '.pages/$file'.getContent());
	}
}

function set_components() {
	for (file in '.components'.readDirectory()) {
		Data.components.set(file, '.components/$file'.getContent());
	}
}

function set_markdown() {
	for (file in '.text'.readDirectory()) {
		Data.markdown.set(file, '.text/$file'.getContent());
	}
}

function set_posts() {
	for (file in '.posts'.readDirectory()) {
		Data.posts.set(file, BlogUtils.parse_post('.posts/$file'.getContent(), file));
	}
}

function generate_pages() {
	for (file => content in Data.pages) {
		if (file.indexOf('.content') == 0) file = file.split('/').slice(1).join('/');
		if (file.contains('/') && !FileSystem.exists(file.split('/').slice(0, -1).join('/'))) FileSystem.createDirectory('dist/' + file.split('/').slice(0, -1).join('/'));
		'dist/$file'.saveContent(Parser.parse_content(content));
	}
}

function generate_posts() {
	for (title => post in Data.posts) {
		if (title.indexOf('.content') == 0) title = title.split('/').slice(1).join('/');
		if (title.contains('/') && !FileSystem.exists(title.split('/').slice(0, -1).join('/'))) FileSystem.createDirectory('dist/' + title.split('/').slice(0, -1).join('/'));
		var file = title.replace('.md', '.html');
		'dist/$file'.saveContent(Parser.parse_content(Data.components['post-template.html'], title));
	}
}