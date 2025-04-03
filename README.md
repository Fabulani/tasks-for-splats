# Tasks for Splats

> Making Gaussian Splatting research repos easier to set up and use, one Dockerfile at a time.

This is a multi-project repository focusing on making Gaussian Splatting research repositories easier to set up and use. I use [Tasks](https://taskfile.dev/) and Docker for setting everything up, with Github Container Registry for housing the built images.

## Pre-requisites

Install [Tasks](https://taskfile.dev/installation/) and [Docker](https://docs.docker.com/engine/install/).

## Setup

Create a `.env` file in the project root and add the path to your datasets folder, e.g.:

```txt
DATA_PATH="//c/path/to/datasets"
```

This path will be bound to a docker volume and become available inside the containers `data` folder.

> [!IMPORTANT]
> On Windows, the path must start with two forward slashes (/). For a path in the C drive: "//c/path/to/datasets"

## Usage

Type `task` to see all available tasks and their descriptions. For `.env` to work, run all tasks from the main root Taskfile.

To work on a specific project, run the tasks associated with that project. For example, with `gsplat`, the following should be enough:

```bash
task gsplat:pull
task gsplat:run
```

These will pull the image, run the container, and exec into it. Every project has this set of tasks: `clone`, `build`, `pull`, `push`, and `run`.

> [!NOTE]
> Read the README.md in each project for project-specific instructions.

The `-all` tasks are for batch execution of tasks from all projects. For example, to clone all repositories:

```bash
task clone-all
```

## Development

Adding new projects follows this workflow:

0. Create and checkout a new branch.
1. Create a folder for the project. Project folders usually contain the following:

   ```txt
   project_name/
   └── docker/
      ├── docker-compose.yml
      ├── Dockerfile
   └── README.md
   └── Taskfile.yaml
   ```

2. Copy needed templates from the `./.templates` folder (e.g., `Taskfile.template.yaml`, `README.template.md`, and `docker-compose.template.yml`). Rename and customize them as needed.
3. Add Dockerfile and other necessary files to the `docker` folder.
4. Check that all tasks from the new project work.
5. Open a PR and wait for the merge!
