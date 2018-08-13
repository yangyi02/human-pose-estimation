# Articulated Human Pose Estimation with Flexible Mixtures-of-Parts

## Introduction

This is a Matlab implementation of the human pose estimation algorithm described in [1, 2]. It includes pre-trained full-body and upper-body models. Much of the detection code is built on top of deformable part-based model implementation [3]. The training code implements a quadratic program (QP) solver described in [4].

The code is trained and tested using positive images from the PARSE dataset [5], the BUFFY dataset [6], and negative images from the INRIA Person Background dataset [7].

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
2. Download the PARSE dataset (2.5MB), BUFFY dataset (21MB) and INRIA Person Background dataset (59MB), put them into `data/PARSE`, `data/BUFFY` and `data/INRIA` respectively. Or you can simply call `bash download_data.sh` in Linux system. 
3. Start Matlab (version > 2013a).
4. Run `compile.m` to compile the helper functions. (You may also edit `compile.m` to use a different convolution routine depending on your system.)
5. Run `PARSE_demo.m` or `BUFFY_demo.m` to see the complete system including training and benchmark evaluation.

## References

[1] Y. Yang, D. Ramanan. [Articulated Pose Estimation using Flexible Mixtures of Parts](https://yangyi02.github.io/research/pose/index.html). CVPR 2011.

[2] Y. Yang, D. Ramanan. [Articulated Human Detection with Flexible Mixtures of Parts](https://yangyi02.github.io/research/pose/index.html). PAMI 2013.

[3] P. Felzenszwalb, R. Girshick, D. McAllester, D. Ramanan. [Discriminatively Trained Deformable Part Models](http://www.rossgirshick.info/latent/). PAMI 2010.

[4] D. Ramanan. [Dual Coordinate Descent Solvers for Large Structured Prediction Problems](https://arxiv.org/pdf/1312.1743.pdf). UCI Technical Report 2014.

[5] D. Ramanan. [Learning to Parse Images of Articulated Bodies](https://www.cs.cmu.edu/~deva/papers/parse/index.html). NIPS 2006.

[6] V. Ferrari, M. Eichner, M. Marin-Jimenez, A. Zisserman. [Buffy Stickmen V3.01: Annotated data and evaluation routines for 2D human pose estimation](http://www.robots.ox.ac.uk/~vgg/data/stickmen/index.html). IJCV 2012. 

[7] N. Dalal, B. Triggs. [Histograms of Oriented Gradients for Human Detection](http://pascal.inrialpes.fr/data/human/). CVPR 2005.

## Version Update

pose-release-v1.4
1. Springs depend on both parent and child mixtures, not child mixtures any more.
2. Co-occurrence term learns hard mixtures co-occurrence (two mixtures never co-occur) during training.
3. New visualization codes for visualizing data, model, clustering results etc.
4. Remove latent mixture update during joint training 
5. New data structure for human detection and pose estimation.
6. Clustering features for every part depend on its parent and children.

|      | Head | Shou | Elbo | Wris | Hip  | Knee | Ankl | Avg  |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| APK  | 88.3 | 83.9 | 54.3 | 34.9 | 76.2 | 65.5 | 57.5 | 65.8 |
| PCK  | 92.0 | 87.8 | 65.6 | 50.0 | 81.2 | 74.9 | 69.3 | 74.4 | 

pose-release-v1.3
1. New convolution and other necessary files for windows machine to run the code.
2. New PCK and APK benchmarks, delete the old PCP criteria.
3. New functions for getting the highest score detection with overlap requirement.
4. First iteration joint training uses fixed mixture labels.
5. New visualization functions for showing the highest score detection and multiple detections.
6. New training code.
7. New non-maximum suppression after detection.

|      | Head | Shou | Elbo | Wris | Hip  | Knee | Ankl | Avg  |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| APK  | 86.9 | 83.9 | 57.2 | 30.6 | 73.9 | 62.6 | 56.4 | 64.5 |
| PCK  | 89.5 | 86.8 | 67.6 | 48.0 | 80.2 | 74.6 | 69.5 | 73.8 | 

pose-release-v1.2
First time release
