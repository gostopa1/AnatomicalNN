rng('shuffle');
model.type='classification';
model.layersizes=[layers];
model.layersizesinitial=model.layersizes;

model.N=size(x,1);
model.batchsize=20;

model.target=y;

if ~exist('epochs')
    epochs=1000;
end

model.epochs=epochs;
model.update=100;
model.fe_update=100000;
model.fe_thres=0.1/model.layersizes(1);
model.l1=0;
model.l2=0;
noins=size(x,2);
noouts=size(y,2);
lr=0.001; activation='tanhact';
model.optimizer='ADAM'; % Options: SGD, SGD_m, RMSprop_m

model.errofun='cross_entropy_cost'; % Options: 'quadratic_cost'
        
for layeri=1:(length(layers)-1)
    model.layers(layeri).activation=activation;
    model.layers(layeri).lr=lr;
    model.layers(layeri).blr=lr;
    model.layers(layeri).Ws=[layers(layeri) layers(layeri+1)];
    model.layers(layeri).W=single((randn(layers(layeri),layers(layeri+1)))*sqrt(2/(model.layersizes(layeri)+model.layersizes(layeri+1))));
    model.layers(layeri).B=single(zeros(layers(layeri+1),1));
    model.layers(layeri).inds=1:model.layersizes(layeri); % To keep track of which nodes are removed etc
    
end

model.layers(layeri).activation='softmaxact';

model.x_test=single(x_test);
model.y_test=single(y_test);
model.x=single(x);
model.y=single(y);
