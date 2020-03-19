% This code has been developed by Ali Rahmani Nejad at IASBS for educational puporses

clear all
%% INITIALIZATIONS
fid = fopen('features.txt');
data(:,1) = fscanf(fid, '%f');
fid = fopen('labels.txt');
data(:,2) = fscanf(fid, '%f');  % column one coresponds to ...
                                % X (feature) and 2nd column Y (lables)

train = data(1:80,:);
test = data(81:100,:);

clear fid data;

p = 1;
q = 5;
lambda = 10;

%% SPLINE LINEAR REGRESSION

% Train phase

[train,I] = sortrows(train,1);
feats_train = train(:,1);
labels_train = train(:,2);
min = min(feats_train);
max = max(feats_train);

k = linspace(min,max,q);

X = [ones(80,1), feats_train];


figure;

for i=1:q
    trainPart = feats_train(feats_train > k(i) & feats_train < k(i+1));
    idxs = find(feats_train > k(i) & feats_train < k(i+1));
    labelsPart =  labels_train(idxs,:);
    phi = ones(size(trainPart,1),1);
    for j=1:p
        phi = [phi trainPart.^j];
    end
    for j=1:q
        temp = trainPart - k(j);
        temp(temp<0) = 0;
        phi = [phi (temp).^p];
    end
    Beta = inv(phi'*phi + 2*lambda* eye( p+q+1)) * phi' * labelsPart;
    syms xx
    Model = 1 * Beta(1) + (Beta(2) * xx);
    for j=1:q
           Model = Model + Beta(p+j) * (xx - k(j)).^p;
    end
    
    subplot(1,q,i)
    xlim([k(i) k(i+1)]);    
    fplot(poly2sym(Model), 'red') % draw the function    
    hold on;
    scatter(trainPart, labelsPart, 'blue','filled')
    hold on;
end



base_W = (Beta(1:p+1,:))';
funcs = [];
syms xx aa

for i=1:q
   funcs(i,:) = base_W + (Beta(p+i+1) * coeffs((xx-aa)^p));
   base_W = funcs(i,:);
end

