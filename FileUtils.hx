using sys.FileSystem;
using sys.io.File;

function copy_folder(from:String, to:String) {
	if (from.charAt(from.length - 1) == '/') from = from.substr(0, from.length - 1);
	if (to.charAt(to.length - 1) == '/') to = to.substr(0, to.length - 1);
	if (!to.exists()) to.createDirectory();
	for (file in from.readDirectory()) {
		if ('$from/$file'.isDirectory()) {
			'$to/$file'.createDirectory();
			copy_folder('$from/$file', '$to/$file');
		}
		else '$to/$file'.saveBytes('$from/$file'.getBytes());
	}
}

function delete_folder(path:String) {
	if (!path.exists()) return;
	if (path.charAt(path.length - 1) == '/') path = path.substr(0, path.length - 1);
	for (file in path.readDirectory()) {
		if ('$path/$file'.isDirectory()) delete_folder('$path/$file');
		else '$path/$file'.deleteFile();
	}
}