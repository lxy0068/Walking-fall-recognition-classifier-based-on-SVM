# Walking-fall-recognition-classifier-based-on-SVM

## Project Overview

This project aims to classify images using a Support Vector Machine (SVM) classifier. The project includes scripts for feature extraction from images and predicting their classes based on these features. It uses techniques such as SURF (Speeded-Up Robust Features), HOG (Histogram of Oriented Gradients), and GLCM (Gray Level Co-occurrence Matrix) to generate a feature set for image classification.(2023)(Business)

## Files in the Project

### 1. `Predict.m`
This script predicts the class of a given image using a pre-trained SVM classifier (`classifier.mat`). It first resizes the input image, extracts features (SURF, HOG, and GLCM), and uses the classifier to predict the label.

- **Inputs:** 
  - `imageurl`: The path to the image file to be classified.
  
- **Outputs:** 
  - Displays the image with the predicted label shown as an annotation on the image.

- **Key Functions Used:**
  - `imread`, `imresize`, `rgb2gray`, `detectSURFFeatures`, `extractFeatures`, `extractHOGFeatures`, `graythresh`, `im2bw`
  - Custom function `getGLCMFeatures.m` is used for extracting GLCM features.

Example usage:
```matlab
Predict('path_to_image');
```

### 2. `classifierOfSVM.m`
This script is used for training the SVM classifier and saving the trained model. It loads a set of training and test images, extracts features from these images using the `extractFeature.m` function, and trains an SVM classifier using the `fitcecoc` function for multi-class classification. After training, it evaluates the classifier's performance on a test set and saves the trained model as `classifier.mat`.

- **Inputs:** 
  - Image directories for training and test sets.
  
- **Outputs:** 
  - Trained classifier saved as `classifier.mat`.
  - Performance evaluation (confusion matrix and accuracy).

- **Key Functions Used:**
  - `fitcecoc`, `predict`, `confusionmat`

### 3. `extractFeature.m`
This function is responsible for extracting features from a set of images for both the training and test datasets. It extracts SURF, HOG, and GLCM features from each image, and standardizes the length of the feature vectors.

- **Inputs:** 
  - `trainingSet`: Set of training images.
  - `testSet`: Set of test images.

- **Outputs:**
  - `trainingFeatures`, `trainingLabels`: Features and labels for the training set.
  - `testFeatures`, `testLabels`: Features and labels for the test set.

### 4. `getGLCMFeatures.m`
This script extracts GLCM (Gray Level Co-occurrence Matrix) features from a grayscale image. The GLCM is computed in four different directions (0°, 45°, 90°, and 135°) for a range of displacements. From each GLCM, statistical properties like contrast, correlation, energy, and homogeneity are extracted.

- **Inputs:**
  - `image`: Grayscale image.
  
- **Outputs:**
  - `features`: GLCM features for the input image.

## Usage Instructions

### Training the SVM Classifier
1. Prepare your image datasets. Place training images and test images in separate folders.
2. Set the directory paths in `classifierOfSVM.m` for the training and test image sets.
3. Run the `classifierOfSVM.m` script to train the classifier and save the model.

### Predicting Image Classes
1. Make sure the `classifier.mat` file (trained model) is available in your working directory.
2. Use the `Predict.m` script to classify an image by providing its path:
   ```matlab
   Predict('path_to_image');
   ```

## Dependencies

This project is implemented in MATLAB. The following toolboxes or functions are used:
- Image Processing Toolbox
- Computer Vision Toolbox (for SURF, HOG feature extraction)
