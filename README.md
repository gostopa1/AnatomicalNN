# Main scripts:
## Neural network structures
* `deeper_simple`: Structure with no hidden layer, denoted as S
* `deeper_regions`: Neural with a Regions layer, denoted as R
* `deeper_neigh`: Neural network structure with a Neighborhood layer, denoted as N
* `deeper_neigh_regions`: Neural network structure with a Neighborhood layer and a Regions layer, denoted as N#R

Each of these scripts generates results under the following directory:

`results/<model type>/<model_type>_<spatial_resolution>_<permutation_or_not>_sub<subject number>`

There each run has a random ID, creating a subdirectory e.g. `rep19297038625`.
The following variables are stored there with the following names:
* `conf.mat`: A confusion matrix to represent classifications for each individual class. Classification accuracy per category can be derived based on this.
* `impos.mat`: A struct that stores all the importance values for each layer.
* `overfitting.mat`: Storing accuracy and loss during training for the training and the test set to generate figures of the accuracy regarding overfitting.
* `perf.mat`: A single number storing the classification accuracy of the run.
* `time_elapsed.mat`: Storing the time that it took to run the script.

## Auxiliary scripts (used by the the scripts above)
* `haxby_dataset`: script for loading the dataset and the related weights for initialization
* `common_model_initialization`: Script to initialize the model for each case
* `training_and_importance_extraction`: Script to train the model and to get the importance maps for the model