function [] = Predict(imageurl)
% 此函数用于预测给定图像URL的分类结果，并显示预测标签

% 加载已训练好的分类器模型
load classifier.mat;

% 创建一个新图形窗口并显示图像
figure;
img = imread(imageurl); % 读取图像文件
imshow(img); % 显示原始图像
img = imresize(img, [512 512]); % 调整图像大小到512x512像素

% 提取图像的特征向量
img = rgb2gray(img); % 将图像转换为灰度图

% 检测图像中的SURF特征点并提取这些点的特征
points = detectSURFFeatures(img);
f1 = extractFeatures(img, points);
a = numel(f1); % 计算特征点数量
b = reshape(f1, 1, a); % 将特征向量转换为一维数组
c = b(1:2900); % 选取前2900个特征，确保特征向量长度一致

% 将灰度图像转换为二值图像
lvl = graythresh(img); % 计算全局阈值
img = im2bw(img, lvl); % 应用阈值，生成二值图像

% 提取HOG和GLCM特征
hog_4x4 = extractHOGFeatures(img, 'CellSize', [4 4]); % 提取HOG特征，使用4x4的单元格大小
glcm_feature = getGLCMFeatures(img); % 提取GLCM特征

% 合并所有特征作为最终的测试特征
testFeature = [c hog_4x4 glcm_feature];

% 使用分类器预测图像的标签
predictedLabel = predict(classifier, testFeature);

% 在图像上显示预测结果
str = ['分类结果：' predictedLabel]; % 准备显示的文本，包括预测的标签
dim = [0.25 0.0004 0.2 0.2]; % 设置文本框位置和大小
annotation('textbox', dim, 'string', str, 'fontsize', 20, 'color', 'r', 'edgecolor', 'none');