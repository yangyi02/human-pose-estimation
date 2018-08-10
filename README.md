# Articulated Human Pose Estimation with Flexible Mixtures-of-Parts

## Introduction

This is a Matlab implementation of the human pose estimation algorithm described in [1]. It includes pre-trained full-body and upper-body models. Much of the detection code is built on top of part-based model implementation of [2]. The training code implements a quadratic program (QP) solver described in [3].

To illustrate the use of the training code, this package also uses positive images from the PARSE dataset [4], the BUFFY dataset [5], and negative images from the INRIA Person Background dataset [6]. We also include the PCP evaluation code from [5] for benchmark evaluation on both datasets. The original evaluation code assumes a rigid-template detector, and we make modifications for our deformable skeleton detector.

Compatibility issues: The training code requires 7.5GB of memory. Modify line 32/33 in `code_full/learning/train.m` to use less memory at the cost of longer training times.

Acknowledgements: We graciously thank the authors of the previous code releases and image benchmarks for making them publically available.

## Using the detection code

1. Move to the `code_basic` directory
2. Start Matlab (version > 2013a).
3. Run `compile.m` to compile the helper functions. (You may also edit `compile.m` to use a different convolution routine depending on your system.)
4. Run `demo.m` to see the detection code run on sample images.
5. By default, the code is set to output the highest-scoring detection in an image.

## Using the learning code

1. Move to the `code_full` directory
2. Download the PARSE dataset (MB), BUFFY dataset (MB) and INRIA Person Background dataset (59MB), put them into `code_full/data/PARSE`, `code_full/data/BUFFY` and `code_full/data/INRIA` respectively. Or you can simply call `bash download_data.sh` in Linux system. 
3. Start Matlab (version > 2013a).
4. Run `compile.m` to compile the helper functions. (You may also edit `compile.m` to use a different convolution routine depending on your system.)
5. Run `PARSE_demo.m` or `BUFFY_demo.m` to see the complete system including training and benchmark evaluation.

## References

[1] Y. Yang, D. Ramanan. [Articulated Pose Estimation using Flexible Mixtures of Parts](https://yangyi02.github.io/research/pose/pose_cvpr2011.pdf). CVPR 2011.

[2] P. Felzenszwalb, R. Girshick, D. McAllester. [Discriminatively Trained Deformable Part Models](http://www.rossgirshick.info/latent/). PAMI 2010.

[3] D. Ramanan. [Dual Coordinate Descent Solvers for Large Structured Prediction Problems](https://arxiv.org/pdf/1312.1743.pdf). UCI Technical Report 2014.

[4] D. Ramanan. Learning to Parse Images of Articulated Bodies. NIPS 2006.

[5] V. Ferrari, Marcin Eichner, M. J. Marin-Jimenez, A. Zisserman. [Buffy Stickmen V3.01: Annotated data and evaluation routines for 2D human pose estimation](http://www.robots.ox.ac.uk/~vgg/data/stickmen/index.html). IJCV 2012. 

[6] N. Dalal, B. Triggs. Histograms of Oriented Gradients for Human Detection. CVPR 2005.

## Version Update

pose-release-v1.3
1. New convolution and other necessary files for windows machine to run our program.
2. New PCK and APK benchmarks, delete the old PCP criteria.
3. New functions for getting the highest score detection with overlap requirement.
4. First iteration joint training uses fixed mixture labels.
5. New visualization functions for showing the highest score detection and multiple detections.
6. New training code.
7. New non-maximum suppression after detection.

pose-release-v1.2
First time release
