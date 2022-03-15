import sys.io.File;
import sys.FileSystem;

var workspace_dirs = [
	'.pages',
	'.components',
	'.styles',
	'.static',
	#if markdown
	'.text',
	#end
	#if BLOG
	'.posts',
	#end
];

function init() {
	var first_run = false;
	
	// Create directories if none exist
	for (dir in workspace_dirs) {
		if (!FileSystem.exists(dir)) {
			trace('initializing workspace folder $dir...');
			FileSystem.createDirectory(dir);
			first_run = true;
		}
	}

	#if GH_PAGES
	if (!FileSystem.exists('.github/workflows/deploy.yml')) {
		trace('initializing github action `.github/workflows/deploy.yml`');
		FileSystem.createDirectory('.github/workflows');
		File.saveContent('.github/workflows/deploy.yml', Content.deploy_yml);
	}
	#end

	if (!first_run) return;

	// Create index.html if it doesn't exist
	if (!FileSystem.exists('.pages/index.html')) {
		trace('initializing `.pages/index.html`');
		File.saveContent('.pages/index.html', Content.index_html);
	}
	
	// Create global.css if it doesn't exist
	if (!FileSystem.exists('.styles/global.css')) {
		trace('initializing `.styles/global.css`');
		File.saveContent('.styles/global.css', Content.global_css);
	}

	// Create header.html component if it doesn't exist
	if (!FileSystem.exists('.components/header.html')) {
		trace('initializing component `.components/header.html`');
		File.saveContent('.components/header.html', Content.header_html);
	}

	#if markdown
	// Create index-content.md if it doesn't exist
	if (!FileSystem.exists('.text/index-content.md')) {
		trace('initializing markdown `.text/index-content.md`');
		File.saveContent('.text/index-content.md', Content.index_content_md);
	}
	#end

	#if BLOG
	// Create first-post.md if it doesn't exist
	if (!FileSystem.exists('.posts/first-post.md')) {
		trace('initializing post `.posts/first-post.md`');
		File.saveContent('.posts/first-post.md', Content.first_post_md);
	}

	// Create post-template.html if it doesn't exist
	if (!FileSystem.exists('.components/post-template.html')) {
		trace('initializing post template `.components/post-template.html`');
		File.saveContent('.components/post-template.html', Content.post_template_html);
	}

	// Create header.html component if it doesn't exist
	if (!FileSystem.exists('.components/post-list-template.html')) {
		trace('initializing component `.components/post-list-template.html`');
		File.saveContent('.components/post-list-template.html', Content.post_list_template);
	}	
	#end

}