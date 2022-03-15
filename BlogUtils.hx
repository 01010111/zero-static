import Data.posts;
using StringTools;
using Math;
using Std;

typedef Post = {
	title:String,
	author:String,
	date:String,
	tags:Array<String>,
	content:String,
	url:String,
	date_int:Int,
	summary:String,
}

function parse_post(data:String, src:String) {
	var meta_str = data.split('---')[0].split('\n');
	var content = data.split('---').slice(1).join('---');
	var u_no = 1;
	for (title => post in posts) if (title.indexOf('Untitled') == 0) u_no++;
	var post:Post = {
		title: 'Untitled$u_no',
		author: 'Anonymous',
		date: 'No Date',
		tags: [],
		content: content,
		url: src.replace('.md', '.html'),
		date_int: 0,
		summary: '',
	}
	for (line in meta_str) {
		var field = line.split(':')[0];
		var value = line.split(':').slice(1).join(':').trim();
		switch field.toLowerCase() {
			case 'title': post.title = value;
			case 'author': post.author = value;
			case 'date': post.date = value;
			case 'tags': post.tags = value.split(',');
			case 'summary': post.summary = value;
		}
	}
	if (post.date != 'No Date') {
		var date_int = 0;
		var date_arr = post.date.split('-');
		if (date_arr.length == 3 && !date_arr[0].parseInt().isNaN() && !date_arr[1].parseInt().isNaN() && !date_arr[2].parseInt().isNaN()) {
			date_int += date_arr[0].parseInt() * 100;
			date_int += date_arr[1].parseInt();
			date_int += date_arr[2].parseInt() * 10000;
		}
		post.date_int = date_int;
	}
	if (post.summary.length == 0) {
		post.summary = generate_post_summary(post.content);
	}
	if (post.tags != null) for (tag in post.tags) tag = tag.trim();
	return post;
}

function generate_post_summary(content:String) {
	var lines = content.split('\n');
	var out = [];
	for (line in lines) if (['!', '#'].indexOf(line.charAt(0)) < 0) out.push(line);
	return out.join('\n').substr(0, 140) + '...';
}