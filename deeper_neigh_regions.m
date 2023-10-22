%% Add paths and start measuring time
addPaths

tic
%% Load Haxby dataset

merge_right_left=0;
haxby_dataset;

%%
clear model

layers=[noins noins size(W_regions,2) noouts];
model.layersizes=[layers];

common_model_initialization
model.layers(1).W=W_conv;
model.layers(1).lr=regionlr;
model.layers(2).W=W_regions;
model.layers(2).lr=regionlr;

layeri=3;
model.layers(layeri).W=single((randn(layers(layeri),layers(layeri+1)))*sqrt(2/(model.layersizes(layeri)/nocats+model.layersizes(layeri+1))));
maskW=model.layers(layeri).W*0; for i=1:nocats, maskW((1:num_regions)+(i-1)*num_regions,i)=1; end; model.layers(layeri).W=model.layers(layeri).W.*maskW;

%% Training and importance extraction

training_and_importance_extraction


%% Saving section

ID=randi(100000000000);
time_elapsed=toc

direxist=0;

while direxist==0
    ID=randi(100000000000);
    result_dir=['./results/N' num2str(convradius) 'R/N' num2str(convradius) 'R_' mms '_' num2str(perm) '_sub' num2str(subi) '_epochs' num2str(model.epochs) '_' sprintf('lr%2.3f',model.layers(1).lr) '/rep'  num2str(ID) '/'];
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
