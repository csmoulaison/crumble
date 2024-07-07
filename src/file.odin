package main
import "core:fmt"
import "core:os"

write_bytes_to_file :: proc(path: string, data: []u8) {
	success := os.write_entire_file(path, data)
	if !success {
		fmt.println("Error reading file") 
		return
	}
}

get_bytes_from_file :: proc(path: string) -> []u8 {
	data, success := os.read_entire_file_from_filename(path)
	if !success {
		fmt.println("Error reading file") 
		return nil
	}
	return data
}
