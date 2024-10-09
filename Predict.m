function [] = Predict(imageurl)
% �˺�������Ԥ�����ͼ��URL�ķ�����������ʾԤ���ǩ

% ������ѵ���õķ�����ģ��
load classifier.mat;

% ����һ����ͼ�δ��ڲ���ʾͼ��
figure;
img = imread(imageurl); % ��ȡͼ���ļ�
imshow(img); % ��ʾԭʼͼ��
img = imresize(img, [512 512]); % ����ͼ���С��512x512����

% ��ȡͼ�����������
img = rgb2gray(img); % ��ͼ��ת��Ϊ�Ҷ�ͼ

% ���ͼ���е�SURF�����㲢��ȡ��Щ�������
points = detectSURFFeatures(img);
f1 = extractFeatures(img, points);
a = numel(f1); % ��������������
b = reshape(f1, 1, a); % ����������ת��Ϊһά����
c = b(1:2900); % ѡȡǰ2900��������ȷ��������������һ��

% ���Ҷ�ͼ��ת��Ϊ��ֵͼ��
lvl = graythresh(img); % ����ȫ����ֵ
img = im2bw(img, lvl); % Ӧ����ֵ�����ɶ�ֵͼ��

% ��ȡHOG��GLCM����
hog_4x4 = extractHOGFeatures(img, 'CellSize', [4 4]); % ��ȡHOG������ʹ��4x4�ĵ�Ԫ���С
glcm_feature = getGLCMFeatures(img); % ��ȡGLCM����

% �ϲ�����������Ϊ���յĲ�������
testFeature = [c hog_4x4 glcm_feature];

% ʹ�÷�����Ԥ��ͼ��ı�ǩ
predictedLabel = predict(classifier, testFeature);

% ��ͼ������ʾԤ����
str = ['��������' predictedLabel]; % ׼����ʾ���ı�������Ԥ��ı�ǩ
dim = [0.25 0.0004 0.2 0.2]; % �����ı���λ�úʹ�С
annotation('textbox', dim, 'string', str, 'fontsize', 20, 'color', 'r', 'edgecolor', 'none');