%% Training and importance extraction

%clear x y
%clear x_test y_test
clear D_test D_train
clear W_conv W_regions W


model.optimizer='ADAM'; % Options: SGD, SGD_m, RMSprop_m

tic 
[~,model]=model_train_lowmem(model);
%[~,model]=model_train(model);
toc
[model,out_test]=forwardpassing(model,[model.x_test]); perf=get_perf(out_test,model.y_test);
conf=get_conf(out_test,model.y_test);

[~,machine]=system('hostname');
if strcmp(machine(1:end-1),'jouni.nbe.aalto.fi')
    %show_network(model)
end
display('Done with training. Now extracting importances ... ')

for layeri=1:length(model.layers)
    try 
    model.layers=rmfield(model.layers,'mdedw');
    catch
    end
    try 
    model.layers=rmfield(model.layer,'mdedw_sq');
    catch
    end
    try
    model.layers=rmfield(model.layers,'u');
    catch
    end
    try
    model.layers=rmfield(model.layers,'m');
    catch
    end
    
end

%%
if imp_calc
display('Extracting importances')
%[~,imp]=extract_LRPWX(model,model.x_test);
%[~,imp]=extract_LRP(model,model.x_test);
[~,imp]=extract_LRP_lowmem(model,model.x_test);
%[~,imp]=extract_LRPWX_lowmem(model,model.x_test);

for layeri=1:length(model.layers)
    imp(layeri).R=mean(imp(layeri).R,3);
end
end
display('Done!')


display(' ')
display(['Classification accuracy: ' sprintf('%2.2f',perf)])

figure_error_test = model.figure.error_test; figure_error_train = model.figure.error_train; 
figure_perf_test = model.figure.perf_test; figure_perf_train = model.figure.perf_train;
figure_iters = model.figure.iters;
