#Если Сервер Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует текст шаблона публикации пакета.
//
// Параметры:
//  ТипCI - Строка - GitLab, Jenkins, GitHub или Gitea.
//  Параметры - Структура - PACKAGE_NAME, CFE_NAME, CFE_PATH.
//
// Возвращаемое значение:
//  Строка - Текст шаблона.
//
Функция СформироватьШаблон(ТипCI, Параметры) Экспорт
	
	Если ТипCI = "GitLab" Тогда
		Возврат ШаблонGitLab(Параметры);
	ИначеЕсли ТипCI = "Jenkins" Тогда
		Возврат ШаблонJenkins(Параметры);
	ИначеЕсли ТипCI = "GitHub" Тогда
		Возврат ШаблонGitHub(Параметры);
	ИначеЕсли ТипCI = "Gitea" Тогда
		Возврат ШаблонGitea(Параметры);
	КонецЕсли;
	
	ВызватьИсключение СтрШаблон(НСтр("ru = 'Неизвестный тип CI/CD: %1.'"), ТипCI);
	
КонецФункции

Функция НовыеПараметрыШаблона() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("PACKAGE_NAME", "package-manager");
	Параметры.Вставить("CFE_NAME", "package-manager.cfe");
	Параметры.Вставить("CFE_PATH", "dist/package-manager.cfe");
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ШаблонGitLab(Параметры)
	
	Возврат СтрШаблон(
"stages:
|  - build
|  - package
|
|variables:
|  PACKAGE_NAME: ""%1""
|  CFE_NAME: ""%2""
|  CFE_PATH: ""%3""
|
|build:cfe:
|  stage: build
|  rules:
|    - if: $CI_COMMIT_TAG
|  script:
|    - test -f ""${CFE_PATH}""
|  artifacts:
|    paths:
|      - ""${CFE_PATH}""
|    expire_in: 1 day
|
|package:gitlab:
|  stage: package
|  rules:
|    - if: $CI_COMMIT_TAG
|  needs:
|    - job: build:cfe
|      artifacts: true
|  script:
|    - >
|      curl --fail
|      --header ""JOB-TOKEN: ${CI_JOB_TOKEN}""
|      --upload-file ""${CFE_PATH}""
|      ""${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/${PACKAGE_NAME}/${CI_COMMIT_TAG}/${CFE_NAME}""
|",
		Параметры.PACKAGE_NAME,
		Параметры.CFE_NAME,
		Параметры.CFE_PATH);
	
КонецФункции

Функция ШаблонJenkins(Параметры)
	
	Возврат СтрШаблон(
"pipeline {
|    agent any
|    environment {
|        PACKAGE_NAME = '%1'
|        CFE_NAME = '%2'
|        CFE_PATH = '%3'
|    }
|    stages {
|        stage('Build CFE') {
|            steps {
|                sh 'test -f ""${CFE_PATH}""'
|                archiveArtifacts artifacts: ""${CFE_PATH}"", fingerprint: true
|            }
|        }
|    }
|}
|",
		Параметры.PACKAGE_NAME,
		Параметры.CFE_NAME,
		Параметры.CFE_PATH);
	
КонецФункции

Функция ШаблонGitHub(Параметры)
	
	Возврат СтрШаблон(
"name: Publish package artifact
|
|on:
|  push:
|    tags:
|      - ""*""
|
|env:
|  CFE_NAME: %1
|  CFE_PATH: %2
|",
		Параметры.CFE_NAME,
		Параметры.CFE_PATH);
	
КонецФункции

Функция ШаблонGitea(Параметры)
	
	Возврат СтрШаблон(
"name: Publish package artifact
|
|on:
|  push:
|    tags:
|      - ""*""
|
|env:
|  CFE_NAME: %1
|  CFE_PATH: %2
|",
		Параметры.CFE_NAME,
		Параметры.CFE_PATH);
	
КонецФункции

#КонецОбласти

#КонецЕсли
