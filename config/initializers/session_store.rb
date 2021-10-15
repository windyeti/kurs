# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_myappda_session', domain: {
    production:   '167.172.160.127',
    staging:      '.k-comment.ru',
    development:  '.lvh.me'
    # development:  '.k-comment.ru'
}.fetch(Rails.env.to_sym, :all)
