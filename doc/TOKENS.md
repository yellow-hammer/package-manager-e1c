# Токены и доступы

`package-manager` должен работать с публичными источниками без токена и с приватными источниками через явно настроенный токен.

## GitLab: чтение packages из 1С

Для приватного GitLab-проекта нужен **Project Access Token** или **Personal Access Token**.

Где создавать:

- GitLab project → **Settings** → **Access Tokens**, если токен нужен только для одного проекта.
- GitLab user → **Preferences** → **Access Tokens**, если токен должен читать несколько проектов.

Минимальные права:

| Сценарий | Scope |
| -------- | ----- |
| Скачать `.cfe` из Package Registry приватного проекта | `read_api` |
| Читать project/package metadata через API | `read_api` |

Как хранить в 1С:

- в справочнике `пм_ИсточникиПакетов`, реквизит `ТокенДоступа`;
- поле должно быть скрыто/замаскировано на форме;
- токен нельзя хранить в коде, шаблонах CI, README и логах.

HTTP-заголовок:

```http
PRIVATE-TOKEN: <token>
```

## GitLab CI: публикация package

Для публикации из GitLab CI обычно отдельный токен не нужен. Шаблон использует:

```http
JOB-TOKEN: ${CI_JOB_TOKEN}
```

Если публикация идёт из внешней CI-системы (Jenkins), нужен токен с правом записи package.

Минимальные права:

| Сценарий | Scope |
| -------- | ----- |
| Загрузить файл в GitLab Generic Package Registry | `api` |

Где хранить:

- GitLab CI/CD variables: `GITLAB_PACKAGE_TOKEN`;
- Jenkins credentials: `gitlab-package-token`.

## Jenkins

Ожидаемые credentials:

| Credentials id | Назначение |
| -------------- | ---------- |
| `gitlab-api-url` | URL GitLab API, например `https://gitlab.example.com/api/v4` |
| `gitlab-project-id` | ID проекта GitLab |
| `gitlab-package-token` | Token с правом публикации package |

## Справка объекта настройки

В справке/описании объекта `пм_ИсточникиПакетов` нужно указать:

- для публичного проекта поле токена оставить пустым;
- для приватного проекта создать токен в GitLab и заполнить `ТокенДоступа`;
- токен должен иметь минимально необходимые права;
- токен нельзя отправлять в техническую поддержку, коммиты и скриншоты.
