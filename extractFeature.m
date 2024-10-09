function [trainingFeatures, trainingLabels, testFeatures, testLabels] = extractFeature(trainingSet, testSet)
% ��ʼ�������ͱ�ǩ����
trainingFeatures = [];
trainingLabels = [];
testFeatures = [];
testLabels = [];

cellSize = [4 4]; % ���õ�Ԫ���С����HOG����
SizeOfFeature = NaN;  % ���ڴ洢���������ĳ���

for setType = 1:2  % ѭ������ѵ�����Ͳ��Լ�
    if setType == 1
        imageSet = trainingSet; % �����1������ѵ����
    else
        imageSet = testSet; % ��������Լ�
    end
    
    features = [];
    labels = [];

    for digit = 1:numel(imageSet) % ����ÿ��������������ļ���
        numImages = imageSet(digit).Count; % ��ȡ��ǰ����µ�ͼƬ����
        for i = 1:numImages % ����ÿ��ͼƬ
            img = read(imageSet(digit), i); % ��ȡͼƬ
            if isempty(img)
                continue; % ���ͼƬΪ�գ�������
            end
            img = imresize(img, [512 512]); % ����ͼƬ��С��512x512
            img = rgb2gray(img); % ת��Ϊ�Ҷ�ͼ
            img = im2bw(img, graythresh(img)); % ʹ��ȫ����ֵת��Ϊ��ֵͼ��
            
            % ��ȡ����
            points = detectSURFFeatures(img); % ���SURF������
            surfFeatures = extractFeatures(img, points); % ��ȡSURF����
            surfFeatures = surfFeatures(:)';
            if numel(surfFeatures) < 2900
                surfFeatures = [surfFeatures zeros(1, 2900 - numel(surfFeatures))]; % �����������2900����0���
            else
                surfFeatures = surfFeatures(1:2900); % ����ȡǰ2900������
            end
            
            hogFeatures = extractHOGFeatures(img, 'CellSize', cellSize); % ��ȡHOG����
            glcmFeatures = getGLCMFeatures(img); % �������������ȷ�����ˣ���ȡGLCM����
            
            totalFeatures = [surfFeatures, hogFeatures, glcmFeatures]; % �ϲ���������
            if isnan(SizeOfFeature)
                SizeOfFeature = length(totalFeatures); % ����ǵ�һ�Σ���ʼ��������������
            elseif length(totalFeatures) ~= SizeOfFeature
                error('������С��ƥ�䡣'); % ����������Ȳ�һ�£�����
            end
            
            features = [features; totalFeatures]; % ������������ӵ���������
            labels = [labels; string(imageSet(digit).Description)]; % ������ת��Ϊ�ַ�������ӵ���ǩ�б�
        end
    end
    
    if setType == 1
        trainingFeatures = features; % ��ֵѵ��������
        trainingLabels = labels; % ��ֵѵ������ǩ
    else
        testFeatures = features; % ��ֵ���Լ�����
        testLabels = labels; % ��ֵ���Լ���ǩ
    end
end

fprintf('ѵ����������: %d, ѵ����ǩ����: %d\n', size(trainingFeatures, 1), numel(trainingLabels));
fprintf('������������: %d, ���Ա�ǩ����: %d\n', size(testFeatures, 1), numel(testLabels));

% ����ѵ�����Ͳ��Լ����������ǩ����ƥ��
assert(size(trainingFeatures, 1) == numel(trainingLabels), 'ѵ�����������ǩ������ƥ��');
assert(size(testFeatures, 1) == numel(testLabels), '���Լ��������ǩ������ƥ��');
end