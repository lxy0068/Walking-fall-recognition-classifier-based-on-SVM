clear;
dir=('C:\Users\Xingyan Liu\Desktop\SVM\pictures');
testdir=('C:\Users\Xingyan Liu\Desktop\SVM\testPictures\test');
trainingSet = imageSet(dir,'recursive');
testSet = imageSet(testdir,'recursive');

% ��ȡѵ�����Ͳ��Լ��������ͱ�ǩ
[trainingFeatures, trainingLabels, testFeatures, testLabels] = extractFeature(trainingSet, testSet);

%% ѵ��SVM������
% ʹ��fitcecoc��������1��1�Ķ������
classifier = fitcecoc(trainingFeatures, trainingLabels);
save classifier.mat classifier; % ����ѵ���õķ�����

% ʹ�÷������Բ��Լ���ͼ����������Ԥ��
predictedLabels = predict(classifier, testFeatures);

%% ������������Ч��
% ʹ�ò��Լ��ı�ǩ��Ԥ�������ɻ������󣬲���������׼ȷ��
confMat = confusionmat(testLabels, predictedLabels);
accuracy = (confMat(1,1) / sum(confMat(1,:)) + confMat(2,2) / sum(confMat(2,:))) / 2;

% ʹ����ѵ���ķ�������ָ��ͼƬ����Ԥ��
Predict('C:\Users\Xingyan Liu\Desktop\SVM\testPictures\test\not-fall\115.jpg');