# Task templates

This folder contains some useful templates used accross tasks.

## Taskfile.template.yaml

This is a template for new project Taskfiles. Can be duplicated and customized as needed per project.

## Taskfile.common.yaml

This Taskfile defines a set of commonly used tasks and should always be imported for use.

`task:build` has the following line in the `docker build` command:

```sh
{{- range $key, $value := .BUILD_ARGS }} --build-arg {{$key}}={{$value}} {{- end}}
```

This line generates `--build-arg .BUILD_ARGS.ITEM` arguments for the command. If `.BUILD_ARGS` is not defined, it is skipped.

Note that, as of now, Taskfile does not support maps, but there is a workaround using REF: <https://taskfile.dev/usage/#variables>. Use this to define `BUILD_ARGS`, if needed.

## docker-compose.template.yml

A template for docker-compose files. The container will be GPU-enabled (NVIDIA) and interactive (bash).

## README.template.md

A template for project READMEs. Replace all text in UPPER CASE.
