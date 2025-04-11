# SpatialLM

Website: [SpatialLM](https://manycore-research.github.io/SpatialLM/)

From their page:

> SpatialLM is a 3D large language model designed to process 3D point cloud data and generate structured 3D scene understanding outputs. These outputs include architectural elements like walls, doors, windows, and oriented object bounding boxes with their semantic categories. Unlike previous methods that require specialized equipment for data collection, SpatialLM can handle point clouds from diverse sources such as monocular video sequences, RGBD images, and LiDAR sensors. This multimodal architecture effectively bridges the gap between unstructured 3D geometric data and structured 3D representations, offering high-level semantic understanding. It enhances spatial reasoning capabilities for applications in embodied robotics, autonomous navigation, and other complex 3D scene analysis tasks.

## Dataset

> [!IMPORTANT]
> Input point clouds are considered axis-aligned, with z-axis being the UP axis.

You need a reconstructed point cloud. This README assumes `.ply` format for point clouds.

If you have a RGB video, SpatialLM recommends using [SLAM3R](https://github.com/PKU-VCL-3DV/SLAM3R) or [MASt3R-SLAM](https://github.com/rmurai0610/MASt3R-SLAM) for obtaining a point cloud. Instructions for SLAM3R can be found [in their example readme](https://github.com/manycore-research/SpatialLM/blob/main/EXAMPLE.md).

## Usage

Run inference with

```sh
python inference.py --point_cloud data/YOUR_PCD.ply --output data/YOUR_PCD.txt --model_path manycore-research/SpatialLM-Llama-1B
```

where `YOUR_PCD` is the name of your point cloud file.

Convert layout file to Rerun format:

```sh
python visualize.py --point_cloud data/YOUR_PCD.ply --layout data/YOUR_PCD.txt --save YOUR_PCD.rrd
```

Open Rerun web viewer to visualize the results:

```sh
rerun --web-viewer
```

Access it at <http://localhost:9090>. Click on the icon at the top-left, then `Open`, or just `CTRL+O`, and select your `.rrd` file.

Check the [Rerun docs](https://rerun.io/docs/getting-started/what-is-rerun) for instructions on how to use the viewer.

---

For further details, see the [SpatialLM documentation](https://github.com/manycore-research/SpatialLM?tab=readme-ov-file#usage).
