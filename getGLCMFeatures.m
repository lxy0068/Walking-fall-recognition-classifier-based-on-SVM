function [features] = getGLCMFeatures(image)
% 此函数计算并返回图像的灰度共生矩阵(GLCM)特征
features_all = [];  % 初始化存储所有特征的数组

for i = 1:10
    % 计算图像在0度方向上，位移量为i的GLCM
    glcm = graycomatrix(image, 'Offset', [0,i]);
    stats = graycoprops(glcm);  % 计算GLCM的统计属性
    
    % 计算图像在45度方向上，位移量为i的GLCM
    glcm45 = graycomatrix(image, 'Offset', [-i,i]);
    stats45 = graycoprops(glcm45);  % 计算GLCM的统计属性
    
    % 计算图像在90度方向上，位移量为i的GLCM
    glcm90 = graycomatrix(image, 'Offset', [-i,0]);
    stats90 = graycoprops(glcm90);  % 计算GLCM的统计属性
    
    % 计算图像在135度方向上，位移量为i的GLCM
    glcm135 = graycomatrix(image, 'Offset', [-i,-i]);
    stats135 = graycoprops(glcm135);  % 计算GLCM的统计属性
    
    % 将四个方向的统计属性合并到一个数组中
    stats7x4 = [stats.Contrast stats.Correlation stats.Energy stats.Homogeneity;
                stats45.Contrast stats45.Correlation stats45.Energy stats45.Homogeneity;
                stats90.Contrast stats90.Correlation stats90.Energy stats90.Homogeneity;
                stats135.Contrast stats135.Correlation stats135.Energy stats135.Homogeneity];
    
    % 计算每个属性的平均值和标准差，并将这些值添加到特征数组中
    features_all = [features_all mean(stats7x4, 1) std(stats7x4, 0, 1)];
end

% 返回图像的所有GLCM特征
features = features_all;
