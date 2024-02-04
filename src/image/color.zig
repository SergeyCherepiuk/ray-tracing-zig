var rng = @import("std").rand.DefaultPrng.init(0);

pub const Color = struct {
    R: u8 = 0,
    G: u8 = 0,
    B: u8 = 0,

    pub fn random() Color {
        return Color{
            .R = rng.random().int(u8),
            .G = rng.random().int(u8),
            .B = rng.random().int(u8),
        };
    }
};
