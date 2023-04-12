function last_index<T>(arr:Array<T>):T {
	return arr[arr.length-1];
}

function shift_arr_return<T>(arr:Array<T>):Array<T> {
	if (arr.length < 2) return [];
	return [for (i in 1...arr.length) arr[i]];
}