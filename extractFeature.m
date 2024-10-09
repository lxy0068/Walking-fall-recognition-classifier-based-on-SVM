function [trainingFeatures, trainingLabels, testFeatures, testLabels] = extractFeature(trainingSet, testSet)
% 初始化特征和标签数组
trainingFeatures = [];
trainingLabels = [];
testFeatures = [];
testLabels = [];

cellSize = [4 4]; % 设置单元格大小用于HOG特征
SizeOfFeature = NaN;  % 用于存储特征向量的长度

for setType = 1:2  % 循环处理训练集和测试集
    if setType == 1
        imageSet = trainingSet; % 如果是1，处理训练集
    else
        imageSet = testSet; % 否则处理测试集
    end
    
    features = [];
    labels = [];

    for digit = 1:numel(imageSet) % 遍历每个数字类别或类别文件夹
        numImages = imageSet(digit).Count; % 获取当前类别下的图片数量
        for i = 1:numImages % 遍历每张图片
            img = read(imageSet(digit), i); % 读取图片
            if isempty(img)
                continue; % 如果图片为空，则跳过
            end
            img = imresize(img, [512 512]); % 调整图片大小至512x512
            img = rgb2gray(img); % 转换为灰度图
            img = im2bw(img, graythresh(img)); % 使用全局阈值转换为二值图像
            
            % 提取特征
            points = detectSURFFeatures(img); % 检测SURF特征点
            surfFeatures = extractFeatures(img, points); % 提取SURF特征
            surfFeatures = surfFeatures(:)';
            if numel(surfFeatures) < 2900
                surfFeatures = [surfFeatures zeros(1, 2900 - numel(surfFeatures))]; % 如果特征不足2900，用0填充
            else
                surfFeatures = surfFeatures(1:2900); % 否则取前2900个特征
            end
            
            hogFeatures = extractHOGFeatures(img, 'CellSize', cellSize); % 提取HOG特征
            glcmFeatures = getGLCMFeatures(img); % 假设这个函数正确定义了，提取GLCM特征
            
            totalFeatures = [surfFeatures, hogFeatures, glcmFeatures]; % 合并所有特征
            if isnan(SizeOfFeature)
                SizeOfFeature = length(totalFeatures); % 如果是第一次，初始化特征向量长度
            elseif length(totalFeatures) ~= SizeOfFeature
                error('特征大小不匹配。'); % 如果特征长度不一致，报错
            end
            
            features = [features; totalFeatures]; % 将特征向量添加到特征矩阵
            labels = [labels; string(imageSet(digit).Description)]; % 将描述转换为字符串并添加到标签列表
        end
    end
    
    if setType == 1
        trainingFeatures = features; % 赋值训练集特征
        trainingLabels = labels; % 赋值训练集标签
    else
        testFeatures = features; % 赋值测试集特征
        testLabels = labels; % 赋值测试集标签
    end
end

fprintf('训练特征数量: %d, 训练标签数量: %d\n', size(trainingFeatures, 1), numel(trainingLabels));
fprintf('测试特征数量: %d, 测试标签数量: %d\n', size(testFeatures, 1), numel(testLabels));

% 断言训练集和测试集的特征与标签数量匹配
assert(size(trainingFeatures, 1) == numel(trainingLabels), '训练集特征与标签数量不匹配');
assert(size(testFeatures, 1) == numel(testLabels), '测试集特征与标签数量不匹配');
end