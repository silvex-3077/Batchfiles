use arboard::Clipboard;
use bpaf::Bpaf;

#[derive(Clone, Debug, Bpaf)]
#[bpaf(options, version)]
struct Opts {
    #[bpaf(short, long, fallback(" ".to_string()))]
    delimiter: String,

    #[bpaf(short, long)]
    markdown: bool,

    #[bpaf(short('n'), long("dry-run"))]
    dry_run: bool,
}

fn main() {
    let opts = opts().run();

    let mut clipboard = match Clipboard::new() {
        Ok(c) => c,
        Err(e) => {
            eprintln!("[Error] Failed to access clipboard: {}", e);
            std::process::exit(1);
        }
    };

    let text = match clipboard.get_text() {
        Ok(t) => t,
        Err(_) => {
            eprintln!("[Error] Clipboard is empty or not text.");
            std::process::exit(1);
        }
    };

    let lines: Vec<&str> = text
        .lines()
        .map(|line| line.trim())
        .filter(|line| !line.is_empty())
        .collect();

    if lines.is_empty() {
        eprintln!("[Error] No vaild text found.");
        std::process::exit(1);
    }

    let mut output = Vec::new();
    let mut i = 0;

    while i < lines.len() {
        if i + 1 < lines.len() {
            let title = lines[i];
            let url = lines[i+1];

            let formatted = if opts.markdown {
                format!("[{}]({})", title, url)
            } else {
                format!("[{}{}{}]", title, opts.delimiter, url)
            };

            output.push(formatted);
            i += 2;
        } else {
            eprintln!("[Warning] Skipped title without paired URL: {}", lines[i]);
            break;
        }
    }

    if output.is_empty() {
        eprintln!("[Error] No vaild to Title / URL pairs found.");
        std::process::exit(1);
    }

    let result = output.join("\n");

    if opts.dry_run {
        println!("--- Dry Run Result ---");
        println!("{}", result);
        println!("----------------------")
    } else {
        if let Err(e) = clipboard.set_text(result) {
            eprintln!("[Error] Failed to write to clipboard: {}", e);
        } else {
            println!("[Success] Converted to clipboard format!");
        }
    }
}
