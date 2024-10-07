# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# following removes the rgb #green error that comes when tailwindcss-rails and sass-rails are installed together (however both are needed to make both the app and activeadmin run together)
Rails.application.config.assets.css_compressor = nil