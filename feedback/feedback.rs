use clap::Parser;
use config::Config;
use lettre::transport::smtp::authentication::Credentials;
use lettre::{Message, SmtpTransport, Transport};
use serde::Deserialize;
use std::env;
use std::io::{self, Read};

#[derive(Deserialize)]
struct SmtpConfig {
    server: String,
    username: String,
    password: String,
    recipient: String,
}

#[derive(Deserialize)]
struct AppConfig {
    smtp: SmtpConfig,
}

#[derive(Deserialize)]
struct FeedbackData {
    feedback: String,
    referrer: String,
}

#[derive(Parser, Debug)]
#[clap(version)]
struct Args {
    #[clap(short, long, default_value = "config.toml", help = "Path to config")]
    config: std::path::PathBuf,
}

fn main() {
    let args = Args::parse();

    println!("Content-Type: text/html\n");

    let config = if let Some(path_str) = args.config.to_str() {
        let config = load_config(path_str.to_string()).unwrap_or_else(|e| {
            println!("Error loading configuration: {}", e);
            std::process::exit(1);
        });
        config
    } else {
        println!("Couldn't find configuration file");
        std::process::exit(1);
    };

    let content_length = match env::var("CONTENT_LENGTH") {
        Ok(val) => val.parse::<usize>().unwrap_or(0),
        Err(_) => 0,
    };

    // Read the POST data
    let post_data = if content_length > 0 {
        let mut buffer = String::new();
        io::stdin()
            .take(content_length as u64)
            .read_to_string(&mut buffer)
            .unwrap();
        buffer
    } else {
        let mut buffer = String::new();
        io::stdin().read_to_string(&mut buffer).unwrap();
        buffer
    };

    let json_data: Result<FeedbackData, serde_json::Error> = serde_json::from_str(&post_data);

    match json_data {
        Ok(feedback_data) => {
            let email_result =
                send_email(feedback_data.feedback, feedback_data.referrer, &config.smtp);

            match email_result {
                Ok(_) => println!("<h1>Thank you for your feedback!</h1>"),
                Err(e) => {
                    println!("<h1>Error sending email: {}</h1>", e);
                }
            }
        }
        Err(_) => {
            println!("<h1>Error parsing feedback data. Please ensure the correct format. </h1>");
        }
    }
}

fn send_email(
    feedback: String,
    referrer: String,
    smtp_config: &SmtpConfig,
) -> Result<(), Box<dyn std::error::Error>> {
    let email = Message::builder()
        .from(smtp_config.username.parse()?)
        .to(smtp_config.recipient.parse()?)
        .subject("Website Feedback")
        .body(format!(
            "Feedback:\n{}\n\nReferrer:\n{}",
            feedback, referrer
        ))?;

    let creds = Credentials::new(smtp_config.username.clone(), smtp_config.password.clone());
    let mailer = SmtpTransport::relay(&smtp_config.server)?
        .credentials(creds)
        .build();

    mailer.send(&email)?;

    Ok(())
}

fn load_config(path: String) -> Result<AppConfig, config::ConfigError> {
    let settings = Config::builder()
        .add_source(config::File::with_name(&path).required(true))
        .build()?;

    settings.try_deserialize::<AppConfig>()
}
