%% Add paths and start measuring time
addPaths

tic
%% Load Haxby dataset
haxby_dataset;

%% Set up model
clear model

layers=[noins noins noouts];

common_model_initialization
model.layers(1).W=W_conv;
model.layers(1).lr=regionlr;

%% Training and importance extraction
training_and_importance_extraction

%% Saving section
ID=randi(100000000000);
time_elapsed=toc

direxist=0;

while direxist==0
    ID=randi(100000000000);
    result_dir=['./results/N' num2str(convradius) '/N' num2str(convradius) '_' mms '_' num2str(perm) '_sub' num2str(subi) '/rep'  num2str(ID) '/'];
    if (isdir(result_dir)==1)
        ID=randi(100000000000);
    else
        direxist=1;
    end
end
mkdir(result_dir);
if imp_calc
    
    save([ result_dir 'impos.mat'],'imp');
end


save([ result_dir 'overfitting.mat'],'figure_error_test',"figure_error_train","figure_perf_test","figure_perf_train","figure_iters");

save([ result_dir 'perf.mat'],'perf');
save([ result_dir 'time_elapsed.mat'],'time_elapsed');

save([ result_dir 'conf.mat'],'conf');