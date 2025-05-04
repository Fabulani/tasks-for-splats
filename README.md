# Tasks for Splats

> Making Gaussian Splatting research repos easier to set up and use, one Dockerfile at a time.

This is a multi-project repository focusing on making Gaussian Splatting research repositories easier to set up and use. I use [Tasks](https://taskfile.dev/) and Docker for setting everything up, with Github Container Registry for housing the built images.

Currently, the following projects are available:

| **task**                             | **category**                        | **status** | **note**                                             | **link**                                                                                                                                                  |
| ------------------------------------ | ----------------------------------- | ---------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `3dgscd`                             | change detection                    | 🚧         | OOM during tests; couldn't test 'running the method' | [3D Gaussian Splatting-based Change Detection for Physical Object Rearrangement](https://github.com/520xyxyzq/3DGS-CD/tree/main)                          |
| `3dgsconverter`                      | format conversion                   | ✅         |                                                      | [3D Gaussian Splatting Converter](https://github.com/francescofugazzi/3dgsconverter)                                                                      |
| `gsplat`                             | rasterization                       | ✅         |                                                      | [gsplat: An Open-Source Library for Gaussian Splatting](https://github.com/nerfstudio-project/gsplat)                                                     |
| `hierarchical-3d-gaussians`, `h3dgs` | hierarchy                           | 🚧         | viewer doesn't work, needs more testing              | [A Hierarchical 3D Gaussian Representation for Real-Time Rendering of Very Large Datasets](https://repo-sam.inria.fr/fungraph/hierarchical-3d-gaussians/) |
| `nerfstudio`, `ns`                   | library, segmentation, open-vocab   | ✅         | feature-splatting ready for use                      | [Nerfstudio: A collaboration friendly studio for NeRFs](https://docs.nerf.studio/index.html)                                                              |
| `spatiallm`, `slm`                   | scene understanding, point cloud    | ✅         |                                                      | [SpatialLM: Large Language Model for Spatial Understanding](https://manycore-research.github.io/SpatialLM/)                                               |
| `supersplat`, `ss`                   | visualization, editing, compression | ✅         |                                                      | [Supersplat: 3D Gaussian Splat Editor](https://github.com/playcanvas/supersplat)                                                                          |

✅: done | 🚧: work-in-progress.

## Pre-requisites

Install [Tasks](https://taskfile.dev/installation/) and [Docker](https://docs.docker.com/engine/install/).

## Setup

Duplicate/rename `.env.example` to `.env`, and add the path to your datasets folder, e.g.:

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
1. Create a folder for the project using the template `.templates/project`. Project folders usually contain the following:

   ```txt
   project_name/
   └── docker/
      ├── docker-compose.yml
      ├── Dockerfile
   └── README.md
   └── Taskfile.yaml
   ```

2. Rename and edit the template files.
3. Additional files needed for the container go inside the project `docker` folder.
4. Check that all tasks from the new project work.
5. Open a PR and wait for the merge!
