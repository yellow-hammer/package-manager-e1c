# CI/CD templates

Шаблоны помогают быстро добавить в проект расширения шаг публикации пакета.

## GitLab CI

Файл: `gitlab/package.gitlab-ci.yml`

Публикует `.cfe` в GitLab Generic Package Registry:

```http
/api/v4/projects/{projectId}/packages/generic/{packageName}/{version}/{fileName}
```

Переменные:

| Переменная | Назначение |
| ---------- | ------------ |
| `PACKAGE_NAME` | Имя package в GitLab Package Registry |
| `CFE_NAME` | Имя файла `.cfe` |
| `CFE_PATH` | Путь к собранному `.cfe` |

Токен для GitLab CI не нужен: используется `CI_JOB_TOKEN`.

Для чтения package из приватного проекта в 1С нужен отдельный токен. Требования описаны в `doc/TOKENS.md`.

## Jenkins

Файл: `jenkins/Jenkinsfile.package`

Ожидаемые credentials:

| Credentials id | Назначение |
| ---------- | ------------ |
| `gitlab-api-url` | URL GitLab API, например `https://gitlab.example.com/api/v4` |
| `gitlab-project-id` | ID проекта GitLab |
| `gitlab-package-token` | Token с правом публикации package |

## GitHub Actions

Файл: `github/package-release.yml`

Заготовка второго этапа: публикует `.cfe` как GitHub Release asset.

## Gitea Actions

Файл: `gitea/package-release.yml`

Заготовка третьего этапа: создает release через Gitea API и загружает `.cfe` как asset. Требуется secret `GITEA_TOKEN`.

## Генерация из 1С

В расширении `package-manager` должна быть обработка `пм_ГенераторШаблоновПубликации`, которая подставляет значения `PACKAGE_NAME`, `CFE_NAME`, путь к файлу и показывает итоговый шаблон пользователю.
