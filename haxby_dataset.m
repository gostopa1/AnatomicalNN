tic

if ~exist('readAll')
    readAll=0;
end

%readAll=0; % To read data of individual subjects instead of reading the one big matrix that contains all the data
if ~exist('perm')
    perm=0;
end

if ~exist('regionlr')
    regionlr=0.001;
end

if ~exist('mms')
    mms='32mm'
end

if ~exist('convradius')
    convradius=3;
end

if ~exist('imp_calc')
    imp_calc=1;
end

if ~exist('subi')
    subi=2;
end

if ~exist('perm')
    perm=0;
end

if ~exist('merge_right_left')
    merge_right_left=1;
end


%% Initializing some variables before loading the data
nosubs=6;
x_test=[]; x=[]; y=[]; y_test=[];

%% To read the data from one big matrix (readAll=1) or from data of inidividual subjects (readAll=0). The latter is faster
if readAll==1
    tps=1:5;
    load(['../Haxby_preprocessing/data/Haxby_' mms '.mat']);
    D=mean(D(:,:,:,:,:,tps),6);
    %D=D/max(abs(D(:))); % if needed to normalize the data

    s=size(D);
    subinds=setxor(subi,1:nosubs);
    novoxels=s(5);
    nocats=s(1);

    D_train=reshape(permute(D(:,subinds,:,:,1:novoxels),[5 1 2 3 4]),novoxels,s(1),length(subinds)*s(3)*s(4));
    D_test=reshape(permute(D(:,subi,:,:,1:novoxels),[5 1 2 3 4]),novoxels,s(1),1*s(3)*s(4));
    snew_train=size(D_train);
    snew_test=size(D_test);

    labs_test=[];  labs_train=[];

    for cati=1:nocats
        x=[x ; squeeze(D_train(:,cati,:))'];
        x_test=[x_test ; squeeze(D_test(:,cati,:))'];
        vec=zeros(nocats,1);
        vec(cati)=1;

        labs_train=[labs_train repmat(cati,1,(snew_train(3)))];
        labs_test=[labs_test repmat(cati,1,(snew_test(3)))];
    end

    if perm>0;
        labs_train=labs_train(randperm(length(labs_train)));
    end

    y=dummyvar(labs_train);
    y_test=dummyvar(labs_test);

    clear D % Clean up the D matrix, not needed anymore
else
    subinds=setxor(subi,1:nosubs);
    for sub=subinds
        data = load(['../../Haxby_preprocessing/data/IndividualSubjects/' mms '_sub' num2str(sub) '.mat']);
        x=[x ; data.x];
        y=[y ; data.y];
    end
    data_test = load(['../../Haxby_preprocessing/data/IndividualSubjects/' mms '_sub' num2str(subi) '.mat']);
    x_test = data_test.x;
    y_test = data_test.y;
    nocats = size(y_test,2);

    if perm>0;
        y = y(randperm(size(y,1)),:);
    end
end
noins=size(x,2);
noouts=size(y,2);

display('Data read!')

%% Read weights for neighborhood layer
load(['../../whole_brain_masks/distance' num2str(convradius) '_weights_' mms '.mat'])
W_conv=(single(W));

%% Read weights atlas for regions layer

if merge_right_left==1
    load(['../../whole_brain_masks/anatomical_weights_both_' mms '.mat'])
else
    load(['../../whole_brain_masks/anatomical_weights_both_' mms '_all.mat'])

end
W_regions=(single(W));

%% Repeat set of regions weights for each category per category
num_regions=size(W_regions,2);
W_regions=repmat(W_regions,1,nocats);


%% Report time
s = seconds(toc);
disp(['Read data in: '])
s.Format = 'hh:mm:ss'

