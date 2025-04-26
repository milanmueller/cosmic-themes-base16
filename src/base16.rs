use cosmic_theme::palette::Srgb;
use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Deserialize)]
pub(crate) struct Base16Theme {
    pub base00: Srgb<f32>, // Background
    pub base01: Srgb<f32>, // Lighter background
    pub base02: Srgb<f32>, // Selection background
    pub base03: Srgb<f32>, // Comments, invisibles
    pub base04: Srgb<f32>, // Dark foreground
    pub base05: Srgb<f32>, // Default foreground
    pub base06: Srgb<f32>, // Light foreground
    pub base07: Srgb<f32>, // Light background
    pub base08: Srgb<f32>, // Red
    pub base09: Srgb<f32>, // Orange
    pub base0a: Srgb<f32>, // Yellow
    pub base0b: Srgb<f32>, // Green
    pub base0c: Srgb<f32>, // Cyan
    pub base0d: Srgb<f32>, // Blue
    pub base0e: Srgb<f32>, // Purple
    pub base0f: Srgb<f32>, // Brown
}
// Structs needed for yaml parsing
#[derive(Debug, Deserialize, Serialize)]
struct Base16YamlScheme {
    system: String,
    name: String,
    author: String,
    variant: String,
    palette: Base16YamlPalette,
}

#[derive(Debug, Deserialize, Serialize)]
#[allow(non_snake_case)]
struct Base16YamlPalette {
    base00: String,
    base01: String,
    base02: String,
    base03: String,
    base04: String,
    base05: String,
    base06: String,
    base07: String,
    base08: String,
    base09: String,
    base0A: String,
    base0B: String,
    base0C: String,
    base0D: String,
    base0E: String,
    base0F: String,
}

impl Base16Theme {
    /// Parse base16 theme from list of string.
    /// Input is assumed to be exatly 16 strings for the grammar
    /// digit ::= 0-9 | a-f | A-F
    /// base16 ::= #<digit><digit><digit><digit><digit><digit>
    /// The colors will be parsed in ascending order (i.e. from base00 to base0f).
    ///
    /// # Errors
    ///
    /// This function will return an error if the input does not satisfy the grammar above
    /// or if there are not exactly 16 colors given.
    pub(crate) fn from_args(args: &[String]) -> Result<Self, Box<dyn std::error::Error>> {
        if args.len() != 16 {
            // 16 colors + program name
            return Err(format!("Expected 16 hex colors as arguments, got {}", args.len()).into());
        }
        // We can now assume args.len() == 17
        // Verify the colors
        let colors: Vec<Srgb<f32>> = args[0..16]
            .into_iter()
            .map(|arg| -> Result<Srgb<f32>, Box<dyn std::error::Error>> {
                let color_u8 = arg.parse::<Srgb<u8>>()?;
                Ok(color_u8.into())
            })
            .collect::<Result<Vec<_>, _>>()?;
        Ok(Base16Theme {
            base00: colors[0],
            base01: colors[1],
            base02: colors[2],
            base03: colors[3],
            base04: colors[4],
            base05: colors[5],
            base06: colors[6],
            base07: colors[7],
            base08: colors[8],
            base09: colors[9],
            base0a: colors[10],
            base0b: colors[11],
            base0c: colors[12],
            base0d: colors[13],
            base0e: colors[14],
            base0f: colors[15],
        })
    }

    // Parse from YAML file
    pub(crate) fn from_yaml_file(path: &str) -> Result<Self, Box<dyn std::error::Error>> {
        let file = std::fs::File::open(path)?;
        let theme: Base16YamlScheme = serde_yaml::from_reader(file)?;
        let c00: Srgb<u8> = theme.palette.base00.parse::<Srgb<u8>>()?;
        let c01: Srgb<u8> = theme.palette.base01.parse::<Srgb<u8>>()?;
        let c02: Srgb<u8> = theme.palette.base02.parse::<Srgb<u8>>()?;
        let c03: Srgb<u8> = theme.palette.base03.parse::<Srgb<u8>>()?;
        let c04: Srgb<u8> = theme.palette.base04.parse::<Srgb<u8>>()?;
        let c05: Srgb<u8> = theme.palette.base05.parse::<Srgb<u8>>()?;
        let c06: Srgb<u8> = theme.palette.base06.parse::<Srgb<u8>>()?;
        let c07: Srgb<u8> = theme.palette.base07.parse::<Srgb<u8>>()?;
        let c08: Srgb<u8> = theme.palette.base08.parse::<Srgb<u8>>()?;
        let c09: Srgb<u8> = theme.palette.base09.parse::<Srgb<u8>>()?;
        let c0a: Srgb<u8> = theme.palette.base0A.parse::<Srgb<u8>>()?;
        let c0b: Srgb<u8> = theme.palette.base0B.parse::<Srgb<u8>>()?;
        let c0c: Srgb<u8> = theme.palette.base0C.parse::<Srgb<u8>>()?;
        let c0d: Srgb<u8> = theme.palette.base0D.parse::<Srgb<u8>>()?;
        let c0e: Srgb<u8> = theme.palette.base0E.parse::<Srgb<u8>>()?;
        let c0f: Srgb<u8> = theme.palette.base0F.parse::<Srgb<u8>>()?;
        Ok(Base16Theme {
            base00: c00.into(),
            base01: c01.into(),
            base02: c02.into(),
            base03: c03.into(),
            base04: c04.into(),
            base05: c05.into(),
            base06: c06.into(),
            base07: c07.into(),
            base08: c08.into(),
            base09: c09.into(),
            base0a: c0a.into(),
            base0b: c0b.into(),
            base0c: c0c.into(),
            base0d: c0d.into(),
            base0e: c0e.into(),
            base0f: c0f.into(),
        })
    }
}
