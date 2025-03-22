use std::{fs, path::Path};

use base16::Base16Theme;
use cosmic_config::CosmicConfigEntry;
use cosmic_theme::{palette::WithAlpha, Theme, ThemeBuilder};

mod base16;

// Serialize arbitrary nested object into a folder, s.t. each member is serialized
// into an individual file. (This is what cosmic-settings does when applying themes)
macro_rules! serialize_to_folder {
    // Base case: serialize a single struct into a folder
    ($value:expr, $path:expr, { $($field:ident),* }) => {
        {
            let path = $path;
            fs::create_dir_all(&path)?;

            // Serialize each field
            $(
                serialize_to_folder!(@field $value.$field, path.join(stringify!($field)));
            )*

            // Ok::<(), Box<dyn Error>>(())
        }
    };

    // Handle individual fields
    (@field $field_value:expr, $field_path:expr) => {
        fs::write(
            $field_path,
            ron::ser::to_string_pretty(
                &$field_value,
                ron::ser::PrettyConfig::new()
            )?
        )?;
    };
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Parse Command line arguments into a base16 color scheme
    let args: Vec<String> = std::env::args().collect();

    println!("number of args: {}", args.len());

    let mode_str = match args.get(1) {
        Some(s) => s.as_str(),
        None => {
            eprintln!(
                "Usage: {} light|dark <base00> <base01> ... <base0f> OR {} light|dark <yaml_file>",
                args[0], args[0]
            );
            std::process::exit(1);
        }
    };
    let is_dark = match mode_str {
        "light" => false,
        "dark" => true,
        _ => {
            eprintln!(
                "Usage: {} light|dark <base00> <base01> ... <base0f> OR {} light|dark <yaml_file>",
                args[0], args[0]
            );
            std::process::exit(1);
        }
    };

    // Either parse 16 given color codes, or one given yaml file
    let theme = match args.len() {
        18 => Base16Theme::from_args(&args[2..])?,
        3 => Base16Theme::from_yaml_file(&args[2])?,
        _ => {
            eprintln!(
                "Usage: {} light|dark <base00> <base01> ... <base0f> OR {} light|dark <yaml_file>",
                args[0], args[0]
            );
            std::process::exit(1);
        }
    };
    println!("{:?}", theme);

    // Create theme

    // Set base colors
    let mut builder = match is_dark {
        true => ThemeBuilder::dark(),
        false => ThemeBuilder::light(),
    }
    .bg_color(theme.base00.with_alpha(1.0_f32))
    .accent(theme.base08)
    .text_tint(theme.base05);
    // Set palette
    builder.palette.as_mut().accent_red = theme.base08.with_alpha(1.0_f32);
    builder.palette.as_mut().accent_orange = theme.base09.with_alpha(1.0_f32);
    builder.palette.as_mut().accent_yellow = theme.base0a.with_alpha(1.0_f32);
    builder.palette.as_mut().accent_green = theme.base0b.with_alpha(1.0_f32);
    builder.palette.as_mut().accent_indigo = theme.base0c.with_alpha(1.0_f32);
    builder.palette.as_mut().accent_blue = theme.base0d.with_alpha(1.0_f32);
    builder.palette.as_mut().accent_purple = theme.base0e.with_alpha(1.0_f32);
    builder.palette.as_mut().accent_pink = theme.base0f.with_alpha(1.0_f32);

    serialize_to_folder!(builder, Path::new("output/builder"), {
        accent,
        bg_color,
        palette,
        text_tint });

    // Write Builder Config to config directory
    // let builder_config = if is_dark {
    //     ThemeBuilder::dark_config()?
    // } else {
    //     ThemeBuilder::light_config()?
    // };
    // builder.write_entry(&builder_config)?;
    // Create theme from builder and write it to config files
    let theme = builder.build();
    serialize_to_folder!(theme, Path::new("output/theme"), {
        accent,
        accent_button,
        accent_text,
        active_hint,
        background,
        button,
        destructive,
        destructive_button,
        icon_button,
        is_dark,
        is_frosted,
        is_high_contrast,
        link_button,
        palette,
        primary,
        secondary,
        shade,
        success,
        success_button,
        text_button,
        warning,
        warning_button,
        window_hint });
    // let theme_config = if is_dark {
    //     Theme::dark_config()?
    // } else {
    //     Theme::light_config()?
    // };
    // theme.write_entry(&theme_config)?;
    Ok(())
}
