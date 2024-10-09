clear;
dir=('C:\Users\Xingyan Liu\Desktop\SVM\pictures');
testdir=('C:\Users\Xingyan Liu\Desktop\SVM\testPictures\test');
trainingSet = imageSet(dir,'recursive');
testSet = imageSet(testdir,'recursive');

% 提取训练集和测试集的特征和标签
[trainingFeatures, trainingLabels, testFeatures, testLabels] = extractFeature(trainingSet, testSet);

%% 训练SVM分类器
% 使用fitcecoc函数进行1对1的多类分类
classifier = fitcecoc(trainingFeatures, trainingLabels);
save classifier.mat classifier; % 保存训练好的分类器

% 使用分类器对测试集的图像特征进行预测
predictedLabels = predict(classifier, testFeatures);

%% 评估分类器的效果
% 使用测试集的标签和预测结果生成混淆矩阵，并计算分类的准确度
confMat = confusionmat(testLabels, predictedLabels);
accuracy = (confMat(1,1) / sum(confMat(1,:)) + confMat(2,2) / sum(confMat(2,:))) / 2;

% 使用已训练的分类器对指定图片进行预测
Predict('C:\Users\Xingyan Liu\Desktop\SVM\testPictures\test\not-fall\115.jpg');