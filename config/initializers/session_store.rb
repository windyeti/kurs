# Be sure to restart your server when you modify this file.
# TODO 167.172.160.127 заменить на имя домена
Rails.application.config.session_store :cookie_store, key: '_myappda_session', domain: {
    production:   '.irbandtest.ru',
    staging:      '.k-comment.ru',
    development:  '.lvh.me'
    # development:  '.k-comment.ru'
}.fetch(Rails.env.to_sym, :all)

# Rails.application.config.session_store :cookie_store, key: '_kurs_session', domain: :all, tld_length: 2
# Kurs::Application.config.session_store :cookie_store, key: '_kurs_session', domain: :all, tld_length: 2
