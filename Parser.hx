using StringTools;
using Reflect;

function parse_content(content:String, tabs:Int = 0) {
	var lines = content.split('\n');
	for (i in 0...lines.length) if (lines[i].contains('%%')) {
		var line = lines[i];
		var tab_len = 0;
		while (line.charAt(tab_len) == '\t') tab_len++;
		var command = get_command_data(line.replace('%%', '').trim());
		var text = switch command.type {
			case 'component', 'c': parse_content(get_component(command.data));
			#if markdown 
			case 'markdown', 'md': get_markdown(command.data);
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
		data: parsed.length > 1 ? parsed[1] : parsed[0],
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

function unknown_command(component:String, command:String) {
	trace('Unknown command "$command" on component: $component');
	return '<!-- unknown command "$command $component" -->';
}

function apply_tabs(text:String, tabs:Int) {
	var lines = text.split('\n');
	var tab_str = '';
	for (i in 0...tabs) tab_str += '\t';
	for (i in 0...lines.length) {
		var line = lines[i];
		lines[i] = tab_str + line;
	}
	return lines.join('\n');
}