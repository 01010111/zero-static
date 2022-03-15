import BlogUtils.Post;
using StringTools;
using Reflect;
using Tools;

function parse_content(content:String, tabs:Int = 0, ?post_src:String) {
	var lines = content.split('\n');
	for (i in 0...lines.length) if (lines[i].contains('%%')) {
		var line = lines[i];
		var tab_len = 0;
		while (line.charAt(tab_len) == '\t') tab_len++;
		var command = get_command_data(line.replace('%%', '').trim());
		var text = switch command.type {
			case 'component', 'c': parse_content(get_component(command.data), 0, post_src);
			#if markdown 
			case 'markdown', 'md': get_markdown(command.data);
			#end
			#if BLOG
			case 'post', 'p': handle_post_command(command.data, post_src);
			#end
			default: unknown_command(command.data, command.type);
		}
		text = apply_tabs(text,tab_len);
		lines[i] = text;
	}
	return lines.join('\n');
}

function get_command_data(s:String) {
	var parsed = s.split(' ');
	return {
		type: parsed.length > 1 ? parsed[0] : 'component',
		data: parsed.length > 1 ? parsed.slice(1).join(' ') : parsed[0],
	};
}

function get_component(component:String) {
	if (!Data.components.exists(component)) {
		trace('Component does not exist: $component');
		return '<!-- missing component "$component" -->';
	}
	return Data.components[component];
}

#if markdown
function get_markdown(component:String) {
	if (!Data.markdown.exists(component)) {
		trace('Markdown does not exist: $component');
		return '<!-- missing text "$component" -->';
	}
	return Markdown.markdownToHtml(Data.markdown[component]);
}
#end

#if BLOG
function handle_post_command(str:String, ?src:String) {
	if (src == null) src = str.split(' ').last_index();
	var sub_command = 'content';
	if (['title', 'date', 'author', 'tags', 'list', 'content', 'url', 'summary'].contains(str.split(' ')[0])) sub_command = str.split(' ')[0];
	if (!['list'].contains(sub_command) && !Data.posts.exists(src)) {
		trace('Unable to parse post command, post $src does not exist');
		return '';
	}
	switch sub_command {
		case 'title': return Data.posts[src].title;
		case 'date': return Data.posts[src].date;
		case 'author': return Data.posts[src].author;
		case 'tags': return '<ul><li>${Data.posts[src].tags.join('</li><li>')}</li></ul>';
		case 'list': return get_post_list();
		case 'url': return Data.posts[src].url;
		#if markdown
		case 'content': return Markdown.markdownToHtml(Data.posts[src].content);
		case 'summary': return Markdown.markdownToHtml(Data.posts[src].summary);
		#else
		case 'content': return Data.posts[src].content;
		case 'summary': return Data.posts[src].summary;
		#end
		default: return '';
	}
}

function get_post_list() {
	var out = '';
	var post_arr:Array<{title:String, post:Post}> = [];
	for (title => post in Data.posts) post_arr.push({title:title, post:post});
	post_arr.sort((e1, e2) -> e1.post.date_int > e2.post.date_int ? -1 : 1);
	for (e in post_arr) out += parse_content(Data.components['post-list-template.html'], 0, e.title);
	return out;
}
#end

function unknown_command(component:String, command:String) {
	trace('Unknown command "$command" on component: $component');
	return '<!-- unknown command "$command $component" -->';
}

function apply_tabs(text:String, tabs:Int) {
	var lines = text.split('\n');
	var tab_str = '';
	for (i in 0...tabs) tab_str += '\t';
	var do_add = true;
	for (i in 0...lines.length) {
		var line = lines[i];
		if (line.contains('<code>') && !line.contains('</code>')) do_add = false;
		if (do_add) lines[i] = tab_str + line;
		if (line.contains('</code>') && !line.contains('<code>')) do_add = true;
	}
	return lines.join('\n');
}