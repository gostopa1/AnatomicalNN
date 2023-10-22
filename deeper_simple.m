%% Add paths and start measuring time
addPaths

tic
%% Load Haxby dataset

merge_right_left=0;
if (exist('x') && exist('y') && exist('x_test') && exist('y_test'))
    disp("Data loaded already, no need to load again")
else
    haxby_dataset;    
end

%%

layers=[noins noouts];

common_model_initialization


%% Training and importance extraction

training_and_importance_extraction

%% Saving section

ID=randi(100000000000);
time_elapsed=toc;
direxist=0;

while direxist==0
    ID=randi(100000000000);
    result_dir=['./results/S/S_' mms '_' num2str(perm) '_sub' num2str(subi) '_epochs' num2str(model.epochs) '_' sprintf('lr%2.3f',model.layers(1).lr) '/rep'  num2str(ID) '/'];
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
save([ result_dir 'regionlr.mat'],'regionlr');