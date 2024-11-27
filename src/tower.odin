package main
import "core:mem"
import "core:os"

MAX_TOWER_LEVELS :: 32
TOWER_COUNT :: 3
MAIN_SEQUENCE_PATH :: "sequences/main"
MAIN_SEQUENCE_FNAME :: "sequences/main/sequence.seq"

Tower :: struct {
	levels: [MAX_TOWER_LEVELS]int,
	len: int,
}

TowerSequence :: struct {
	towers: [TOWER_COUNT]Tower,
}

serialize_tower_sequence :: proc(data: ^TowerSequence) -> (ok: bool) {
	bytes := mem.byte_slice(data, size_of(TowerSequence))
    return os.write_entire_file(MAIN_SEQUENCE_FNAME, bytes)
}

deserialize_tower_sequence :: proc(result: ^TowerSequence) -> (ok: bool) {
    data, read_ok := os.read_entire_file(MAIN_SEQUENCE_FNAME)
    if !read_ok {
       return false
    }
	result^ = (^TowerSequence)(raw_data(data))^
    return true
}
