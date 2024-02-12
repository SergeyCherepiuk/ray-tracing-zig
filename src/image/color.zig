pub const Color = struct {
    R: u8 = 0,
    G: u8 = 0,
    B: u8 = 0,

    pub fn equals(self: Color, other: Color) bool {
        return self.R == other.R and
            self.G == other.G and
            self.B == other.B;
    }

    pub fn add(self: Color, other: Color) Color {
        return Color{
            .R = @min(@as(u64, self.R) + other.R, 255),
            .G = @min(@as(u64, self.G) + other.G, 255),
            .B = @min(@as(u64, self.B) + other.B, 255),
        };
    }

    pub fn scale(self: Color, factor: f64) Color {
        if (factor <= 0.0) return Color{};

        const R_scaled = @as(f64, @floatFromInt(self.R)) * factor;
        const G_scaled = @as(f64, @floatFromInt(self.G)) * factor;
        const B_scaled = @as(f64, @floatFromInt(self.B)) * factor;
        return Color{
            .R = @min(@as(u64, @intFromFloat(R_scaled)), 255),
            .G = @min(@as(u64, @intFromFloat(G_scaled)), 255),
            .B = @min(@as(u64, @intFromFloat(B_scaled)), 255),
        };
    }
};
