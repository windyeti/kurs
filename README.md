# README

* Расшарить [аутентификацию/сессию Devise](https://stackoverflow.com/questions/10402777/share-session-cookies-between-subdomains-in-rails) на все поддомены.

* Сессия храниться в свойстве куки, которое указано в session_store, для каждого окружения свое. <br>
После привязки имени домена надо указаеть имя в этом свойстве для окружения production.
