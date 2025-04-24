# SAGA (Segment Any 3D GAussians)

Website: [SAGA (Segment Any 3D GAussians)](https://jumpat.github.io/SAGA/)

From their page:

> This paper presents SAGA (Segment Any 3D GAussians), a highly efficient 3D promptable segmentation method based on 3D Gaussian Splatting (3D-GS). Given 2D visual prompts as input, SAGA can segment the corresponding 3D target represented by 3D Gaussians within 4 ms. This is achieved by attaching an scale-gated affinity feature to each 3D Gaussian to endow it a new property towards multi-granularity segmentation. Specifically, a scale-aware contrastive training strategy is proposed for the scale-gated affinity feature learning. It 1) distills the segmentation capability of the Segment Anything Model (SAM) from 2D masks into the affinity features and 2) employs a soft scale gate mechanism to deal with multi-granularity ambiguity in 3D segmentation through adjusting the magnitude of each feature channel according to a specified 3D physical scale. Evaluations demonstrate that SAGA achieves real-time multi-granularity segmentation with quality comparable to state-of-the-art methods. As one of the first methods addressing promptable segmentation in 3D-GS, the simplicity and effectiveness of SAGA pave the way for future advancements in this field. Our code is available at this url.

## Dataset

This method requires a pre-trained 3DGS model. Either train using the provided algorithm (original 3DGS), or provide a COLMAP dataset. Considering the `garden` dataset as an example, this is the project structure:

```txt
./data
    /360_v2
        /garden
            /images
            /images_2
            /images_4
            /images_8
            /sparse         # COLMAP
            /features       # SAGA generated
            /sam_masks      # SAGA generated
            /mask_scales    # SAGA generated
```

## Usage

QUICKSTART, TIPS, SPECIFIC INFO ON USING THE PROJECT INSIDE THE CONTAINER.

---

For further details, see the [PROJECT_NAME documentation](LINK_TO_DOCUMENTATION_IF_IT_EXISTS).
