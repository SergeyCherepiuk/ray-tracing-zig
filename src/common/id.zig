const std = @import("std");
const prng = std.rand.DefaultPrng;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

// NOTE: Not thread-safe
var registry = std.AutoHashMap(u64, void).init(allocator);

pub fn new() u64 {
    const now: u64 = @intCast(std.math.absInt(std.time.timestamp()) catch 0);
    var rnd = prng.init(now);

    return while (true) {
        const temp_id = rnd.random().uintAtMost(u64, std.math.maxInt(u64));
        const available = registry.get(temp_id) == null;
        if (available) {
            registry.put(temp_id, {}) catch unreachable;
            break temp_id;
        }
    };
}
