#![recursion_limit = "512"]
mod app;

fn main() {
    yew::start_app::<app::Model>();
}